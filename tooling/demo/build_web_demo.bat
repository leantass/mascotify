@echo off
setlocal

pushd "%~dp0..\.." >nul

echo [build_web_demo] Generando build web de Mascotify...
call C:\src\flutter\bin\flutter.bat build web
if errorlevel 1 (
  echo [build_web_demo] ERROR: flutter build web fallo.
  popd >nul
  exit /b 1
)

echo [build_web_demo] Build web generado correctamente en:
echo [build_web_demo] %CD%\build\web

popd >nul
exit /b 0
