@echo off
setlocal

set "ROOT_DIR=%~dp0..\.."
set "FLUTTER=C:\src\flutter\bin\flutter.bat"

cd /d "%ROOT_DIR%"

echo [run_android_debug] Revisando dispositivos disponibles...

if not exist "%FLUTTER%" (
  echo [run_android_debug] ERROR: No se encontro Flutter en %FLUTTER%.
  exit /b 1
)

call "%FLUTTER%" devices
if errorlevel 1 (
  echo [run_android_debug] ERROR: no se pudieron listar dispositivos.
  echo [run_android_debug] Conectar un celular con depuracion USB o abrir un emulador Android.
  echo [run_android_debug] Luego ejecutar tooling\mobile\android_devices.bat.
  exit /b 1
)

echo [run_android_debug] Intentando correr Mascotify en Android...
call "%FLUTTER%" run -d android
if errorlevel 1 (
  echo [run_android_debug] ERROR: no se pudo correr la app en Android.
  echo [run_android_debug] Si no hay dispositivo Android:
  echo [run_android_debug] - Conectar celular con depuracion USB.
  echo [run_android_debug] - Abrir emulador Android desde Android Studio.
  echo [run_android_debug] - Ejecutar tooling\mobile\android_devices.bat.
  echo [run_android_debug] Este script no toca Git ni genera release firmado.
  exit /b 1
)

endlocal
