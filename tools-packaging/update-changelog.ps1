#Requires -Version 5.1
<#
.SYNOPSIS Prepend section Changelog.md depuis git log depuis dernier tag.
#>
[CmdletBinding(SupportsShouldProcess)]
param([string]$Version = "")
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
if (-not $Version) { $Version = (Get-Content (Join-Path $root "VERSION") -Raw).Trim() }
$changelog = Join-Path $root "Changelog.md"
$utf8 = New-Object Text.UTF8Encoding $false
$head = [IO.File]::ReadAllText($changelog, $utf8)
$eol = "`n"
if ($head -match "## Version $Version") { Write-Output "update-changelog: $Version deja present"; exit 0 }
$lastTag = ""
try { $lastTag = (git --no-pager describe --tags --abbrev=0 2>$null) } catch { }
$range = if ($lastTag) { "$lastTag..HEAD" } else { "HEAD" }
$log = git --no-pager log $range --pretty=format:"- %s" --no-merges 2>$null | Select-Object -First 30
if (-not $log) { $log = @("- Maintenance interne") }
$date = Get-Date -Format "yyyy-MM-dd"
$section = "## Version $Version ($date)$eol$eol" + (($log -join $eol) -replace "`n", $eol) + "$eol$eol"
if ($PSCmdlet.ShouldProcess($changelog, "prepend $Version")) {
  [IO.File]::WriteAllText($changelog, ($section + $head), $utf8)
}
Write-Output "update-changelog: $Version OK"
