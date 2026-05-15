@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
set "POWERSHELL=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"

if not exist "%POWERSHELL%" (
  echo [package_web_functional_review] ERROR: No se encontro PowerShell en %POWERSHELL%.
  exit /b 1
)

call "%POWERSHELL%" -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%package_web_functional_review.ps1"
exit /b %ERRORLEVEL%
