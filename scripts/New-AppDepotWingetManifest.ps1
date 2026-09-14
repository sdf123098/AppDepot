[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidatePattern('^\d+\.\d+\.\d+\.\d+$')]
    [string] $Version,

    [Parameter(Mandatory)]
    [string] $ReleaseTag,

    [Parameter(Mandatory)]
    [string] $Repository,

    [Parameter(Mandatory)]
    [string] $AssetDirectory,

    [Parameter(Mandatory)]
    [string] $OutputDirectory,

    [string] $PackageIdentifier = 'sdf123098.AppDepot'
)

$ErrorActionPreference = 'Stop'
$manifestVersion = '1.9.0'
$assetRoot = (Resolve-Path -LiteralPath $AssetDirectory).Path
$outputRoot = [System.IO.Path]::GetFullPath($OutputDirectory)
$packageRoot = Join-Path $outputRoot ($PackageIdentifier -replace '\.', '/')
$versionRoot = Join-Path $packageRoot $Version
New-Item -ItemType Directory -Path $versionRoot -Force | Out-Null

$assetBaseUrl = "https://github.com/$Repository/releases/download/$ReleaseTag"
$architectures = @('x86', 'x64', 'arm64')
$installerEntries = [System.Text.StringBuilder]::new()
$urlEntries = [System.Collections.Generic.List[string]]::new()

foreach ($architecture in $architectures) {
    $assetName = "AppDepot-$Version-windows-$architecture.zip"
    $assetPath = Join-Path $assetRoot $assetName
    if (-not (Test-Path -LiteralPath $assetPath -PathType Leaf)) {
        throw "Release asset not found: $assetPath"
    }

    $hash = (Get-FileHash -LiteralPath $assetPath -Algorithm SHA256).Hash.ToLowerInvariant()
    $url = "$assetBaseUrl/$assetName"
    $urlEntries.Add($url)
    [void]$installerEntries.AppendLine("  - Architecture: $architecture")
    [void]$installerEntries.AppendLine('    InstallerType: zip')
    [void]$installerEntries.AppendLine("    InstallerUrl: $url")
    [void]$installerEntries.AppendLine("    InstallerSha256: $hash")
    [void]$installerEntries.AppendLine('    NestedInstallerType: portable')
    [void]$installerEntries.AppendLine('    NestedInstallerFiles:')
    [void]$installerEntries.AppendLine('      - RelativeFilePath: AppDepot.exe')
    [void]$installerEntries.AppendLine('        PortableCommandAlias: appdepot')
}

$defaultLocale = @"
# yaml-language-server: `$schema=https://aka.ms/winget-manifest.defaultLocale.1.9.0.schema.json
PackageIdentifier: $PackageIdentifier
PackageVersion: $Version
PackageLocale: en-US
Publisher: AppDepot
PublisherUrl: https://github.com/$Repository
PublisherSupportUrl: https://github.com/$Repository/issues
Author: sdf123098
PackageName: AppDepot
PackageUrl: https://github.com/$Repository
License: Apache-2.0
ShortDescription: A free, open-source alternative Microsoft Store client for Windows.
Description: AppDepot is a native Windows application for browsing, downloading, installing, and updating Microsoft Store apps.
Moniker: appdepot
Tags:
  - microsoft-store
  - msix
  - windows
  - portable
ManifestType: defaultLocale
ManifestVersion: $manifestVersion
"@

$installer = @"
# yaml-language-server: `$schema=https://aka.ms/winget-manifest.installer.1.9.0.schema.json
PackageIdentifier: $PackageIdentifier
PackageVersion: $Version
Platform:
  - Windows.Desktop
MinimumOSVersion: 10.0.19041.0
Installers:
$($installerEntries.ToString().TrimEnd())
ManifestType: installer
ManifestVersion: $manifestVersion
"@

$versionManifest = @"
# yaml-language-server: `$schema=https://aka.ms/winget-manifest.version.1.9.0.schema.json
PackageIdentifier: $PackageIdentifier
PackageVersion: $Version
DefaultLocale: en-US
ReleaseNotesUrl: https://github.com/$Repository/releases/tag/$ReleaseTag
ManifestType: version
ManifestVersion: $manifestVersion
"@

[System.IO.File]::WriteAllText((Join-Path $versionRoot "${PackageIdentifier}.locale.en-US.yaml"), $defaultLocale.TrimStart(), [System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllText((Join-Path $versionRoot "${PackageIdentifier}.installer.yaml"), $installer.TrimStart(), [System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllText((Join-Path $versionRoot "${PackageIdentifier}.yaml"), $versionManifest.TrimStart(), [System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllText((Join-Path $outputRoot 'manifest-assets.txt'), ($urlEntries -join [Environment]::NewLine) + [Environment]::NewLine, [System.Text.UTF8Encoding]::new($false))

Write-Host "Generated WinGet manifest: $versionRoot"
