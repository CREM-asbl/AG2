#Requires -Version 5.1
<#
.SYNOPSIS FileSystemWatcher sur Builds - AG, debounce 15s, stabilite x2 + absence lock, package-all -Only cible.
Map: dossier *Windows*->windows, *Linux*->linux, *macOS|*Mac*->macos.
#>
[CmdletBinding()]
param([int]$DebounceSec = 15)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$tp = $PSScriptRoot
$root = Split-Path $tp -Parent
$builds = Join-Path $root "Builds - AG"
if (-not (Test-Path $builds)) { New-Item -ItemType Directory -Path $builds -Force | Out-Null }
function Stable([string]$dir) {
  $a = Get-ChildItem -Path $dir -Recurse -File -ErrorAction SilentlyContinue |
    Select-Object -First 50 | ForEach-Object { "$($_.FullName):$($_.Length):$($_.LastWriteTime.Ticks)" }
  Start-Sleep -Seconds 3
  $b = Get-ChildItem -Path $dir -Recurse -File -ErrorAction SilentlyContinue |
    Select-Object -First 50 | ForEach-Object { "$($_.FullName):$($_.Length):$($_.LastWriteTime.Ticks)" }
  if (Compare-Object $a $b) { return $false }
  try {
    $f = Get-ChildItem -Path $dir -Recurse -File -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($f) { $s = [IO.File]::Open($f.FullName, "Open", "Read", "None"); $s.Close() }
  } catch { return $false }
  return $true
}
function Target([string]$path) {
  if ($path -match "Windows") { return "windows" }
  if ($path -match "Linux") { return "linux" }
  if ($path -match "macOS|Mac") { return "macos" }
  return ""
}
$watcher = New-Object IO.FileSystemWatcher $builds, "*", ([IO.NotifyFilters]::LastWrite -bor [IO.NotifyFilters]::FileName -bor [IO.NotifyFilters]::DirectoryName)
$watcher.IncludeSubdirectories = $true
$pending = @{}
Register-ObjectEvent $watcher "Changed" -Action { } | Out-Null
Register-ObjectEvent $watcher "Created" -Action { } | Out-Null
Register-ObjectEvent $watcher "Renamed" -Action { } | Out-Null
$watcher.EnableRaisingEvents = $true
Write-Output "watch-builds: surveillance $builds (debounce ${DebounceSec}s, Ctrl+C pour arreter)"
try {
  while ($true) {
    Start-Sleep -Seconds $DebounceSec
    $dirs = Get-ChildItem -Path $builds -Directory -ErrorAction SilentlyContinue | Select-Object -First 10
    foreach ($d in $dirs) {
      $t = Target $d.Name
      if (-not $t) { continue }
      $key = $d.FullName
      $stamp = (Get-ChildItem -Path $d.FullName -Recurse -File -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1).LastWriteTime
      if (-not $stamp) { continue }
      if ($pending.ContainsKey($key) -and $pending[$key] -eq $stamp) {
        if (Stable $d.FullName) {
          Write-Output "watch-builds: $t stable -> package-all -Only $t"
          & (Join-Path $tp "package-all.ps1") -Only @($t)
          $pending.Remove($key)
        }
      } else { $pending[$key] = $stamp }
    }
  }
} finally { $watcher.Dispose() }
