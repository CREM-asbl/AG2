#Requires -Version 5.1
<#
.SYNOPSIS Package Linux: tgz depuis build IDE (racine AG2 propre, sans surcouche ./).
#>
[CmdletBinding()]
param()
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$t0 = Get-Date
$root = Split-Path $PSScriptRoot -Parent
$ver = (Get-Content (Join-Path $root "VERSION") -Raw).Trim()
$builds = Join-Path $root "Builds - AG"
$dist = Join-Path $builds "dist"
New-Item -ItemType Directory -Path $dist -Force | Out-Null
$src = Get-ChildItem -Path $builds -Directory | Where-Object { $_.Name -match "Linux" } | Select-Object -First 1
if (-not $src) { throw "Dossier build Linux introuvable sous $builds" }
$appDir = Join-Path $src.FullName "AG2"
if (-not (Test-Path $appDir -PathType Container)) { throw "Dossier app AG2 introuvable sous $($src.FullName)" }
Copy-Item (Join-Path $root "Changelog.md") (Join-Path $appDir "Changelog.md") -Force
$stage = Join-Path $env:TEMP "ag2-linux-stage"
Remove-Item -Recurse -Force $stage -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path (Join-Path $stage "AG2") | Out-Null
Copy-Item (Join-Path $appDir "*") (Join-Path $stage "AG2") -Recurse -Force
$tgz = Join-Path $dist "AG2-$ver-linux-x64.tgz"
if (Test-Path $tgz) { Remove-Item $tgz -Force }
& tar -czf $tgz -C $stage AG2 2>&1 | Select-Object -First 10
if (-not (Test-Path $tgz)) { throw "Echec creation $tgz" }
$sec = [math]::Round(((Get-Date) - $t0).TotalSeconds, 1)
$mb = [math]::Round((Get-Item $tgz).Length / 1MB, 1)
Write-Output "package-linux : $tgz (${mb}MB, ${sec}s)"
