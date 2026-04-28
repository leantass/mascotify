@echo off
setlocal

pushd "%~dp0..\.." >nul

echo Generando paquete demo web de Mascotify...

call C:\src\flutter\bin\flutter.bat build web
if errorlevel 1 (
  echo [package_web_demo] ERROR: flutter build web fallo. No se genero el paquete.
  popd >nul
  exit /b 1
)

if not exist "build\web\index.html" (
  echo [package_web_demo] ERROR: No existe build\web\index.html.
  echo [package_web_demo] Ejecuta nuevamente el build web y revisa la salida de Flutter.
  popd >nul
  exit /b 1
)

if not exist "dist\demo" (
  mkdir "dist\demo"
  if errorlevel 1 (
    echo [package_web_demo] ERROR: No se pudo crear dist\demo.
    popd >nul
    exit /b 1
  )
)

if exist "dist\demo\mascotify-demo-web.zip" (
  del /f /q "dist\demo\mascotify-demo-web.zip"
  if errorlevel 1 (
    echo [package_web_demo] ERROR: No se pudo eliminar el zip anterior.
    popd >nul
    exit /b 1
  )
)

powershell -NoProfile -Command "Compress-Archive -Path 'build\web\*' -DestinationPath 'dist\demo\mascotify-demo-web.zip' -Force"
if errorlevel 1 (
  echo [package_web_demo] ERROR: No se pudo comprimir build\web.
  popd >nul
  exit /b 1
)

if not exist "dist\demo\mascotify-demo-web.zip" (
  echo [package_web_demo] ERROR: No se encontro el zip generado.
  popd >nul
  exit /b 1
)

echo Paquete generado en: dist\demo\mascotify-demo-web.zip

popd >nul
exit /b 0
