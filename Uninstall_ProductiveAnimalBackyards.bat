@echo off
title Productive Animal Backyards - Restore Vanilla
cd /d "%~dp0"

echo.
echo Restoring vanilla Manor Lords 0.8.104 executable...
echo.

REM ExecutionPolicy Bypass applies only to this PowerShell process.
REM It does NOT permanently change the user's Windows PowerShell policy.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Uninstall_ProductiveAnimalBackyards.ps1"

if errorlevel 1 (
    echo.
    echo Restore did not complete successfully.
    echo Please read the error above.
    pause
)
