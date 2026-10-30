#Requires -Version 5.1
<#
.SYNOPSIS Package Windows: ISCC exe + zip portable.
#>
[CmdletBinding()]
param([ValidateSet("x64", "x86")][string]$Arch = "x64")
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$t0 = Get-Date
$root = Split-Path $PSScriptRoot -Parent
$ver = (Get-Content (Join-Path $root "VERSION") -Raw).Trim()
$builds = Join-Path $root "Builds - AG"
$dist = Join-Path $builds "dist"
New-Item -ItemType Directory -Path $dist -Force | Out-Null
$src = Get-ChildItem -Path $builds -Directory | Where-Object { $_.Name -match "Windows" } | Select-Object -First 1
if (-not $src) { throw "Dossier build Windows introuvable sous $builds (lancer build IDE d'abord)" }
$exe = Get-ChildItem -Path $src.FullName -Filter "AG2.exe" -Recurse | Select-Object -First 1
if (-not $exe) { throw "AG2.exe introuvable sous $($src.FullName)" }
$iss = Join-Path $dist "AG2-$ver-$Arch.iss"
$tpl = Get-Content (Join-Path $PSScriptRoot "AG2.template.iss") -Raw
$tpl = $tpl.Replace("{{VERSION}}", $ver).Replace("{{ARCH}}", $Arch).Replace("{{SRCDIR}}", $exe.DirectoryName).Replace("{{OUTDIR}}", $dist).Replace("{{APPID}}", "{{A7B4C2D1-3E5F-4A6B-8C9D-0E1F2A3B4C5D}}")
$utf8 = New-Object Text.UTF8Encoding $false
[IO.File]::WriteAllText($iss, $tpl, $utf8)
$iscc = "C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
if (-not (Test-Path $iscc)) { throw "ISCC introuvable: $iscc" }
& $iscc $iss 2>&1 | Out-String | Write-Output
$setup = Join-Path $dist "AG2-$ver-windows-$Arch.exe"
if (-not (Test-Path $setup)) { throw "ISCC n'a pas produit $setup" }
$zip = Join-Path $dist "AG2-$ver-windows-$Arch.zip"
if (Test-Path $zip) { Remove-Item $zip -Force }
Compress-Archive -Path ($exe.DirectoryName + "\*") -DestinationPath $zip -CompressionLevel Optimal
$sec = [math]::Round(((Get-Date) - $t0).TotalSeconds, 1)
$mb = [math]::Round((Get-Item $setup).Length / 1MB, 1)
Write-Output "package-windows $Arch : $setup (${mb}MB, ${sec}s)"
