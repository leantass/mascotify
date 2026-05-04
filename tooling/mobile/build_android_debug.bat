@echo off
setlocal

set "ROOT_DIR=%~dp0..\.."
set "FLUTTER=C:\src\flutter\bin\flutter.bat"
set "APK_PATH=%ROOT_DIR%\build\app\outputs\flutter-apk\app-debug.apk"

cd /d "%ROOT_DIR%"

echo [build_android_debug] Generando APK debug de Mascotify...
echo [build_android_debug] Este script no instala el APK, no toca Git y no genera release firmado.

if not exist "%FLUTTER%" (
  echo [build_android_debug] ERROR: No se encontro Flutter en %FLUTTER%.
  exit /b 1
)

call "%FLUTTER%" build apk --debug
if errorlevel 1 (
  echo [build_android_debug] ERROR: fallo el build APK debug.
  echo [build_android_debug] Revisar configuracion local de Android SDK, Java o Gradle.
  exit /b 1
)

if not exist "%APK_PATH%" (
  echo [build_android_debug] ERROR: el build termino, pero no se encontro el APK esperado:
  echo [build_android_debug] %APK_PATH%
  exit /b 1
)

echo [build_android_debug] APK debug generado correctamente:
echo [build_android_debug] build\app\outputs\flutter-apk\app-debug.apk

endlocal
