Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ExeName = "ManorLords-Win64-Shipping.exe"
$ExePath = Join-Path $PSScriptRoot $ExeName
$BackupPath = "$ExePath.ProductiveAnimalBackyards.0.8.104.bak"

$OriginalHash = "813c4909dbe8bef3481469137c66f35cc23dec11c145b6963c4739b41539e621"
$PatchedHash  = "e1321b736be4bf4f9d3f4dbfbee9968dffb09c157be1a0d14c316683d6d77513"

function Get-Sha256([string]$Path) {
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}

Write-Host ""
Write-Host "=============================================================="
Write-Host " Productive Animal Backyards"
Write-Host " Restore Vanilla - Manor Lords 0.8.104"
Write-Host "=============================================================="
Write-Host ""

if (-not (Test-Path -LiteralPath $ExePath)) {
    throw "Could not find $ExeName."
}

$currentHash = Get-Sha256 $ExePath

if ($currentHash -eq $OriginalHash) {
    Write-Host "[OK] Executable is already vanilla Manor Lords 0.8.104."
    Read-Host "Press Enter to exit"
    exit 0
}

if ($currentHash -ne $PatchedHash) {
    throw "The current executable is unknown, modified, or newer. Restore aborted so an old backup cannot overwrite a different game build."
}

if (-not (Test-Path -LiteralPath $BackupPath)) {
    throw "The verified Manor Lords 0.8.104 backup was not found."
}

if ((Get-Sha256 $BackupPath) -ne $OriginalHash) {
    throw "The backup does not match the verified vanilla Manor Lords 0.8.104 executable."
}

Copy-Item -LiteralPath $BackupPath -Destination $ExePath -Force

if ((Get-Sha256 $ExePath) -ne $OriginalHash) {
    throw "Restore verification failed."
}

Write-Host "[OK] Vanilla Manor Lords 0.8.104 executable restored."
Write-Host ""
Write-Host "Older game-version backups were not touched."
Write-Host ""
Read-Host "Press Enter to exit"
