@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "PHP_EXE="

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

if defined PHP_EXE (
    echo PHP encontrado:
    echo !PHP_EXE!
    echo.
    "!PHP_EXE!" -v
    exit /b 0
)

echo PHP no esta disponible.
echo Instalar PHP 8.1, 8.2 o superior y agregarlo al PATH.
echo Tambien se revisaron ubicaciones comunes: XAMPP, Laragon, C:\php, C:\tools\php y paquetes de WinGet.
exit /b 1
