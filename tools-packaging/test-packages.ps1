#Requires -Version 5.1
<#
.SYNOPSIS 9 checks porte verte sur dist/.
Codes: 1 manifest, 2 version match, 3 win exe, 4 win zip, 5 linux tgz,
6 macos tgz, 7 sha256 manifest, 8 tailles >0, 9 changelog section.
#>
[CmdletBinding()]
param([string[]]$Only = @(), [string[]]$Skip = @())
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
$Only = @($Only | ForEach-Object { $_ -split "," } | ForEach-Object { $_.Trim().ToLower() } | Where-Object { $_ })
$Skip = @($Skip | ForEach-Object { $_ -split "," } | ForEach-Object { $_.Trim().ToLower() } | Where-Object { $_ })
$ver = (Get-Content (Join-Path $root "VERSION") -Raw).Trim()
$dist = Join-Path (Join-Path $root "Builds - AG") "dist"
function Active([string]$t) {
  if ($t -in $Skip) { return $false }
  if ($t -eq "common") { return $true }
  if ($Only.Count -gt 0 -and $t -notin $Only) { return $false }
  return $true
}
$total = 0
$pass = 0; $fail = 0
function Check([string]$name, [string]$target, [scriptblock]$cond) {
  if (-not (Active $target)) { return }
  $script:total++
  if (& $cond) { $script:pass++; Write-Output "  [OK] $name" }
  else { $script:fail++; Write-Output "  [KO] $name" }
}
Check "manifest.json present" "common" { Test-Path (Join-Path $dist "manifest.json") }
Check "manifest version=$ver" "common" {
  (Test-Path (Join-Path $dist "manifest.json")) -and
  ((Get-Content (Join-Path $dist "manifest.json") -Raw) -match [regex]::Escape($ver))
}
Check "windows exe" "windows" { @(Get-ChildItem -Path $dist -Filter "AG2-*-windows-*.exe" -ErrorAction SilentlyContinue).Count -gt 0 }
Check "windows zip" "windows" { @(Get-ChildItem -Path $dist -Filter "AG2-*-windows-*.zip" -ErrorAction SilentlyContinue).Count -gt 0 }
Check "linux tgz" "linux" { @(Get-ChildItem -Path $dist -Filter "AG2-*-linux-*.tgz" -ErrorAction SilentlyContinue).Count -gt 0 }
Check "macos tgz" "macos" { @(Get-ChildItem -Path $dist -Filter "AG2-*-macos-*.tgz" -ErrorAction SilentlyContinue).Count -gt 0 }
Check "sha256 manifest OK" "common" {
  $m = Join-Path $dist "manifest.json"
  if (-not (Test-Path $m)) { $false }
  else {
    $j = Get-Content $m -Raw | ConvertFrom-Json
    $ok = $true
    foreach ($f in $j.files) {
      $p = Join-Path $dist $f.name
      if (-not (Test-Path $p)) { $ok = $false; break }
      if ((Get-FileHash $p -Algorithm SHA256).Hash.ToLower() -ne $f.sha256) { $ok = $false; break }
    }
    $ok -and $j.files.Count -gt 0
  }
}
Check "tailles > 0" "common" {
  $fs = Get-ChildItem -Path $dist -File -ErrorAction SilentlyContinue | Where-Object { $_.Extension -notin @(".iss", ".json") }
  $fs.Count -gt 0 -and -not ($fs | Where-Object { $_.Length -eq 0 })
}
Check "changelog section $ver" "common" {
  (Test-Path (Join-Path $root "Changelog.md")) -and
  ((Get-Content (Join-Path $root "Changelog.md") -Raw) -match "## Version $([regex]::Escape($ver))")
}
Write-Output "test-packages: $pass/$total OK, $fail KO"
if ($fail -gt 0) { exit 1 }
