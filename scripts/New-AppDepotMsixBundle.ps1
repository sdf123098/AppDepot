[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string] $InputDirectory,

    [Parameter(Mandatory)]
    [string] $OutputPath,

    [Parameter(Mandatory)]
    [ValidatePattern('^\d+\.\d+\.\d+\.\d+$')]
    [string] $Version,

    [string] $WindowsSdkRoot
)

$ErrorActionPreference = 'Stop'

function Find-WindowsSdkTool([string] $toolName, [string] $sdkRoot) {
    $command = Get-Command $toolName -ErrorAction SilentlyContinue
    if ($command) { return $command.Source }

    $searchRoots = @()
    if (-not [string]::IsNullOrWhiteSpace($sdkRoot)) { $searchRoots += $sdkRoot }
    $searchRoots += Join-Path ${env:ProgramFiles(x86)} 'Windows Kits\10\bin'

    foreach ($searchRoot in $searchRoots | Select-Object -Unique) {
        if (-not (Test-Path -LiteralPath $searchRoot -PathType Container)) { continue }
        $candidate = Get-ChildItem -Path $searchRoot -Filter $toolName -Recurse -File -ErrorAction SilentlyContinue |
            Sort-Object FullName -Descending | Select-Object -First 1
        if ($candidate) { return $candidate.FullName }
    }

    throw "Windows SDK tool '$toolName' was not found. Install the Windows 10/11 SDK."
}

if (-not (Test-Path -LiteralPath $InputDirectory -PathType Container)) {
    throw "MSIX input directory does not exist: $InputDirectory"
}

$inputRoot = (Resolve-Path -LiteralPath $InputDirectory).Path
$packages = @(Get-ChildItem -LiteralPath $inputRoot -Filter '*.msix' -File | Sort-Object Name)
if ($packages.Count -lt 2) {
    throw "At least two architecture-specific MSIX files are required to create a bundle."
}

$architectures = @('x86', 'x64', 'arm64')
foreach ($architecture in $architectures) {
    $matches = @($packages | Where-Object Name -match "-win-$architecture\.msix$")
    if ($matches.Count -ne 1) {
        throw "Expected exactly one MSIX for architecture '$architecture', found $($matches.Count)."
    }
}

$outputFullPath = [System.IO.Path]::GetFullPath($OutputPath)
$outputParent = Split-Path -Parent $outputFullPath
if ($outputParent) { New-Item -ItemType Directory -Path $outputParent -Force | Out-Null }
if (Test-Path -LiteralPath $outputFullPath) { Remove-Item -LiteralPath $outputFullPath -Force }

$makeAppx = Find-WindowsSdkTool 'makeappx.exe' $WindowsSdkRoot
$stageRoot = Join-Path ([System.IO.Path]::GetTempPath()) "AppDepot-msixbundle-$([guid]::NewGuid().ToString('N'))"
New-Item -ItemType Directory -Path $stageRoot -Force | Out-Null

try {
    foreach ($package in $packages) {
        Copy-Item -LiteralPath $package.FullName -Destination (Join-Path $stageRoot $package.Name) -Force
    }

    & $makeAppx bundle /d $stageRoot /p $outputFullPath /bv $Version /o
    if ($LASTEXITCODE -ne 0) {
        throw "MakeAppx bundle failed with exit code $LASTEXITCODE."
    }

    Write-Host "Created unsigned Store-ready MSIXBundle: $outputFullPath"
}
finally {
    if (Test-Path -LiteralPath $stageRoot) {
        Remove-Item -LiteralPath $stageRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
}
