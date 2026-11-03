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

$stage = Join-Path $env:TEMP "ag2-macos-stage"
Remove-Item -Recurse -Force $stage -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $stage | Out-Null

$app = Get-ChildItem -Path $src.FullName -Filter "*.app" -Recurse -Directory -ErrorAction SilentlyContinue | Select-Object -First 1
if ($app) {
  $bundleName = $app.Name
  $destApp = Join-Path $stage $bundleName
  New-Item -ItemType Directory -Force -Path $destApp | Out-Null
  & tar -cf - -C $app.FullName . | tar -xf - -C $destApp
  if ($LASTEXITCODE -ne 0) { throw "Echec copie bundle macOS" }
} else {
  $tar = Get-ChildItem -Path $src.FullName -Filter "*.tar" -File -ErrorAction SilentlyContinue | Select-Object -First 1
  if (-not $tar) { throw "Bundle .app ou .tar introuvable sous $($src.FullName)" }
  $extractRoot = Join-Path $env:TEMP "ag2-macos-extract"
  Remove-Item -Recurse -Force $extractRoot -ErrorAction SilentlyContinue
  New-Item -ItemType Directory -Force -Path $extractRoot | Out-Null
  & tar -xf $tar.FullName -C $extractRoot
  if ($LASTEXITCODE -ne 0) { throw "Echec extraction $($tar.FullName)" }
  $extractedApp = Get-ChildItem -Path $extractRoot -Filter "*.app" -Recurse -Directory -ErrorAction SilentlyContinue | Select-Object -First 1
  if (-not $extractedApp) { throw "Bundle .app introuvable apres extraction" }
  $bundleName = $extractedApp.Name
  $destApp = Join-Path $stage $bundleName
  Move-Item -Path $extractedApp.FullName -Destination $destApp -Force
}

$macOSDir = Join-Path $destApp "Contents\MacOS"
if (Test-Path $macOSDir -PathType Container) { Copy-Item (Join-Path $root "Changelog.md") (Join-Path $macOSDir "Changelog.md") -Force }

$tgz = Join-Path $dist "AG2-$ver-macos-universal.tgz"
if (Test-Path $tgz) { Remove-Item $tgz -Force }
& tar -czf $tgz -C $stage $bundleName 2>&1 | Select-Object -First 10
if (-not (Test-Path $tgz)) { throw "Echec creation $tgz" }
$sec = [math]::Round(((Get-Date) - $t0).TotalSeconds, 1)
$mb = [math]::Round((Get-Item $tgz).Length / 1MB, 1)
Write-Output "package-macos : $tgz (${mb}MB, ${sec}s)"
