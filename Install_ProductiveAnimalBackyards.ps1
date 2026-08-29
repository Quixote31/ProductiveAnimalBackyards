Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ExeName = "ManorLords-Win64-Shipping.exe"
$ExePath = Join-Path $PSScriptRoot $ExeName
$BackupPath = "$ExePath.ProductiveAnimalBackyards.0.8.104.bak"

$ExpectedSize = 160791040
$OriginalHash = "813c4909dbe8bef3481469137c66f35cc23dec11c145b6963c4739b41539e621"
$PatchedHash  = "e1321b736be4bf4f9d3f4dbfbee9968dffb09c157be1a0d14c316683d6d77513"

$Patches = @(
    @{ Name="Chicken Coop base cycle 30 -> 15"; Offset=[Int64]0x04CA0B63; Old=[byte[]](0x81,0xFA,0x43,0x02); New=[byte[]](0x01,0x0D,0x3C,0x02) },
    @{ Name="Goat Pen base cycle 49 -> 24.5";  Offset=[Int64]0x04CA0B71; Old=[byte[]](0xE7,0xB7,0x23,0x03); New=[byte[]](0x6B,0xFC,0xC6,0x03) },
    @{ Name="Pig Pen base cycle 73 -> 36.5";   Offset=[Int64]0x04CA0B82; Old=[byte[]](0xEE,0xBB,0x3D,0x02); New=[byte[]](0x1A,0x06,0xC7,0x03) }
)

function Get-Sha256([string]$Path) {
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}

function Read-BytesAt([string]$Path, [Int64]$Offset, [int]$Count) {
    $buffer = New-Object byte[] $Count
    $stream = [System.IO.File]::Open(
        $Path,
        [System.IO.FileMode]::Open,
        [System.IO.FileAccess]::Read,
        [System.IO.FileShare]::Read
    )
    try {
        [void]$stream.Seek($Offset, [System.IO.SeekOrigin]::Begin)
        $read = $stream.Read($buffer, 0, $Count)
        if ($read -ne $Count) {
            throw "Could not read expected bytes at offset 0x$($Offset.ToString('X'))."
        }
    }
    finally {
        $stream.Dispose()
    }
    return $buffer
}

function Bytes-Match([byte[]]$A, [byte[]]$B) {
    if ($A.Length -ne $B.Length) { return $false }
    for ($i = 0; $i -lt $A.Length; $i++) {
        if ($A[$i] -ne $B[$i]) { return $false }
    }
    return $true
}

Write-Host ""
Write-Host "=============================================================="
Write-Host " Productive Animal Backyards"
Write-Host " Automatic Installer - Manor Lords 0.8.104"
Write-Host "=============================================================="
Write-Host ""

if (-not (Test-Path -LiteralPath $ExePath)) {
    throw "Could not find $ExeName. Extract this installer into ManorLords\Binaries\Win64."
}

if ((Get-Item -LiteralPath $ExePath).Length -ne $ExpectedSize) {
    throw "Unsupported executable size. This installer supports only the verified Manor Lords 0.8.104 executable."
}

$currentHash = Get-Sha256 $ExePath
Write-Host "Current SHA256:"
Write-Host "  $currentHash"
Write-Host ""

if ($currentHash -eq $PatchedHash) {
    Write-Host "[OK] Productive Animal Backyards is already installed for Manor Lords 0.8.104."
    Read-Host "Press Enter to exit"
    exit 0
}

if ($currentHash -ne $OriginalHash) {
    throw "Unsupported executable hash. Installation aborted without modifying the game."
}

foreach ($patch in $Patches) {
    $actual = Read-BytesAt $ExePath $patch.Offset $patch.Old.Length
    if (-not (Bytes-Match $actual $patch.Old)) {
        throw ("Original bytes do not match at file offset 0x{0:X}. Installation aborted." -f $patch.Offset)
    }
}

if (-not (Test-Path -LiteralPath $BackupPath)) {
    Copy-Item -LiteralPath $ExePath -Destination $BackupPath

    if ((Get-Sha256 $BackupPath) -ne $OriginalHash) {
        Remove-Item -LiteralPath $BackupPath -Force -ErrorAction SilentlyContinue
        throw "Backup verification failed."
    }

    Write-Host "[OK] Verified Manor Lords 0.8.104 vanilla backup created:"
    Write-Host "  $BackupPath"
}
else {
    if ((Get-Sha256 $BackupPath) -ne $OriginalHash) {
        throw "The existing 0.8.104 backup is not the verified vanilla executable. Installation aborted."
    }
    Write-Host "[OK] Existing 0.8.104 vanilla backup verified."
}

try {
    $stream = [System.IO.File]::Open(
        $ExePath,
        [System.IO.FileMode]::Open,
        [System.IO.FileAccess]::ReadWrite,
        [System.IO.FileShare]::None
    )

    try {
        foreach ($patch in $Patches) {
            [void]$stream.Seek($patch.Offset, [System.IO.SeekOrigin]::Begin)
            $stream.Write($patch.New, 0, $patch.New.Length)
            Write-Host ("[PATCH] {0}" -f $patch.Name)
        }
        $stream.Flush($true)
    }
    finally {
        $stream.Dispose()
    }

    if ((Get-Sha256 $ExePath) -ne $PatchedHash) {
        throw "Final patched executable verification failed."
    }
}
catch {
    if (Test-Path -LiteralPath $BackupPath) {
        if ((Get-Sha256 $BackupPath) -eq $OriginalHash) {
            Copy-Item -LiteralPath $BackupPath -Destination $ExePath -Force
            Write-Host "[RECOVERY] Verified vanilla 0.8.104 executable restored."
        }
    }
    throw
}

Write-Host ""
Write-Host "[OK] Installation completed successfully."
Write-Host ""
Write-Host "Eggs:            30 -> 15 days"
Write-Host "Chicken:        ~120 -> ~60 days"
Write-Host "Milk:             49 -> ~25 days"
Write-Host "Chevon + Hides:  147 -> ~75 days"
Write-Host "Pig base:         73 -> 36.5 days"
Write-Host ""
Write-Host "Vanilla quantities, Pannage, perks, affinities and yield modifiers remain intact."
Write-Host "Apiaries are not modified."
Write-Host ""
Read-Host "Press Enter to exit"
