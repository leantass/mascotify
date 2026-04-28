@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
set "FLUTTER=C:\src\flutter\bin\flutter.bat"

pushd "%SCRIPT_DIR%..\.." >nul
if errorlevel 1 (
  echo [check_local] ERROR: No se pudo entrar a la raiz del repo.
  exit /b 1
)

if not exist "%FLUTTER%" (
  echo [check_local] ERROR: No existe %FLUTTER%.
  popd >nul
  exit /b 1
)

echo [check_local] Ejecutando flutter analyze...
call "%FLUTTER%" analyze
if errorlevel 1 (
  echo [check_local] ERROR: flutter analyze fallo.
  popd >nul
  exit /b 1
)
echo [check_local] ANALYZE OK

echo [check_local] Ejecutando flutter test...
call "%FLUTTER%" test
if errorlevel 1 (
  echo [check_local] ERROR: flutter test fallo.
  popd >nul
  exit /b 1
)
echo [check_local] TESTS OK

echo [check_local] Ejecutando flutter build web...
call "%FLUTTER%" build web
if errorlevel 1 (
  echo [check_local] ERROR: flutter build web fallo.
  popd >nul
  exit /b 1
)
echo [check_local] BUILD WEB OK

popd >nul
exit /b 0
