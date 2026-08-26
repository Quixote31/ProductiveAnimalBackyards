Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ExeName = "ManorLords-Win64-Shipping.exe"
$ExePath = Join-Path $PSScriptRoot $ExeName
$BackupPath = "$ExePath.ProductiveAnimalBackyards.bak"

$ExpectedSize = 161264640
$OriginalHash = "37bef06c94e4fcd93fda77227bb2a88265ce1fbcb8862f98e75a720c923f2f29"
$PatchedHash  = "249116f44709b6e1b795a939bd9ac75dafccb72e14ff0139518fb77ed916fc8f"

$Patches = @(
    @{ Name="Chicken Coop base cycle 30 -> 15"; Offset=[Int64]0x04CCD023; Old=[byte[]](0xF1,0x77,0x46,0x02); New=[byte[]](0x59,0x8B,0x3E,0x02) },
    @{ Name="Goat Pen base cycle 49 -> 24.5"; Offset=[Int64]0x04CCD031; Old=[byte[]](0xE7,0x67,0x26,0x03); New=[byte[]](0xAB,0x4E,0xCA,0x03) },
    @{ Name="Pig Pen base cycle 73 -> 36.5"; Offset=[Int64]0x04CCD042; Old=[byte[]](0x5E,0x39,0x40,0x02); New=[byte[]](0x5A,0x58,0xCA,0x03) }
)

function Get-Sha256([string]$Path) {
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}

function Read-BytesAt([string]$Path, [Int64]$Offset, [int]$Count) {
    $buffer = New-Object byte[] $Count
    $stream = [System.IO.File]::Open($Path,[System.IO.FileMode]::Open,[System.IO.FileAccess]::Read,[System.IO.FileShare]::Read)
    try {
        [void]$stream.Seek($Offset,[System.IO.SeekOrigin]::Begin)
        $read = $stream.Read($buffer,0,$Count)
        if ($read -ne $Count) { throw "Could not read expected bytes." }
    } finally {
        $stream.Dispose()
    }
    return $buffer
}

function Bytes-Match([byte[]]$A,[byte[]]$B) {
    if ($A.Length -ne $B.Length) { return $false }
    for ($i=0; $i -lt $A.Length; $i++) {
        if ($A[$i] -ne $B[$i]) { return $false }
    }
    return $true
}

Write-Host ""
Write-Host "Productive Animal Backyards - Automatic Installer"
Write-Host "Manor Lords 0.8.100"
Write-Host ""

if (-not (Test-Path -LiteralPath $ExePath)) {
    throw "Could not find $ExeName. Extract this installer into ManorLords\\Binaries\\Win64."
}

if ((Get-Item -LiteralPath $ExePath).Length -ne $ExpectedSize) {
    throw "Unsupported executable size."
}

$currentHash = Get-Sha256 $ExePath
Write-Host "Current SHA256: $currentHash"

if ($currentHash -eq $PatchedHash) {
    Write-Host "[OK] Productive Animal Backyards is already installed."
    Read-Host "Press Enter to exit"
    exit 0
}

if ($currentHash -ne $OriginalHash) {
    throw "Unsupported executable hash. Installation aborted."
}

foreach ($patch in $Patches) {
    $actual = Read-BytesAt $ExePath $patch.Offset $patch.Old.Length
    if (-not (Bytes-Match $actual $patch.Old)) {
        throw ("Original bytes do not match at offset 0x{0:X}." -f $patch.Offset)
    }
}

if (-not (Test-Path -LiteralPath $BackupPath)) {
    Copy-Item -LiteralPath $ExePath -Destination $BackupPath
    if ((Get-Sha256 $BackupPath) -ne $OriginalHash) { throw "Backup verification failed." }
}

$stream = [System.IO.File]::Open($ExePath,[System.IO.FileMode]::Open,[System.IO.FileAccess]::ReadWrite,[System.IO.FileShare]::None)
try {
    foreach ($patch in $Patches) {
        [void]$stream.Seek($patch.Offset,[System.IO.SeekOrigin]::Begin)
        $stream.Write($patch.New,0,$patch.New.Length)
        Write-Host ("[PATCH] {0}" -f $patch.Name)
    }
    $stream.Flush($true)
} finally {
    $stream.Dispose()
}

if ((Get-Sha256 $ExePath) -ne $PatchedHash) {
    Copy-Item -LiteralPath $BackupPath -Destination $ExePath -Force
    throw "Final verification failed. Vanilla executable restored."
}

Write-Host "[OK] Installation completed successfully."
Read-Host "Press Enter to exit"
