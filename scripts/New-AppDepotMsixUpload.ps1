[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string] $BundlePath,

    [Parameter(Mandatory)]
    [string] $OutputPath
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $BundlePath -PathType Leaf)) {
    throw "MSIXBundle does not exist: $BundlePath"
}
if ([System.IO.Path]::GetExtension($BundlePath) -ine '.msixbundle') {
    throw "Expected an .msixbundle input: $BundlePath"
}

$bundle = (Resolve-Path -LiteralPath $BundlePath).Path
$outputFullPath = [System.IO.Path]::GetFullPath($OutputPath)
$outputParent = Split-Path -Parent $outputFullPath
if ($outputParent) { New-Item -ItemType Directory -Path $outputParent -Force | Out-Null }
if (Test-Path -LiteralPath $outputFullPath) { Remove-Item -LiteralPath $outputFullPath -Force }

$stageRoot = Join-Path ([System.IO.Path]::GetTempPath()) "AppDepot-msixupload-$([guid]::NewGuid().ToString('N'))"
New-Item -ItemType Directory -Path $stageRoot -Force | Out-Null
try {
    # Partner Center accepts an upload file containing one app bundle. Public
    # symbols are optional, so this remains useful for builds without .appxsym.
    Copy-Item -LiteralPath $bundle -Destination (Join-Path $stageRoot ([System.IO.Path]::GetFileName($bundle))) -Force
    Compress-Archive -Path (Join-Path $stageRoot '*') -DestinationPath $outputFullPath -CompressionLevel Optimal -Force
    Write-Host "Created Store upload package: $outputFullPath"
}
finally {
    if (Test-Path -LiteralPath $stageRoot) {
        [System.IO.Directory]::Delete($stageRoot, $true)
    }
}
