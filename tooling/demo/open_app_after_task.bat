@echo off
setlocal EnableExtensions

set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..\..") do set "REPO_ROOT=%%~fI"
set "PACKAGE_DIR=%REPO_ROOT%\..\mascotify_functional_builds\mascotify-functional-review-web"
set "URL_FILE=%PACKAGE_DIR%\.mascotify-demo-url.txt"

echo [open_app_after_task] Preparando Mascotify desde:
echo [open_app_after_task] %REPO_ROOT%
echo.

cd /d "%REPO_ROOT%" || exit /b 1

where flutter >nul 2>nul
if "%ERRORLEVEL%"=="0" (
  set "FLUTTER_CMD=flutter"
) else (
  if exist "C:\src\flutter\bin\flutter.bat" (
    set "FLUTTER_CMD=C:\src\flutter\bin\flutter.bat"
  ) else (
    echo [open_app_after_task] ERROR: No se encontro Flutter en PATH ni en C:\src\flutter\bin\flutter.bat.
    exit /b 1
  )
)

echo [open_app_after_task] Usando Flutter: %FLUTTER_CMD%
echo [open_app_after_task] Generando build web release...
if /I "%FLUTTER_CMD%"=="flutter" (
  call flutter build web --release
) else (
  call "%FLUTTER_CMD%" build web --release
)
if not "%ERRORLEVEL%"=="0" exit /b %ERRORLEVEL%

echo.
echo [open_app_after_task] Empaquetando demo web funcional...
call "%SCRIPT_DIR%package_web_functional_review.bat"
if not "%ERRORLEVEL%"=="0" exit /b %ERRORLEVEL%

if not exist "%PACKAGE_DIR%\INICIAR_MASCOTIFY.bat" (
  echo [open_app_after_task] ERROR: No se encontro el launcher en:
  echo [open_app_after_task] %PACKAGE_DIR%
  exit /b 1
)

if exist "%URL_FILE%" del /f /q "%URL_FILE%" >nul 2>nul

echo.
echo [open_app_after_task] Abriendo Mascotify en una ventana separada...
start "Mascotify Demo" cmd /k "cd /d ""%PACKAGE_DIR%"" && call ""INICIAR_MASCOTIFY.bat"""

set "OPENED_URL="
for /L %%I in (1,1,20) do (
  if exist "%URL_FILE%" (
    set /p OPENED_URL=<"%URL_FILE%"
    goto :url_ready
  )
  timeout /t 1 /nobreak >nul
)

:url_ready
if defined OPENED_URL (
  echo [open_app_after_task] Mascotify quedo abierta en el navegador para prueba.
  echo [open_app_after_task] URL: %OPENED_URL%
) else (
  echo [open_app_after_task] Mascotify quedo iniciandose en una ventana separada.
  echo [open_app_after_task] La URL se muestra en esa ventana.
)

exit /b 0
