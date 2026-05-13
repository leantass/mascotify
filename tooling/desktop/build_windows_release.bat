@echo off
setlocal

set "ROOT_DIR=%~dp0..\.."
set "FLUTTER=C:\src\flutter\bin\flutter.bat"
set "EXE_PATH=%ROOT_DIR%\build\windows\x64\runner\Release\mascotify.exe"

cd /d "%ROOT_DIR%"

echo [build_windows_release] Generando build Windows release de Mascotify...
echo [build_windows_release] No firma instaladores, no publica y no toca Git.

if not exist "%FLUTTER%" (
  echo [build_windows_release] ERROR: No se encontro Flutter en %FLUTTER%.
  exit /b 1
)

call "%FLUTTER%" build windows
if errorlevel 1 (
  echo [build_windows_release] ERROR: fallo el build Windows.
  echo [build_windows_release] Revisar Visual Studio, Desktop development with C++ y Windows SDK.
  exit /b 1
)

if not exist "%EXE_PATH%" (
  echo [build_windows_release] ERROR: el build termino, pero no se encontro el ejecutable esperado:
  echo [build_windows_release] %EXE_PATH%
  exit /b 1
)

echo [build_windows_release] Build Windows generado correctamente:
echo [build_windows_release] build\windows\x64\runner\Release\mascotify.exe

endlocal
