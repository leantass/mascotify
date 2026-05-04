@echo off
setlocal

set "ROOT_DIR=%~dp0..\.."
set "ANDROID_DIR=%ROOT_DIR%\android"
set "KEY_PROPERTIES=%ANDROID_DIR%\key.properties"
set "FLUTTER=C:\src\flutter\bin\flutter.bat"
set "AAB_PATH=%ROOT_DIR%\build\app\outputs\bundle\release\app-release.aab"

cd /d "%ROOT_DIR%"

echo [build_android_appbundle_release] Preparando Android App Bundle release.
echo [build_android_appbundle_release] No toca Git, no crea keystore y no sube nada a Play Store.

if not exist "%FLUTTER%" (
  echo [build_android_appbundle_release] ERROR: No se encontro Flutter en %FLUTTER%.
  exit /b 1
)

if not exist "%KEY_PROPERTIES%" (
  echo [build_android_appbundle_release] ERROR: no existe android\key.properties.
  echo [build_android_appbundle_release] Crear una keystore real fuera del repo o en una ruta segura local.
  echo [build_android_appbundle_release] Copiar android\key.properties.example a android\key.properties y completar:
  echo [build_android_appbundle_release] - storePassword
  echo [build_android_appbundle_release] - keyPassword
  echo [build_android_appbundle_release] - keyAlias
  echo [build_android_appbundle_release] - storeFile
  echo [build_android_appbundle_release] No commitear key.properties ni archivos .jks/.keystore.
  exit /b 1
)

findstr /R /C:"^storePassword=." "%KEY_PROPERTIES%" >nul
if errorlevel 1 (
  echo [build_android_appbundle_release] ERROR: android\key.properties no tiene storePassword completo.
  echo [build_android_appbundle_release] Completar el valor localmente sin commitear secretos.
  exit /b 1
)

findstr /R /C:"^keyPassword=." "%KEY_PROPERTIES%" >nul
if errorlevel 1 (
  echo [build_android_appbundle_release] ERROR: android\key.properties no tiene keyPassword completo.
  echo [build_android_appbundle_release] Completar el valor localmente sin commitear secretos.
  exit /b 1
)

findstr /R /C:"^keyAlias=." "%KEY_PROPERTIES%" >nul
if errorlevel 1 (
  echo [build_android_appbundle_release] ERROR: android\key.properties no tiene keyAlias completo.
  echo [build_android_appbundle_release] Completar el valor localmente sin commitear secretos.
  exit /b 1
)

findstr /R /C:"^storeFile=." "%KEY_PROPERTIES%" >nul
if errorlevel 1 (
  echo [build_android_appbundle_release] ERROR: android\key.properties no tiene storeFile completo.
  echo [build_android_appbundle_release] storeFile debe apuntar a la keystore real local, fuera de git.
  exit /b 1
)

call "%FLUTTER%" build appbundle --release
if errorlevel 1 (
  echo [build_android_appbundle_release] ERROR: fallo el build appbundle release.
  echo [build_android_appbundle_release] Revisar Android SDK, Gradle, Java y signing local.
  exit /b 1
)

if not exist "%AAB_PATH%" (
  echo [build_android_appbundle_release] ERROR: el build termino, pero no se encontro el AAB esperado:
  echo [build_android_appbundle_release] %AAB_PATH%
  exit /b 1
)

echo [build_android_appbundle_release] AAB release generado:
echo [build_android_appbundle_release] build\app\outputs\bundle\release\app-release.aab

endlocal
