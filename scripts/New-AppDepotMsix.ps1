[CmdletBinding()]
# Pass -WindowsSdkRoot when the Windows SDK is installed outside the default
# Program Files location, for example: -WindowsSdkRoot D:\Winsdk.
param(
    [Parameter(Mandatory)]
    [string] $PublishDirectory,

    [Parameter(Mandatory)]
    [string] $OutputPath,

    [Parameter(Mandatory)]
    [ValidateSet('x86', 'x64', 'arm64')]
    [string] $Architecture,

    [Parameter(Mandatory)]
    [ValidatePattern('^\d+\.\d+\.\d+\.\d+$')]
    [string] $Version,

    [string] $WindowsSdkRoot,

    [switch] $Sign,

    [string] $CertificatePath,

    [string] $CertificateThumbprint
)

$ErrorActionPreference = 'Stop'

function Find-WindowsSdkTool([string] $toolName, [string] $sdkRoot) {
    $command = Get-Command $toolName -ErrorAction SilentlyContinue
    if ($command) {
        return $command.Source
    }

    $searchRoots = @()
    if (-not [string]::IsNullOrWhiteSpace($sdkRoot)) {
        $searchRoots += $sdkRoot
    }
    $searchRoots += Join-Path ${env:ProgramFiles(x86)} 'Windows Kits\10\bin'

    foreach ($searchRoot in $searchRoots | Select-Object -Unique) {
        if (-not (Test-Path -LiteralPath $searchRoot -PathType Container)) {
            continue
        }

        $candidate = Get-ChildItem -Path $searchRoot -Filter $toolName -Recurse -File -ErrorAction SilentlyContinue |
            Sort-Object FullName -Descending |
            Select-Object -First 1
        if ($candidate) {
            return $candidate.FullName
        }
    }

    throw "Windows SDK tool '$toolName' was not found. Install the Windows 10/11 SDK."
}

if (-not (Test-Path -LiteralPath $PublishDirectory -PathType Container)) {
    throw "Publish directory does not exist: $PublishDirectory"
}

$publishRoot = (Resolve-Path -LiteralPath $PublishDirectory).Path
$outputFullPath = [System.IO.Path]::GetFullPath($OutputPath)
$outputParent = Split-Path -Parent $outputFullPath
if ($outputParent) {
    New-Item -ItemType Directory -Path $outputParent -Force | Out-Null
}

$publisher = 'CN=AppDepot'
if ($Sign) {
    if (-not [string]::IsNullOrWhiteSpace($CertificatePath) -and
        -not [string]::IsNullOrWhiteSpace($CertificateThumbprint)) {
        throw 'Specify either -CertificatePath or -CertificateThumbprint, not both.'
    }

    if (-not [string]::IsNullOrWhiteSpace($CertificateThumbprint)) {
        $normalizedThumbprint = $CertificateThumbprint.Replace(' ', '').ToUpperInvariant()
        $certificate = Get-ChildItem "Cert:\CurrentUser\My\$normalizedThumbprint" -ErrorAction SilentlyContinue
        if (-not $certificate -or -not $certificate.HasPrivateKey) {
            throw "A certificate with a private key was not found in Cert:\CurrentUser\My: $normalizedThumbprint"
        }
    }
    else {
        if ([string]::IsNullOrWhiteSpace($CertificatePath) -or
            -not (Test-Path -LiteralPath $CertificatePath -PathType Leaf)) {
            throw 'A valid -CertificatePath or -CertificateThumbprint is required when -Sign is specified.'
        }

        $certificatePassword = $env:CERT_PASSWORD
        if ([string]::IsNullOrWhiteSpace($certificatePassword)) {
            throw 'CERT_PASSWORD must be set when signing an MSIX from a PFX.'
        }

        $certificate = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new(
            (Resolve-Path -LiteralPath $CertificatePath).Path,
            $certificatePassword)
    }
    $publisher = $certificate.Subject
}

$makeAppx = Find-WindowsSdkTool 'makeappx.exe' $WindowsSdkRoot
$signtool = if ($Sign) { Find-WindowsSdkTool 'signtool.exe' $WindowsSdkRoot }
$templatePath = Join-Path $PSScriptRoot '..\packaging\AppxManifest.xml.template'
if (-not (Test-Path -LiteralPath $templatePath -PathType Leaf)) {
    throw "MSIX manifest template not found: $templatePath"
}

$stageRoot = Join-Path ([System.IO.Path]::GetTempPath()) "AppDepot-msix-$([guid]::NewGuid().ToString('N'))"
New-Item -ItemType Directory -Path $stageRoot -Force | Out-Null

try {
    Copy-Item -Path (Join-Path $publishRoot '*') -Destination $stageRoot -Recurse -Force

    $logoPath = Join-Path $stageRoot 'Assets\AppDepot.png'
    if (-not (Test-Path -LiteralPath $logoPath -PathType Leaf)) {
        throw "MSIX logo is missing from the publish output: $logoPath"
    }

    $manifest = [System.IO.File]::ReadAllText((Resolve-Path -LiteralPath $templatePath).Path)
    $publisherXml = [System.Security.SecurityElement]::Escape($publisher)
    $manifest = $manifest.Replace('__PUBLISHER__', $publisherXml)
    $manifest = $manifest.Replace('__VERSION__', $Version)
    $manifest = $manifest.Replace('__ARCHITECTURE__', $Architecture)
    [System.IO.File]::WriteAllText(
        (Join-Path $stageRoot 'AppxManifest.xml'),
        $manifest,
        [System.Text.UTF8Encoding]::new($false))

    if (Test-Path -LiteralPath $outputFullPath) {
        Remove-Item -LiteralPath $outputFullPath -Force
    }

    & $makeAppx pack /d $stageRoot /p $outputFullPath /o
    if ($LASTEXITCODE -ne 0) {
        throw "MakeAppx failed with exit code $LASTEXITCODE."
    }

    if ($Sign) {
        if (-not [string]::IsNullOrWhiteSpace($CertificateThumbprint)) {
            & $signtool sign /fd SHA256 /sha1 $normalizedThumbprint /tr http://timestamp.digicert.com /td SHA256 $outputFullPath
        }
        else {
            & $signtool sign /fd SHA256 /a /f (Resolve-Path -LiteralPath $CertificatePath).Path /p $certificatePassword /tr http://timestamp.digicert.com /td SHA256 $outputFullPath
        }
        if ($LASTEXITCODE -ne 0) {
            throw "SignTool failed with exit code $LASTEXITCODE."
        }
    }

    Write-Host "Created MSIX: $outputFullPath"
}
finally {
    if (Test-Path -LiteralPath $stageRoot) {
        Remove-Item -LiteralPath $stageRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
}
