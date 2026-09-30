[CmdletBinding()]
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
    [string] $Version
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $PublishDirectory -PathType Container)) {
    throw "Publish directory does not exist: $PublishDirectory"
}

$publishRoot = (Resolve-Path -LiteralPath $PublishDirectory).Path
$outputFullPath = [System.IO.Path]::GetFullPath($OutputPath)
$outputParent = Split-Path -Parent $outputFullPath
if ($outputParent) {
    New-Item -ItemType Directory -Path $outputParent -Force | Out-Null
}

$wixCommand = Get-Command wix -ErrorAction SilentlyContinue
if (-not $wixCommand) {
    throw 'WiX CLI was not found. Install it with: dotnet tool install --global wix --version 6.0.2'
}

$files = @(Get-ChildItem -LiteralPath $publishRoot -Recurse -File)
if ($files.Count -eq 0) {
    throw "Publish directory is empty: $publishRoot"
}

if (-not ($files | Where-Object Name -eq 'AppDepot.exe')) {
    throw 'The publish directory does not contain AppDepot.exe.'
}

function New-DirectoryNode {
    return [pscustomobject]@{
        Files = [System.Collections.Generic.List[object]]::new()
        Children = @{}
    }
}

function Get-StableIdentifier([string] $prefix, [string] $value) {
    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    try {
        $hash = $sha256.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($value))
    }
    finally {
        $sha256.Dispose()
    }

    $hex = ([System.BitConverter]::ToString($hash)).Replace('-', '').ToLowerInvariant()
    return "$prefix$($hex.Substring(0, 24))"
}

function ConvertTo-XmlText([string] $value) {
    return [System.Security.SecurityElement]::Escape($value)
}

$root = New-DirectoryNode
$componentIds = [System.Collections.Generic.List[string]]::new()

foreach ($file in $files) {
    $relativePath = [System.IO.Path]::GetRelativePath($publishRoot, $file.FullName).Replace('/', '\')
    $parts = $relativePath -split '\\'
    $current = $root

    for ($index = 0; $index -lt ($parts.Count - 1); $index++) {
        $directoryName = $parts[$index]
        if (-not $current.Children.ContainsKey($directoryName)) {
            $current.Children[$directoryName] = New-DirectoryNode
        }
        $current = $current.Children[$directoryName]
    }

    $current.Files.Add([pscustomobject]@{
        Name = $parts[$parts.Count - 1]
        RelativePath = $relativePath
        ComponentId = Get-StableIdentifier 'cmp_' $relativePath
        FileId = Get-StableIdentifier 'fil_' $relativePath
    })
}

$xml = [System.Text.StringBuilder]::new()
[void]$xml.AppendLine('<Wix xmlns="http://wixtoolset.org/schemas/v4/wxs">')
[void]$xml.AppendLine("  <Package Name=\"AppDepot\" Manufacturer=\"sdf123098\" Version=\"$Version\" UpgradeCode=\"{D4D7E1C8-8AB2-4E0F-ABCD-7CB8E1D9B0E1}\" Scope=\"perMachine\">")
[void]$xml.AppendLine('    <MajorUpgrade DowngradeErrorMessage="A newer version of AppDepot is already installed." />')
[void]$xml.AppendLine('    <MediaTemplate EmbedCab="yes" />')

$programFilesDirectory = if ($Architecture -eq 'x86') { 'ProgramFilesFolder' } else { 'ProgramFiles64Folder' }
[void]$xml.AppendLine("    <StandardDirectory Id=\"$programFilesDirectory\">")
[void]$xml.AppendLine('      <Directory Id="INSTALLFOLDER" Name="AppDepot">')

function Add-NodeXml($node, [string] $parentDirectoryId, [string] $indent) {
    foreach ($file in @($node.Files | Sort-Object RelativePath)) {
        $componentIds.Add($file.ComponentId)
        $sourcePath = "`$(var.PublishDir)\$($file.RelativePath)"
        $bitness = if ($Architecture -eq 'x86') { 'always32' } else { 'always64' }
        [void]$xml.AppendLine("$indent<Component Id=\"$($file.ComponentId)\" Guid=\"*\" Bitness=\"$bitness\">")
        [void]$xml.AppendLine("$indent  <File Id=\"$($file.FileId)\" Source=\"$(ConvertTo-XmlText $sourcePath)\" KeyPath=\"yes\" />")
        [void]$xml.AppendLine("$indent</Component>")
    }

    foreach ($childName in @($node.Children.Keys | Sort-Object)) {
        $child = $node.Children[$childName]
        $childId = Get-StableIdentifier 'dir_' "$parentDirectoryId/$childName"
        [void]$xml.AppendLine("$indent<Directory Id=\"$childId\" Name=\"$(ConvertTo-XmlText $childName)\">")
        Add-NodeXml $child $childId "$indent  "
        [void]$xml.AppendLine("$indent</Directory>")
    }
}

Add-NodeXml $root 'INSTALLFOLDER' '        '
[void]$xml.AppendLine('      </Directory>')
[void]$xml.AppendLine('    </StandardDirectory>')
[void]$xml.AppendLine('    <StandardDirectory Id="ProgramMenuFolder">')
[void]$xml.AppendLine('      <Directory Id="AppDepotStartMenuFolder" Name="AppDepot">')
[void]$xml.AppendLine('        <Component Id="AppDepotStartMenuShortcut" Guid="{B4C24A6B-2C18-48A0-9E2B-1DBA3D01F45A}">')
[void]$xml.AppendLine('          <Shortcut Id="AppDepotStartMenuShortcutFile" Name="AppDepot" Target="[INSTALLFOLDER]AppDepot.exe" WorkingDirectory="INSTALLFOLDER" />')
[void]$xml.AppendLine('          <RemoveFolder Id="RemoveAppDepotStartMenuFolder" On="uninstall" />')
[void]$xml.AppendLine('          <RegistryValue Root="HKLM" Key="Software\AppDepot" Name="StartMenuShortcut" Type="integer" Value="1" KeyPath="yes" />')
[void]$xml.AppendLine('        </Component>')
[void]$xml.AppendLine('      </Directory>')
[void]$xml.AppendLine('    </StandardDirectory>')
[void]$xml.AppendLine('    <Feature Id="MainFeature" Title="AppDepot" Level="1">')
foreach ($componentId in $componentIds) {
    [void]$xml.AppendLine("      <ComponentRef Id=\"$componentId\" />")
}
[void]$xml.AppendLine('      <ComponentRef Id="AppDepotStartMenuShortcut" />')
[void]$xml.AppendLine('    </Feature>')
[void]$xml.AppendLine('  </Package>')
[void]$xml.AppendLine('</Wix>')

$stageRoot = Join-Path ([System.IO.Path]::GetTempPath()) "AppDepot-msi-$([guid]::NewGuid().ToString('N'))"
New-Item -ItemType Directory -Path $stageRoot -Force | Out-Null
$wxsPath = Join-Path $stageRoot 'AppDepot.wxs'

try {
    [System.IO.File]::WriteAllText($wxsPath, $xml.ToString(), [System.Text.UTF8Encoding]::new($false))
    & $wixCommand.Source build -arch $Architecture -d "PublishDir=$publishRoot" -o $outputFullPath $wxsPath
    if ($LASTEXITCODE -ne 0) {
        throw "WiX build failed with exit code $LASTEXITCODE."
    }

    Write-Host "Created MSI: $outputFullPath"
}
finally {
    if (Test-Path -LiteralPath $stageRoot) {
        [System.IO.Directory]::Delete($stageRoot, $true)
    }
}
