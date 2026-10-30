#Requires -Version 5.1
<#
.SYNOPSIS Smoke test Linux via WSL2: extraction tgz, ldd sans missing critique, --help exit 0.
#>
[CmdletBinding()]
param([string]$Tgz = "")
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
if (-not $Tgz) {
  $Tgz = Get-ChildItem -Path (Join-Path (Join-Path $root "Builds - AG") "dist") -Filter "AG2-*-linux-*.tgz" |
    Sort-Object LastWriteTime -Descending | Select-Object -First 1 -ExpandProperty FullName
}
if (-not $Tgz -or -not (Test-Path $Tgz)) { throw "tgz Linux introuvable" }
$m = [regex]::Match($Tgz, "^([A-Za-z]):")
if (-not $m.Success) { throw "chemin Windows attendu, recu: $Tgz" }
$wslTgz = "/mnt/" + $m.Groups[1].Value.ToLower() + ($Tgz.Substring(2) -replace "\\", "/")
$bash = 'set -e; rm -rf /tmp/ag2smoke; mkdir -p /tmp/ag2smoke; tar -xzf ''{0}'' -C /tmp/ag2smoke; BIN=$(find /tmp/ag2smoke -maxdepth 3 -name AG2 -type f -print -quit); echo "BIN=$BIN"; chmod +x "$BIN"; MISS=$(ldd "$BIN" 2>/dev/null | grep -i ''not found'' || true); echo "MISS=$MISS"; if [ -n "$MISS" ]; then echo SMOKE-KO-missing; exit 1; fi; "$BIN" --help >/dev/null 2>&1; echo "EXIT=$?"'
$out = wsl bash -c ($bash -f $wslTgz)
if ($LASTEXITCODE -ne 0) { $out | ForEach-Object { Write-Output $_ }; throw "test-linux-smoke: KO (wsl exit $LASTEXITCODE)" }
$out | ForEach-Object { Write-Output $_ }
if ($out -match "SMOKE-KO|EXIT=[1-9]") { throw "test-linux-smoke: KO" }
Write-Output "test-linux-smoke: OK"
