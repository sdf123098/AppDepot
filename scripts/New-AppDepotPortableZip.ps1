[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string] $PublishDirectory,

    [Parameter(Mandatory)]
    [string] $OutputPath
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $PublishDirectory -PathType Container)) {
    throw "Publish directory does not exist: $PublishDirectory"
}

$publishRoot = (Resolve-Path -LiteralPath $PublishDirectory).Path
if (-not (Test-Path -LiteralPath (Join-Path $publishRoot 'AppDepot.exe') -PathType Leaf)) {
    throw "The publish directory does not contain AppDepot.exe: $publishRoot"
}

$files = @(Get-ChildItem -LiteralPath $publishRoot -Recurse -File)
if ($files.Count -eq 0) { throw "Publish directory is empty: $publishRoot" }

$outputFullPath = [System.IO.Path]::GetFullPath($OutputPath)
$outputParent = Split-Path -Parent $outputFullPath
if ($outputParent) { New-Item -ItemType Directory -Path $outputParent -Force | Out-Null }
if (Test-Path -LiteralPath $outputFullPath) { Remove-Item -LiteralPath $outputFullPath -Force }

Compress-Archive -Path (Join-Path $publishRoot '*') -DestinationPath $outputFullPath -CompressionLevel Optimal -Force
Write-Host "Created portable ZIP: $outputFullPath"
