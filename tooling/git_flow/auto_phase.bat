@echo off
setlocal EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
set "BRANCH=%~1"
set "MESSAGE=%~2"

if "%BRANCH%"=="" (
  echo Uso: tooling\git_flow\auto_phase.bat juagotecica7/nombre-rama "Mensaje del commit"
  exit /b 1
)
if "%MESSAGE%"=="" (
  echo Uso: tooling\git_flow\auto_phase.bat juagotecica7/nombre-rama "Mensaje del commit"
  exit /b 1
)

pushd "%SCRIPT_DIR%..\.." >nul
if errorlevel 1 (
  echo [auto_phase] ERROR: No se pudo entrar a la raiz del repo.
  exit /b 1
)

echo [auto_phase] A. Validaciones iniciales
call "%SCRIPT_DIR%clean_generated.bat"
if errorlevel 1 (
  popd >nul
  exit /b 1
)

for /f "delims=" %%A in ('git branch --show-current') do set "CURRENT_BRANCH=%%A"
if "%CURRENT_BRANCH%"=="" (
  echo [auto_phase] ERROR: No se pudo detectar la rama actual.
  popd >nul
  exit /b 1
)
if "%CURRENT_BRANCH%"=="main" (
  echo [auto_phase] ERROR: auto_phase no corre desde main.
  popd >nul
  exit /b 1
)
if not "%CURRENT_BRANCH%"=="%BRANCH%" (
  echo [auto_phase] ERROR: La rama actual no coincide.
  echo [auto_phase] Rama actual: "%CURRENT_BRANCH%"
  echo [auto_phase] Rama esperada: "%BRANCH%"
  popd >nul
  exit /b 1
)

call "%SCRIPT_DIR%check_local.bat"
if errorlevel 1 (
  popd >nul
  exit /b 1
)

echo [auto_phase] B. Guardar fase
call :has_changes
if errorlevel 1 (
  echo [auto_phase] No hay cambios para commitear.
  git ls-remote --exit-code --heads origin "%BRANCH%" >nul 2>nul
  if errorlevel 1 (
    echo [auto_phase] ERROR: No hay cambios y la rama no existe remotamente.
    popd >nul
    exit /b 1
  )
) else (
  echo [auto_phase] Agregando cambios...
  git add -A
  if errorlevel 1 (
    echo [auto_phase] ERROR: git add fallo.
    popd >nul
    exit /b 1
  )

  echo [auto_phase] Creando commit...
  git commit -m "%MESSAGE%"
  if errorlevel 1 (
    echo [auto_phase] ERROR: git commit fallo.
    popd >nul
    exit /b 1
  )

  echo [auto_phase] Pusheando "%BRANCH%"...
  git push origin "%BRANCH%"
  if errorlevel 1 (
    echo [auto_phase] ERROR: git push de rama fallo.
    popd >nul
    exit /b 1
  )
)

echo [auto_phase] C. Merge seguro a main
git checkout main
if errorlevel 1 (
  echo [auto_phase] ERROR: No se pudo cambiar a main.
  popd >nul
  exit /b 1
)

git pull origin main
if errorlevel 1 (
  echo [auto_phase] ERROR: git pull origin main fallo.
  popd >nul
  exit /b 1
)

git merge "%BRANCH%"
if errorlevel 1 (
  echo [auto_phase] ERROR: El merge fallo. Si hay conflictos, resolvelos manualmente. No se pushea main.
  git status --short --branch
  popd >nul
  exit /b 1
)

call "%SCRIPT_DIR%check_local.bat"
if errorlevel 1 (
  echo [auto_phase] ERROR: Validacion local fallo en main. No se pushea main.
  popd >nul
  exit /b 1
)

git push origin main
if errorlevel 1 (
  echo [auto_phase] ERROR: git push origin main fallo.
  popd >nul
  exit /b 1
)

echo [auto_phase] D. Flujo terminado correctamente
git status --short --branch
popd >nul
exit /b 0

:has_changes
set "DIRTY="
for /f "delims=" %%A in ('git status --porcelain') do set "DIRTY=1"
if defined DIRTY exit /b 0
exit /b 1
