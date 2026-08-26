@echo off
title Productive Animal Backyards - Restore Vanilla
cd /d "%~dp0"
powershell.exe -NoProfile -File "%~dp0Uninstall_ProductiveAnimalBackyards.ps1"
if errorlevel 1 (
  echo.
  echo Restore did not complete successfully.
  pause
)
