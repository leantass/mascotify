@echo off
setlocal EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
set "BRANCH=%~1"

if "%BRANCH%"=="" (
  echo Uso: tooling\git_flow\start_phase.bat juagotecica7/nombre-rama
  exit /b 1
)

pushd "%SCRIPT_DIR%..\.." >nul
if errorlevel 1 (
  echo [start_phase] ERROR: No se pudo entrar a la raiz del repo.
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

git show-ref --verify --quiet "refs/heads/%BRANCH%"
if not errorlevel 1 (
  echo [start_phase] ERROR: La rama local "%BRANCH%" ya existe.
  popd >nul
  exit /b 1
)

git ls-remote --exit-code --heads origin "%BRANCH%" >nul 2>nul
if not errorlevel 1 (
  echo [start_phase] ERROR: La rama remota "%BRANCH%" ya existe.
  popd >nul
  exit /b 1
)

echo [start_phase] Cambiando a main...
git checkout main
if errorlevel 1 (
  echo [start_phase] ERROR: No se pudo cambiar a main.
  popd >nul
  exit /b 1
)

echo [start_phase] Actualizando main...
git pull origin main
if errorlevel 1 (
  echo [start_phase] ERROR: git pull origin main fallo.
  popd >nul
  exit /b 1
)

echo [start_phase] Creando rama "%BRANCH%"...
git checkout -b "%BRANCH%"
if errorlevel 1 (
  echo [start_phase] ERROR: No se pudo crear la rama.
  popd >nul
  exit /b 1
)

echo [start_phase] Publicando rama...
git push -u origin "%BRANCH%"
if errorlevel 1 (
  echo [start_phase] ERROR: No se pudo pushear la rama.
  popd >nul
  exit /b 1
)

echo [start_phase] OK: fase iniciada en "%BRANCH%".
git status --short --branch
popd >nul
exit /b 0

:require_clean_tree
set "DIRTY="
for /f "delims=" %%A in ('git status --porcelain') do set "DIRTY=1"
if defined DIRTY (
  echo [start_phase] ERROR: El working tree no esta limpio.
  git status --short
  exit /b 1
)
exit /b 0
