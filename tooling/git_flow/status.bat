@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
set "FLUTTER=C:\src\flutter\bin\flutter.bat"

pushd "%SCRIPT_DIR%..\.." >nul
if errorlevel 1 (
  echo [status] ERROR: No se pudo entrar a la raiz del repo.
  exit /b 1
)

echo [status] Rama actual:
git branch --show-current
if errorlevel 1 (
  echo [status] ERROR: No se pudo leer la rama actual.
  popd >nul
  exit /b 1
)

echo.
echo [status] Estado Git:
git status --short --branch
if errorlevel 1 (
  echo [status] ERROR: No se pudo leer git status.
  popd >nul
  exit /b 1
)

echo.
echo [status] Ultimos 5 commits:
git log -5 --oneline
if errorlevel 1 (
  echo [status] ERROR: No se pudo leer git log.
  popd >nul
  exit /b 1
)

echo.
if exist "%FLUTTER%" (
  echo [status] Version de Flutter:
  call "%FLUTTER%" --version
) else (
  echo [status] No existe %FLUTTER%.
)

popd >nul
exit /b 0
