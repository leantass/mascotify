@echo off
setlocal EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
set "BRANCH=%~1"

if "%BRANCH%"=="" (
  echo Uso: tooling\git_flow\merge_phase_to_main.bat juagotecica7/nombre-rama
  exit /b 1
)

pushd "%SCRIPT_DIR%..\.." >nul
if errorlevel 1 (
  echo [merge_phase_to_main] ERROR: No se pudo entrar a la raiz del repo.
  exit /b 1
)

call "%SCRIPT_DIR%clean_generated.bat"
if errorlevel 1 (
  popd >nul
  exit /b 1
)

call :require_clean_tree
if errorlevel 1 (
  popd >nul
  exit /b 1
)

echo [merge_phase_to_main] Cambiando a main...
git checkout main
if errorlevel 1 (
  echo [merge_phase_to_main] ERROR: No se pudo cambiar a main.
  popd >nul
  exit /b 1
)

echo [merge_phase_to_main] Actualizando main...
git pull origin main
if errorlevel 1 (
  echo [merge_phase_to_main] ERROR: git pull origin main fallo.
  popd >nul
  exit /b 1
)

echo [merge_phase_to_main] Mergeando "%BRANCH%" en main...
git merge "%BRANCH%"
if errorlevel 1 (
  echo [merge_phase_to_main] ERROR: El merge fallo. Si hay conflictos, resolvelos manualmente y luego continuas vos.
  git status --short --branch
  popd >nul
  exit /b 1
)

call "%SCRIPT_DIR%check_local.bat"
if errorlevel 1 (
  echo [merge_phase_to_main] ERROR: Validacion local fallo. No se pushea main.
  popd >nul
  exit /b 1
)

echo [merge_phase_to_main] Pusheando main...
git push origin main
if errorlevel 1 (
  echo [merge_phase_to_main] ERROR: git push origin main fallo.
  popd >nul
  exit /b 1
)

echo [merge_phase_to_main] Estado final:
git status --short --branch
popd >nul
exit /b 0

:require_clean_tree
set "DIRTY="
for /f "delims=" %%A in ('git status --porcelain') do set "DIRTY=1"
if defined DIRTY (
  echo [merge_phase_to_main] ERROR: El working tree no esta limpio.
  git status --short
  exit /b 1
)
exit /b 0
