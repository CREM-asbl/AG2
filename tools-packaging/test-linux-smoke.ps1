#Requires -Version 5.1
<#
.SYNOPSIS Smoke test Linux via WSL2 : extraction tgz, binaire executable, ldd, --help/--version.
.DESCRIPTION
  Extrait le tgz Linux dans TEMP, verifie le binaire executable, controle
  les dependances manquantes via ldd sous WSL2, lance --help/--version
  avec timeout. Retourne PASS/FAIL/SKIP (SKIP si WSL absent ou tgz absent).
.PARAMETER Tgz Chemin tgz. Defaut : dernier AG2-*-linux-*.tgz de Builds - AG/dist.
.PARAMETER TimeoutSec Timeout lancement binaire (defaut 15).
.EXAMPLE .\tools-packaging\test-linux-smoke.ps1
.EXAMPLE .\tools-packaging\test-linux-smoke.ps1 -Tgz dist/AG2-2.7.2-linux-x64.tgz -TimeoutSec 30
#>
[CmdletBinding()]
param(
  [string]$Tgz = "",
  [int]$TimeoutSec = 15
)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
$result = [ordered]@{ Package = "linux"; Result = "FAIL"; Detail = "" }
function EmitResult {
  $r = [pscustomobject]$result
  $r | Format-Table -AutoSize | Out-String | Write-Output
  if ($result.Result -eq "FAIL") { exit 1 }
  exit 0
}
if (-not $Tgz) {
  $dist = Join-Path (Join-Path $root "Builds - AG") "dist"
  $cand = Get-ChildItem -Path $dist -Filter "AG2-*-linux-*.tgz" -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending | Select-Object -First 1
  if ($cand) { $Tgz = $cand.FullName }
}
if (-not $Tgz -or -not (Test-Path $Tgz)) {
  $result.Result = "SKIP"; $result.Detail = "tgz Linux absent (build IDE requis)"
  Write-Output "test-linux-smoke: SKIP - $($result.Detail)"
  EmitResult
}
try { $null = Get-Command wsl -ErrorAction Stop } catch {
  $result.Result = "SKIP"; $result.Detail = "WSL2 absent"
  Write-Output "test-linux-smoke: SKIP - $($result.Detail)"
  EmitResult
}
if ((wsl --status 2>&1 | Out-String) -match "aucune|no .*distribution|no installed") {
  $result.Result = "SKIP"; $result.Detail = "aucune distribution WSL"
  Write-Output "test-linux-smoke: SKIP - $($result.Detail)"
  EmitResult
}
$m = [regex]::Match($Tgz, "^([A-Za-z]):")
if (-not $m.Success) {
  $result.Detail = "chemin Windows attendu, recu: $Tgz"
  Write-Output "test-linux-smoke: FAIL - $($result.Detail)"
  EmitResult
}
$wslTgz = "/mnt/" + $m.Groups[1].Value.ToLower() + ($Tgz.Substring(2) -replace "\\", "/")
$bash = @'
set -u
rm -rf /tmp/ag2smoke; mkdir -p /tmp/ag2smoke
tar -xzf '{0}' -C /tmp/ag2smoke
BIN=$(find /tmp/ag2smoke -maxdepth 4 -name AG2 -type f -print -quit)
if [ -z "$BIN" ]; then echo "SMOKE-KO-no-binary"; exit 1; fi
echo "BIN=$BIN"
if [ ! -x "$BIN" ]; then chmod +x "$BIN"; fi
if [ ! -x "$BIN" ]; then echo "SMOKE-KO-not-executable"; exit 1; fi
MISS=$(ldd "$BIN" 2>/dev/null | grep -i 'not found' || true)
echo "MISS=$MISS"
if [ -n "$MISS" ]; then echo "SMOKE-KO-missing"; exit 1; fi
if command -v timeout >/dev/null 2>&1; then TO="timeout {1}"; else TO=""; fi
$TO "$BIN" --help >/tmp/ag2smoke/help.log 2>&1; H=$?
if [ $H -ne 0 ]; then $TO "$BIN" --version >/tmp/ag2smoke/help.log 2>&1; H=$?; fi
echo "EXIT=$H"
if [ $H -ne 0 ]; then echo "SMOKE-KO-launch"; exit 1; fi
echo "SMOKE-OK"
'@
$bash = ($bash -replace "`r", "") -replace '\{0\}', $wslTgz -replace '\{1\}', $TimeoutSec
$out = $bash | wsl bash 2>&1 | Out-String
Write-Output $out
if ($LASTEXITCODE -ne 0 -or $out -match "SMOKE-KO") {
  $result.Detail = "echec smoke (wsl exit $LASTEXITCODE)"
  if ($out -match "SMOKE-KO-(\S+)") { $result.Detail = $Matches[1] }
  Write-Output "test-linux-smoke: FAIL - $($result.Detail)"
  EmitResult
}
$result.Result = "PASS"; $result.Detail = "ldd OK, --help/--version exit 0"
Write-Output "test-linux-smoke: PASS"
EmitResult
