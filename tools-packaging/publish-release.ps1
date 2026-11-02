#Requires -Version 5.1
<#
.SYNOPSIS Publie dist/ vers GitHub Release (tag vVERSION).
#>
[CmdletBinding(SupportsShouldProcess)]
param([switch]$Publish)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
$ver = (Get-Content (Join-Path $root "VERSION") -Raw).Trim()
$dist = Join-Path (Join-Path $root "Builds - AG") "dist"
$tag = "v$ver"
$files = Get-ChildItem -Path $dist -File | Where-Object { $_.Extension -notin @(".iss") } | Select-Object -ExpandProperty FullName
if (-not $Publish) { Write-Output "publish-release: DryRun tag $tag :"; $files | ForEach-Object { Write-Output "  $_" }; exit 0 }
if ($PSCmdlet.ShouldProcess($tag, "gh release create")) {
  & gh release create $tag --title "AG2 $ver" --notes-file (Join-Path $root "Changelog.md") -- $files
}
Write-Output "publish-release: $tag OK"
