@echo off
setlocal
cd /d "%~dp0"
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Start-EventSphere.ps1" %*
set "launcherExit=%errorlevel%"
if not "%launcherExit%"=="0" pause
endlocal & exit /b %launcherExit%
