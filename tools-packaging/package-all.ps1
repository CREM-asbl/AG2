#Requires -Version 5.1
<#
.SYNOPSIS Chaine complete: version->changelog->win->linux->mac->manifest->tests.
.PARAMETER Only Cibles a inclure (windows,linux,macos). Vide = tout.
.PARAMETER Skip Cibles a exclure.
.PARAMETER WinArch Arch Windows (x64,x86,both).
#>
[CmdletBinding()]
param(
  [string[]]$Only = @(),
  [string[]]$Skip = @(),
  [ValidateSet("x64", "x86", "both")][string]$WinArch = "x64"
)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$tp = $PSScriptRoot
$root = Split-Path $tp -Parent
$Only = @($Only | ForEach-Object { $_ -split "," } | ForEach-Object { $_.Trim().ToLower() } | Where-Object { $_ })
$Skip = @($Skip | ForEach-Object { $_ -split "," } | ForEach-Object { $_.Trim().ToLower() } | Where-Object { $_ })
$ver = (Get-Content (Join-Path $root "VERSION") -Raw).Trim()
function Active([string]$t) {
  if ($Only.Count -gt 0 -and $t -notin $Only) { return $false }
  if ($t -in $Skip) { return $false }
  return $true
}
$rows = @()
function Step([string]$name, [scriptblock]$sb) {
  $t0 = Get-Date
  & $sb
  $sec = [math]::Round(((Get-Date) - $t0).TotalSeconds, 1)
  $script:rows += [pscustomobject]@{ Etape = $name; Sec = $sec }
}
Step "version" { & (Join-Path $tp "sync-version.ps1") -Version $ver }
Step "changelog" { & (Join-Path $tp "update-changelog.ps1") -Version $ver }
if (Active "windows") {
  $archs = if ($WinArch -eq "both") { @("x64", "x86") } else { @($WinArch) }
  foreach ($a in $archs) { Step "win-$a" { & (Join-Path $tp "package-windows.ps1") -Arch $a } }
}
if (Active "linux") { Step "linux" { & (Join-Path $tp "package-linux.ps1") } }
if (Active "macos") { Step "macos" { & (Join-Path $tp "package-macos.ps1") } }
Step "manifest" { & (Join-Path $tp "make-manifest.ps1") }
Step "tests" { & (Join-Path $tp "test-packages.ps1") -Only $Only -Skip $Skip }
$dist = Join-Path (Join-Path $root "Builds - AG") "dist"
$rows | Format-Table -AutoSize | Out-String | Write-Output
Get-ChildItem -Path $dist -File -ErrorAction SilentlyContinue |
  Where-Object { $_.Extension -notin @(".iss") } |
  Select-Object Name, @{N = "SizeMB"; E = { [math]::Round($_.Length / 1MB, 2) } } |
  Format-Table -AutoSize | Out-String | Write-Output
Write-Output "package-all $ver : OK"
