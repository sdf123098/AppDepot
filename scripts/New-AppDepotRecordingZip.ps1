[CmdletBinding()]
param(
    [ValidateSet('x86', 'x64', 'arm64')]
    [string] $Architecture = 'x64',

    [ValidatePattern('^\d+\.\d+\.\d+\.\d+$')]
    [string] $Version = '1.0.0.0'
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$artifactRoot = Join-Path $repoRoot 'recording-artifacts'
$publishRoot = Join-Path $artifactRoot "publish-$Architecture"
$zipPath = Join-Path $artifactRoot "AppDepot-$Version-win-$Architecture-self-contained.zip"

$sdkVersion = (& dotnet --version).Trim()
if (-not $sdkVersion.StartsWith('10.')) {
    throw "AppDepot requires the .NET 10 SDK; detected '$sdkVersion'."
}

if (Test-Path -LiteralPath $artifactRoot) {
    Remove-Item -LiteralPath $artifactRoot -Recurse -Force
}
New-Item -ItemType Directory -Path $publishRoot -Force | Out-Null

dotnet publish (Join-Path $repoRoot 'Raven\Raven.csproj') `
    -c Release `
    -r "win-$Architecture" `
    --self-contained true `
    -p:WindowsAppSDKSelfContained=true `
    -p:DebugSymbols=false `
    -p:DebugType=None `
    -p:Version=$Version `
    -p:AssemblyVersion=$Version `
    -p:FileVersion=$Version `
    -p:InformationalVersion="v$Version" `
    -o $publishRoot
if ($LASTEXITCODE -ne 0) {
    throw "dotnet publish failed with exit code $LASTEXITCODE."
}

$runtimeConfig = Join-Path $publishRoot 'AppDepot.runtimeconfig.json'
if (-not (Test-Path -LiteralPath $runtimeConfig)) {
    throw "Self-contained publish did not produce $runtimeConfig."
}
$runtimeConfigText = [System.IO.File]::ReadAllText($runtimeConfig)
if ($runtimeConfigText -notmatch '"tfm"\s*:\s*"net10\.0') {
    throw 'The recording package does not target .NET 10.'
}

Compress-Archive -Path (Join-Path $publishRoot '*') -DestinationPath $zipPath -CompressionLevel Optimal -Force
Remove-Item -LiteralPath $publishRoot -Recurse -Force

Write-Host "Created clean recording artifact: $zipPath"
