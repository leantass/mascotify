@echo off
setlocal

set "ROOT=%~dp0..\.."
set "KEY_PROPERTIES=%ROOT%\android\key.properties"

if not exist "%KEY_PROPERTIES%" (
  echo [release_signing] NO: android\key.properties no existe.
  exit /b 1
)

for /f "usebackq tokens=1,* delims==" %%A in ("%KEY_PROPERTIES%") do (
  if /I "%%A"=="storeFile" set "STORE_FILE=%%B"
  if /I "%%A"=="storePassword" set "STORE_PASSWORD_SET=1"
  if /I "%%A"=="keyPassword" set "KEY_PASSWORD_SET=1"
  if /I "%%A"=="keyAlias" set "KEY_ALIAS_SET=1"
)

if not defined STORE_FILE (
  echo [release_signing] NO: falta storeFile en android\key.properties.
  exit /b 1
)

if not defined STORE_PASSWORD_SET (
  echo [release_signing] NO: falta storePassword.
  exit /b 1
)

if not defined KEY_PASSWORD_SET (
  echo [release_signing] NO: falta keyPassword.
  exit /b 1
)

if not defined KEY_ALIAS_SET (
  echo [release_signing] NO: falta keyAlias.
  exit /b 1
)

if "%STORE_FILE:~1,1%"==":" (
  set "KEYSTORE=%STORE_FILE%"
) else (
  set "KEYSTORE=%ROOT%\android\%STORE_FILE%"
)

if not exist "%KEYSTORE%" (
  echo [release_signing] NO: no existe el keystore declarado.
  exit /b 1
)

echo [release_signing] OK: firma release configurada localmente.
exit /b 0
