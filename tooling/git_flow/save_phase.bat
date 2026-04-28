@echo off
setlocal EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
set "MESSAGE=%~1"

if "%MESSAGE%"=="" (
  echo Uso: tooling\git_flow\save_phase.bat "Mensaje del commit"
  exit /b 1
)

pushd "%SCRIPT_DIR%..\.." >nul
if errorlevel 1 (
  echo [save_phase] ERROR: No se pudo entrar a la raiz del repo.
  exit /b 1
)

call "%SCRIPT_DIR%clean_generated.bat"
if errorlevel 1 (
  popd >nul
  exit /b 1
)

for /f "delims=" %%A in ('git branch --show-current') do set "CURRENT_BRANCH=%%A"
if "%CURRENT_BRANCH%"=="" (
  echo [save_phase] ERROR: No se pudo detectar la rama actual.
  popd >nul
  exit /b 1
)
if "%CURRENT_BRANCH%"=="main" (
  echo [save_phase] ERROR: No se puede guardar una fase desde main.
  popd >nul
  exit /b 1
)

call "%SCRIPT_DIR%check_local.bat"
if errorlevel 1 (
  popd >nul
  exit /b 1
)

echo [save_phase] Estado antes de commitear:
git status --short --branch

call :has_changes
if errorlevel 1 (
  echo [save_phase] No hay cambios para commitear.
  git status --short --branch
  popd >nul
  exit /b 0
)

echo [save_phase] Agregando cambios...
git add -A
if errorlevel 1 (
  echo [save_phase] ERROR: git add fallo.
  popd >nul
  exit /b 1
)

echo [save_phase] Creando commit...
git commit -m "%MESSAGE%"
if errorlevel 1 (
  echo [save_phase] ERROR: git commit fallo.
  popd >nul
  exit /b 1
)

echo [save_phase] Pusheando rama "%CURRENT_BRANCH%"...
git push origin "%CURRENT_BRANCH%"
if errorlevel 1 (
  echo [save_phase] ERROR: git push fallo.
  popd >nul
  exit /b 1
)

echo [save_phase] Estado final:
git status --short --branch
popd >nul
exit /b 0

:has_changes
set "DIRTY="
for /f "delims=" %%A in ('git status --porcelain') do set "DIRTY=1"
if defined DIRTY exit /b 0
exit /b 1
