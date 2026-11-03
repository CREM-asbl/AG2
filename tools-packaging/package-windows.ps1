#Requires -Version 5.1
<#
.SYNOPSIS Package Windows: ISCC exe + zip portable (source arch-dependante, params /D style origine).
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
$buildName = if ($Arch -eq "x64") { "Windows 64 bit" } else { "Windows" }
$src = Join-Path (Join-Path $builds $buildName) "AG2"
if (-not (Test-Path $src -PathType Container)) { throw "Dossier build Windows introuvable: $src (lancer build IDE d'abord)" }
$exe = Get-ChildItem -Path $src -Filter "AG2.exe" | Select-Object -First 1
if (-not $exe) { throw "AG2.exe introuvable sous $src" }
Copy-Item (Join-Path $root "Changelog.md") (Join-Path $src "Changelog.md") -Force
$buildLogo = Join-Path (Join-Path $builds $buildName) "LogoAG.ico"
$repoLogo = Join-Path $root "LogoAG.ico"
$toolsLogo = Join-Path $PSScriptRoot "LogoAG.ico"
if (Test-Path $buildLogo) { $logo = $buildLogo }
elseif (Test-Path $repoLogo) { $logo = $repoLogo }
elseif (Test-Path $toolsLogo) { $logo = $toolsLogo }
else { $logo = Join-Path $root "crem.ico" }
if (-not (Test-Path $logo)) { throw "LogoIco introuvable (ni $buildName\LogoAG.ico, ni LogoAG.ico racine/tools-packaging, ni crem.ico racine)" }
$iss = Join-Path $PSScriptRoot "AG2.template.iss"
$iscc = "C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
if (-not (Test-Path $iscc)) { throw "ISCC introuvable: $iscc" }
Write-Output "ISCC LogoIco: $logo"
& $iscc "/DMyAppVersion=$ver" "/DMyAppArch=$Arch" "/DSrcDir=$src" "/DOutDir=$dist" "/DLogoIco=$logo" $iss 2>&1 | Out-String | Write-Output
if ($LASTEXITCODE -ne 0) { throw "ISCC echoue code $LASTEXITCODE" }
$setup = Join-Path $dist "AG2-$ver-windows-$Arch.exe"
if (-not (Test-Path $setup)) { throw "ISCC n'a pas produit $setup" }
$zip = Join-Path $dist "AG2-$ver-windows-$Arch.zip"
if (Test-Path $zip) { Remove-Item $zip -Force }
Compress-Archive -Path ($src + "\*") -DestinationPath $zip -CompressionLevel Optimal
$sec = [math]::Round(((Get-Date) - $t0).TotalSeconds, 1)
$mb = [math]::Round((Get-Item $setup).Length / 1MB, 1)
Write-Output "package-windows $Arch : $setup (${mb}MB, ${sec}s)"
