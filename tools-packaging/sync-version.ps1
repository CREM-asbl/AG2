#Requires -Version 5.1
<#
.SYNOPSIS Aligne AG.xojo_project sur VERSION (source verite).
#>
[CmdletBinding(SupportsShouldProcess)]
param([string]$Version = "")
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
if (-not $Version) { $Version = (Get-Content (Join-Path $root "VERSION") -Raw).Trim() }
if ($Version -notmatch "^(\d+)\.(\d+)\.(\d+)$") { throw "VERSION invalide: $Version (attendu X.Y.Z)" }
$major, $minor, $sub = $Matches[1], $Matches[2], $Matches[3]
$proj = Join-Path $root "AG.xojo_project"
$utf8 = New-Object Text.UTF8Encoding $false
$raw = [IO.File]::ReadAllText($proj, $utf8)
$eol = "`n"
$lines = $raw -split "`r?`n"
$lines = $lines | ForEach-Object {
  if ($_ -match "^MajorVersion=") { "MajorVersion=$major" }
  elseif ($_ -match "^MinorVersion=") { "MinorVersion=$minor" }
  elseif ($_ -match "^SubVersion=") { "SubVersion=$sub" }
  elseif ($_ -match "^LongVersion=") { "LongVersion=$Version" }
  else { $_ }
}
if ($PSCmdlet.ShouldProcess($proj, "sync version $Version")) {
  [IO.File]::WriteAllText($proj, ($lines -join $eol), $utf8)
}
Write-Output "sync-version: $Version OK"
