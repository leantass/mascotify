@echo off
setlocal

set "FLUTTER=C:\src\flutter\bin\flutter.bat"

pushd "%~dp0..\.." >nul
if errorlevel 1 (
  echo [build_web_demo] ERROR: No se pudo entrar a la raiz del repo.
  exit /b 1
)

if not exist "%FLUTTER%" (
  echo [build_web_demo] ERROR: No existe %FLUTTER%.
  echo [build_web_demo] Revisa la instalacion local de Flutter.
  popd >nul
  exit /b 1
)

echo [build_web_demo] Generando build web de Mascotify...
call "%FLUTTER%" build web
if errorlevel 1 (
  echo [build_web_demo] ERROR: flutter build web fallo.
  popd >nul
  exit /b 1
)

echo [build_web_demo] Build web generado correctamente en:
echo [build_web_demo] %CD%\build\web

popd >nul
exit /b 0
