@echo off
title Productive Animal Backyards - Installer
cd /d "%~dp0"

echo.
echo Starting Productive Animal Backyards installer...
echo.

powershell.exe -NoProfile -File "%~dp0Install_ProductiveAnimalBackyards.ps1"

if errorlevel 1 (
    echo.
    echo Installation did not complete successfully.
    echo Please read the error above.
    pause
)
