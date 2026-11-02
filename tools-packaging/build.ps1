#Requires -Version 5.1
<#
.SYNOPSIS Snapshot dates avant ouverture IDE Xojo, poll apres, package-all auto.
Ouvrir IDE manuellement, builder les 3 cibles, fermer IDE. Poll detecte fin.
#>
[CmdletBinding()]
param(
  [string[]]$Only = @(),
  [string[]]$Skip = @(),
  [int]$PollSec = 10,
  [int]$IdleMin = 2
)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$tp = $PSScriptRoot
$root = Split-Path $tp -Parent
$builds = Join-Path $root "Builds - AG"
Write-Output "build: snapshot $builds — ouvrez Xojo IDE et lancez Build All, puis fermez IDE."
$snap = @{}
if (Test-Path $builds) {
  Get-ChildItem -Path $builds -Recurse -File -ErrorAction SilentlyContinue |
    Select-Object -First 200 | ForEach-Object { $snap[$_.FullName] = $_.LastWriteTime }
}
Write-Output "build: surveillance (poll ${PollSec}s, idle ${IdleMin}min pour finir)..."
$idle = 0
while ($true) {
  Start-Sleep -Seconds $PollSec
  $changed = $false
  $cur = Get-ChildItem -Path $builds -Recurse -File -ErrorAction SilentlyContinue | Select-Object -First 200
  foreach ($f in $cur) {
    if (-not $snap.ContainsKey($f.FullName) -or $snap[$f.FullName] -ne $f.LastWriteTime) { $changed = $true; break }
  }
  if ($changed) { $idle = 0; $snap = @{}; $cur | ForEach-Object { $snap[$_.FullName] = $_.LastWriteTime } }
  else { $idle += $PollSec }
  Write-Output "build: idle $([math]::Round($idle/60,1))min..."
  if ($idle -ge ($IdleMin * 60)) { break }
}
Write-Output "build: IDE termine (idle atteint), packaging..."
& (Join-Path $tp "package-all.ps1") -Only $Only -Skip $Skip
