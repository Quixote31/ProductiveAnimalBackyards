Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ExePath = Join-Path $PSScriptRoot "ManorLords-Win64-Shipping.exe"
$BackupPath = "$ExePath.ProductiveAnimalBackyards.bak"

$OriginalHash = "37bef06c94e4fcd93fda77227bb2a88265ce1fbcb8862f98e75a720c923f2f29"
$PatchedHash  = "249116f44709b6e1b795a939bd9ac75dafccb72e14ff0139518fb77ed916fc8f"

function Get-Sha256([string]$Path) {
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}

if (-not (Test-Path -LiteralPath $ExePath)) { throw "Could not find game executable." }

$currentHash = Get-Sha256 $ExePath

if ($currentHash -eq $OriginalHash) {
    Write-Host "[OK] Executable is already vanilla."
    Read-Host "Press Enter to exit"
    exit 0
}

if ($currentHash -ne $PatchedHash) {
    throw "Current executable is unsupported or updated. Restore aborted."
}

if (-not (Test-Path -LiteralPath $BackupPath)) { throw "Vanilla backup not found." }
if ((Get-Sha256 $BackupPath) -ne $OriginalHash) { throw "Backup hash is invalid." }

Copy-Item -LiteralPath $BackupPath -Destination $ExePath -Force

if ((Get-Sha256 $ExePath) -ne $OriginalHash) { throw "Restore verification failed." }

Write-Host "[OK] Vanilla Manor Lords 0.8.100 executable restored."
Read-Host "Press Enter to exit"
