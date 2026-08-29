@echo off
title Productive Animal Backyards - Restore Vanilla
cd /d "%~dp0"

echo.
echo Restoring vanilla Manor Lords 0.8.104 executable...
echo.

powershell.exe -NoProfile -File "%~dp0Uninstall_ProductiveAnimalBackyards.ps1"

if errorlevel 1 (
    echo.
    echo Restore did not complete successfully.
    echo Please read the error above.
    pause
)
