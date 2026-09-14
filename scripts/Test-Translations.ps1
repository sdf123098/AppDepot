param([string]$StringsPath = (Join-Path $PSScriptRoot '../Raven/Strings'))
$ErrorActionPreference = 'Stop'
function Read-Strings([string]$path) {
    $xml = [xml](Get-Content -Raw -LiteralPath $path)
    $result = @{}
    foreach ($item in $xml.root.data) {
        if ($result.ContainsKey($item.name)) { throw "Duplicate key: $path : $($item.name)" }
        $result[$item.name] = [string]$item.value
    }
    return $result
}
function Get-Placeholders([string]$value) {
    # CompositeFormat validates braces, alignment and format specifiers.
    $null = [System.Text.CompositeFormat]::Parse($value)
    return (@([regex]::Matches($value, '(?<!\{)\{(\d+)(?:,[^}:]+)?(?::[^}]+)?\}(?!\})') |
        ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique) -join ',')
}
$reference = Read-Strings (Join-Path $StringsPath 'en-us/Resources.resw')
$failed = $false
foreach ($dir in Get-ChildItem -LiteralPath $StringsPath -Directory | Sort-Object Name) {
    $strings = Read-Strings (Join-Path $dir.FullName 'Resources.resw')
    $missing = @($reference.Keys | Where-Object { -not $strings.ContainsKey($_) })
    $extra = @($strings.Keys | Where-Object { -not $reference.ContainsKey($_) })
    $empty = @($strings.Keys | Where-Object { [string]::IsNullOrWhiteSpace($strings[$_]) })
    $badFormat = @()
    $same = @()
    foreach ($key in $reference.Keys) {
        if (-not $strings.ContainsKey($key)) { continue }
        try {
            if ((Get-Placeholders $strings[$key]) -ne (Get-Placeholders $reference[$key])) { $badFormat += $key }
        } catch { $badFormat += $key }
        if ($dir.Name -ne 'en-us' -and $strings[$key] -ceq $reference[$key]) { $same += $key }
    }
    [pscustomobject]@{ Language=$dir.Name; Keys=$strings.Count; Missing=$missing.Count; Extra=$extra.Count;
        Empty=$empty.Count; InvalidFormat=$badFormat.Count; SameAsEnglish=$same.Count }
    if ($missing.Count + $extra.Count + $empty.Count + $badFormat.Count -gt 0) {
        $failed = $true
        Write-Output "Problems: $(($missing + $extra + $empty + $badFormat | Sort-Object -Unique) -join ', ')"
    }
    if ($same.Count) {
        Write-Output "Review unchanged values ($($dir.Name)):"
        foreach ($key in $same | Sort-Object) { Write-Output "  $key = $($strings[$key])" }
    }
}
if ($failed) { exit 1 }
