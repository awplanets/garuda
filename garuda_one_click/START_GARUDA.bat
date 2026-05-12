@echo off
setlocal
cd /d "%~dp0"
title GARUDA

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0start_server.ps1"

echo.
echo GARUDA has stopped. You can close this window.
pause >nul
