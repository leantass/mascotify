@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
pushd "%SCRIPT_DIR%..\.." >nul
if errorlevel 1 (
  echo [clean_generated] ERROR: No se pudo entrar a la raiz del repo.
  exit /b 1
)

echo [clean_generated] Limpiando ruido local conocido...

git rev-parse --is-inside-work-tree >nul 2>nul
if errorlevel 1 (
  echo [clean_generated] ERROR: Esta carpeta no parece ser un repo Git.
  popd >nul
  exit /b 1
)

git restore -- "macos/Flutter/GeneratedPluginRegistrant.swift" "windows/flutter/generated_plugin_registrant.cc" "windows/flutter/generated_plugins.cmake" >nul 2>nul
if errorlevel 1 (
  echo [clean_generated] ERROR: No se pudieron restaurar archivos generados.
  popd >nul
  exit /b 1
)

call :delete_root_file "git"
if errorlevel 1 (
  popd >nul
  exit /b 1
)

call :delete_root_file "dir"
if errorlevel 1 (
  popd >nul
  exit /b 1
)

call :delete_root_file "flutter"
if errorlevel 1 (
  popd >nul
  exit /b 1
)

echo [clean_generated] OK.
popd >nul
exit /b 0

:delete_root_file
set "TARGET=%~1"
if exist "%TARGET%\" (
  echo [clean_generated] No se borra "%TARGET%" porque es una carpeta.
  exit /b 0
)
if exist "%TARGET%" (
  echo [clean_generated] Borrando archivo accidental "%TARGET%".
  del /f /q "%TARGET%"
  if errorlevel 1 (
    echo [clean_generated] ERROR: No se pudo borrar "%TARGET%".
    exit /b 1
  )
)
exit /b 0
