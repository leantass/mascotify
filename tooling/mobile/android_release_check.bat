@echo off
setlocal

set "ROOT_DIR=%~dp0..\.."
set "FLUTTER=C:\src\flutter\bin\flutter.bat"
set "APK_PATH=%ROOT_DIR%\build\app\outputs\flutter-apk\app-debug.apk"

cd /d "%ROOT_DIR%"

echo [android_release_check] Diagnostico Android seguro para Mascotify.
echo [android_release_check] No toca Git, no crea keystore y no genera release firmado.

if not exist "%FLUTTER%" (
  echo [android_release_check] ERROR: No se encontro Flutter en %FLUTTER%.
  exit /b 1
)

echo [android_release_check] Version Flutter:
call "%FLUTTER%" --version
if errorlevel 1 (
  echo [android_release_check] ERROR: no se pudo obtener la version de Flutter.
  exit /b 1
)

echo [android_release_check] Ejecutando flutter doctor:
call "%FLUTTER%" doctor
if errorlevel 1 (
  echo [android_release_check] ERROR: flutter doctor reporto problemas.
  echo [android_release_check] Revisar Android SDK, Java, licencias o toolchain local.
  exit /b 1
)

echo [android_release_check] Generando APK debug:
call "%FLUTTER%" build apk --debug
if errorlevel 1 (
  echo [android_release_check] ERROR: fallo el build APK debug.
  echo [android_release_check] Si el error menciona Android SDK/Gradle/Java, resolver el entorno local antes de tocar el proyecto.
  exit /b 1
)

if not exist "%APK_PATH%" (
  echo [android_release_check] ERROR: no se encontro el APK esperado:
  echo [android_release_check] %APK_PATH%
  exit /b 1
)

echo [android_release_check] APK debug disponible en:
echo [android_release_check] build\app\outputs\flutter-apk\app-debug.apk
echo [android_release_check] Diagnostico Android completado.

endlocal
