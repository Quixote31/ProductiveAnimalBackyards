@echo off
title Productive Animal Backyards - Installer
cd /d "%~dp0"
powershell.exe -NoProfile -File "%~dp0Install_ProductiveAnimalBackyards.ps1"
if errorlevel 1 (
  echo.
  echo Installation did not complete successfully.
  pause
)
