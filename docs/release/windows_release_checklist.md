# Mascotify - Windows desktop release checklist

## Build

- [ ] Visual Studio instalado con Desktop development with C++.
- [ ] Windows SDK instalado.
- [ ] `C:\src\flutter\bin\flutter.bat doctor`.
- [ ] `C:\src\flutter\bin\flutter.bat build windows`.
- [ ] Verificar `build/windows/x64/runner/Release/mascotify.exe`.
- [ ] Probar la app en Windows real.

Validacion local 2026-05-13: `flutter build windows` no compilo porque Flutter no encontro Visual Studio. Instalar Visual Studio con la workload "Desktop development with C++" antes de reintentar.

## Metadata

- [ ] Cambiar `CompanyName` desde `com.example` a nombre definitivo.
- [ ] Cambiar `ProductName` a `Mascotify`.
- [ ] Cambiar `FileDescription` a texto final.
- [ ] Revisar copyright.
- [ ] Revisar icono `.ico`.
- [ ] Revisar nombre de ventana si corresponde.

## Distribucion

- [ ] Definir canal: zip portable, instalador, Microsoft Store u otro.
- [ ] Crear instalador si corresponde.
- [ ] Firmar ejecutable/instalador con certificado de codigo.
- [ ] Validar SmartScreen.
- [ ] Documentar requisitos minimos.
- [ ] Probar instalacion/desinstalacion si hay instalador.

## Script local

Build release seguro:

```bat
tooling\desktop\build_windows_release.bat
```

El script no firma, no publica y no toca Git.
