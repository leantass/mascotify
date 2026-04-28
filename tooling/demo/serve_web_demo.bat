@echo off
setlocal

pushd "%~dp0..\.." >nul

if not exist "build\web\index.html" (
  echo [serve_web_demo] No existe build web. Ejecuta primero tooling\demo\build_web_demo.bat
  popd >nul
  exit /b 1
)

echo [serve_web_demo] Sirviendo demo web local desde build\web
echo [serve_web_demo] URL local: http://localhost:8080
echo [serve_web_demo] Presiona Ctrl+C para detener el servidor.

where python >nul 2>nul
if not errorlevel 1 (
  python -m http.server 8080 --directory build\web
  popd >nul
  exit /b %ERRORLEVEL%
)

where py >nul 2>nul
if not errorlevel 1 (
  py -m http.server 8080 --directory build\web
  popd >nul
  exit /b %ERRORLEVEL%
)

echo [serve_web_demo] ERROR: No se encontro python ni py.
echo [serve_web_demo] Instala o habilita Python, o servi build\web con otro servidor estatico simple.
echo [serve_web_demo] No se instalo nada y no se modifico el proyecto.

popd >nul
exit /b 1
