#Requires -Version 5.1
<#
.SYNOPSIS Genere dist/manifest.json (name, version, files[] sha256+size).
#>
[CmdletBinding()]
param()
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
$ver = (Get-Content (Join-Path $root "VERSION") -Raw).Trim()
$dist = Join-Path (Join-Path $root "Builds - AG") "dist"
$files = Get-ChildItem -Path $dist -File | Where-Object { $_.Extension -notin @(".iss", ".json") } | ForEach-Object {
  $h = (Get-FileHash $_.FullName -Algorithm SHA256).Hash.ToLower()
  [ordered]@{ name = $_.Name; size = $_.Length; sha256 = $h }
}
$manifest = [ordered]@{ name = "AG2"; version = $ver; files = @($files) }
$out = Join-Path $dist "manifest.json"
$manifest | ConvertTo-Json -Depth 4 | Set-Content $out -Encoding UTF8
Write-Output "make-manifest: $($files.Count) fichiers -> $out"
