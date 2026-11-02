#Requires -Version 5.1
<#
.SYNOPSIS Compare VERSION a https://api.crem.be/AG/version.xml, upload si different.
DryRun par defaut. -Publish ecrit (scp/curl). Client CheckUpdate.xojo_code lit url+version.xml.
#>
[CmdletBinding(SupportsShouldProcess)]
param([switch]$Publish)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
$ver = (Get-Content (Join-Path $root "VERSION") -Raw).Trim()
$remote = ""
try { $remote = (Invoke-WebRequest "https://api.crem.be/AG/version.xml" -TimeoutSec 15).Content.Trim() } catch { Write-Warning "version.xml distant illisible: $_" }
Write-Output "local=$ver distant=$remote"
if ($remote -eq $ver) { Write-Output "update-version-xml: deja a jour"; exit 0 }
if (-not $Publish) { Write-Output "update-version-xml: DryRun, -Publish pour ecrire"; exit 0 }
if ($PSCmdlet.ShouldProcess("https://api.crem.be/AG/version.xml", "publish $ver")) {
  $tmp = Join-Path ([IO.Path]::GetTempPath()) "version.xml"
  Set-Content $tmp $ver -NoNewline -Encoding UTF8
  try { & scp $tmp "api.crem.be:/AG/version.xml" } catch { throw "scp echoue: $_ (fallback: upload manuel de $tmp)" }
  Write-Output "update-version-xml: publie $ver"
}
