@echo off
title Productive Animal Backyards - Installer
cd /d "%~dp0"

echo.
echo Starting Productive Animal Backyards installer...
echo.

REM ExecutionPolicy Bypass applies only to this PowerShell process.
REM It does NOT permanently change the user's Windows PowerShell policy.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Install_ProductiveAnimalBackyards.ps1"

if errorlevel 1 (
    echo.
    echo Installation did not complete successfully.
    echo Please read the error above.
    pause
)
