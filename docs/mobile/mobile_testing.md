# Mascotify - Pruebas mobile

## Alcance actual

La app sigue siendo una demo local Flutter/web-desktop, pero se agrego una capa de QA especifica para validar comportamiento responsive en tamanos de celular. El foco practico en Windows es Android.

## Tests automaticos mobile

Archivo:

```text
test/regression/mobile_responsive_test.dart
```

Cubre:

- Auth/login/registro en viewport mobile.
- Onboarding familia.
- Onboarding profesional.
- Dashboard familia.
- Mascotas: listado, alta, detalle.
- QR/trazabilidad e historial.
- Feed general con busqueda y estado sin resultados.
- Mensajes: inbox, conversacion y envio.
- Notificaciones.
- Perfil/configuracion.
- Viewports 360x800, 390x844 y 412x915.

Estos tests son widget/responsive tests. Detectan excepciones de layout capturables por Flutter Test y validan que los flujos principales sigan accesibles con scroll. No reemplazan una prueba manual en emulador o dispositivo real.

## Como correr solo los tests mobile

```bat
C:\src\flutter\bin\flutter.bat test test\regression\mobile_responsive_test.dart
```

## Como correr toda la suite Flutter

```bat
C:\src\flutter\bin\flutter.bat test
```

O la validacion local completa:

```bat
tooling\git_flow\check_local.bat
```

`check_local` ejecuta analyze, tests y build web.

## Build APK debug

Opcion recomendada:

```bat
tooling\mobile\build_android_debug.bat
```

El detalle de instalacion y checklist de prueba real esta en:

```text
docs/mobile/android_debug_apk.md
```

Comando Flutter equivalente:

```bat
C:\src\flutter\bin\flutter.bat build apk --debug
```

Si el build es exitoso, el APK queda en:

```text
build\app\outputs\flutter-apk\app-debug.apk
```

No se genera APK release firmado en esta fase. No se toca keystore ni Play Store.

## Prueba en dispositivo o emulador Android

Ver dispositivos:

```bat
tooling\mobile\android_devices.bat
```

Correr la app en Android con Flutter:

```bat
tooling\mobile\run_android_debug.bat
```

Guia completa:

```text
docs/mobile/android_device_testing.md
```

## Preparacion para release Android futura

Auditoria y checklist pre Play Store:

```text
docs/mobile/android_release_readiness.md
docs/mobile/android_release_checklist.md
```

Diagnostico Android seguro:

```bat
tooling\mobile\android_release_check.bat
```

## Diferencia entre validaciones

- Tests widget/responsive: prueban pantallas en tamanos mobile dentro de Flutter Test.
- Build Android: confirma que el proyecto compila para Android.
- Emulador/dispositivo real: valida interaccion real, teclado, performance, gestos, permisos y comportamiento del sistema operativo.

## Pendientes mobile reales

- Prueba manual en emulador Android.
- Prueba manual en dispositivo fisico.
- Integration tests futuros si se decide automatizar flujos en dispositivo.
- Revision de teclado real en formularios largos.
- APK release firmado futuro.
- Publicacion Play Store futura.
