#Requires -Version 5.1
<#
.SYNOPSIS Package macOS: tgz universal (DMG abandonne, pas de compte Apple).
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
$src = Get-ChildItem -Path $builds -Directory | Where-Object { $_.Name -match "macOS|Mac" } | Select-Object -First 1
if (-not $src) { throw "Dossier build macOS introuvable sous $builds" }
$app = Get-ChildItem -Path $src.FullName -Filter "*.app" -Recurse -Directory | Select-Object -First 1
if (-not $app) { throw "Bundle .app introuvable sous $($src.FullName)" }
$tgz = Join-Path $dist "AG2-$ver-macos-universal.tgz"
if (Test-Path $tgz) { Remove-Item $tgz -Force }
& tar -czf $tgz -C $src.FullName . 2>&1 | Select-Object -First 10
if (-not (Test-Path $tgz)) { throw "Echec creation $tgz" }
$sec = [math]::Round(((Get-Date) - $t0).TotalSeconds, 1)
$mb = [math]::Round((Get-Item $tgz).Length / 1MB, 1)
Write-Output "package-macos : $tgz (${mb}MB, ${sec}s)"
