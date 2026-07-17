@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "WEB_DIR=C:\Users\PC\Desktop\Proyecto\mascotify\web-guia-app"
set "PORT=8088"
set "HOST=localhost"
set "PHP_EXE="
set "CHROME_EXE="
set "OPENED_CHROME=0"

cd /d "%WEB_DIR%" || (
    echo No se pudo entrar a %WEB_DIR%.
    exit /b 1
)

echo Mascotify Web Guia App
echo Carpeta: %WEB_DIR%
echo.

for /f "usebackq delims=" %%P in (`powershell -NoProfile -ExecutionPolicy Bypass -Command "[System.Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path','User')" 2^>nul`) do (
    set "PATH=%%P;%PATH%"
)

for /f "delims=" %%P in ('where php 2^>nul') do (
    if not defined PHP_EXE set "PHP_EXE=%%P"
)

if not defined PHP_EXE if exist "C:\xampp\php\php.exe" set "PHP_EXE=C:\xampp\php\php.exe"

if not defined PHP_EXE (
    for /d %%D in ("C:\laragon\bin\php\php-*") do (
        if exist "%%~fD\php.exe" if not defined PHP_EXE set "PHP_EXE=%%~fD\php.exe"
    )
)

if not defined PHP_EXE if exist "C:\php\php.exe" set "PHP_EXE=C:\php\php.exe"
if not defined PHP_EXE if exist "C:\tools\php\php.exe" set "PHP_EXE=C:\tools\php\php.exe"

if not defined PHP_EXE (
    for /d %%D in ("%LOCALAPPDATA%\Microsoft\WinGet\Packages\PHP.PHP.*") do (
        if exist "%%~fD\php.exe" if not defined PHP_EXE set "PHP_EXE=%%~fD\php.exe"
    )
)

if not defined PHP_EXE (
    echo PHP no esta disponible.
    echo La web local NO se abrio porque el servidor PHP no puede iniciarse.
    echo.
    where winget >nul 2>nul
    if errorlevel 1 (
        echo winget no esta disponible para sugerir instalacion automatizada.
    ) else (
        echo winget esta disponible. Instalacion sugerida, visible y manual:
        echo winget install PHP.PHP.8.2
    )
    echo.
    echo Instalar PHP 8.1, 8.2 o superior y agregarlo al PATH.
    echo Luego volver a ejecutar: tooling\open_web_after_task.bat
    exit /b 1
)

echo PHP encontrado:
echo !PHP_EXE!
"!PHP_EXE!" -v
echo.

if exist "C:\Program Files\Google\Chrome\Application\chrome.exe" set "CHROME_EXE=C:\Program Files\Google\Chrome\Application\chrome.exe"
if not defined CHROME_EXE if exist "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" set "CHROME_EXE=C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
if not defined CHROME_EXE if exist "%LOCALAPPDATA%\Google\Chrome\Application\chrome.exe" set "CHROME_EXE=%LOCALAPPDATA%\Google\Chrome\Application\chrome.exe"

if not defined CHROME_EXE (
    echo Chrome no encontrado.
    echo No se abre Edge ni el navegador predeterminado.
    echo Instalar Google Chrome o revisar la ruta de instalacion.
    exit /b 1
)

netstat -ano | findstr /r /c:":%PORT% .*LISTENING" >nul 2>nul
if errorlevel 1 (
    echo Iniciando servidor local en http://%HOST%:%PORT%/
    start "Mascotify Web Guia App Server" /D "%WEB_DIR%" "!PHP_EXE!" -S %HOST%:%PORT%
    ping 127.0.0.1 -n 4 >nul
) else (
    echo El puerto %PORT% ya esta escuchando. Se reutiliza el servidor local activo.
)

set "URL=http://%HOST%:%PORT%/?cb=%RANDOM%"
echo Abriendo Chrome:
echo !URL!
if "!OPENED_CHROME!"=="0" (
    set "OPENED_CHROME=1"
    start "Mascotify Web Guia App Chrome" "!CHROME_EXE!" "!URL!"
)
echo.
echo URL abierta: !URL!
echo Navegador usado: Chrome
echo Cache busting: si
echo Edge: no abierto por este script
exit /b 0
