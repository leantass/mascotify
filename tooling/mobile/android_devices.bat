@echo off
setlocal

set "ROOT_DIR=%~dp0..\.."
set "FLUTTER=C:\src\flutter\bin\flutter.bat"

cd /d "%ROOT_DIR%"

echo [android_devices] Dispositivos disponibles para Flutter:

if not exist "%FLUTTER%" (
  echo [android_devices] ERROR: No se encontro Flutter en %FLUTTER%.
  exit /b 1
)

call "%FLUTTER%" devices
if errorlevel 1 (
  echo [android_devices] ERROR: no se pudo listar dispositivos.
  echo [android_devices] Revisar instalacion local de Flutter/Android SDK.
  exit /b 1
)

endlocal
