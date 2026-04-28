# Checklist de demo web/local Mascotify

## Objetivo

Preparar una corrida local presentable de Mascotify para mostrar el ecosistema actual sin prometer backend, push real, camara, geolocalizacion real, pagos ni deploy.

## Rama recomendada

- `juagotecica7/mascotify-demo-release`

## Comandos utiles

Ejecutar desde la raiz del proyecto `mascotify`:

```bat
C:\src\flutter\bin\flutter.bat run -d chrome
C:\src\flutter\bin\flutter.bat analyze
C:\src\flutter\bin\flutter.bat test
C:\src\flutter\bin\flutter.bat build web
```

GitHub Actions tambien corre automaticamente en `push`, `pull_request`, ejecucion manual y schedule nocturno.

## Validar Antes De Mostrar

- La app abre en Chrome sin pantalla blanca.
- `flutter analyze` pasa sin issues.
- `flutter test` pasa completo.
- `flutter build web` termina OK.
- El flujo demo familia permite navegar Inicio, Mascotas, Actividad, Explorar y Perfil.
- El flujo demo profesional permite navegar Inicio, Servicios, Actividad, Explorar y Perfil.
- El logout vuelve a Auth y oculta datos privados.

## Flujo Familia Para Demo

1. Entrar con `Demo familiar`.
2. Mostrar Home como centro operativo.
3. Abrir Mascotas y mostrar fichas existentes.
4. Abrir una mascota y mostrar detalle, historial y trazabilidad QR.
5. Abrir Actividad y probar busqueda/filtros.
6. Abrir Notificaciones desde Home.
7. Abrir Mensajes desde Home o Explorar.
8. Abrir Perfil y mostrar preferencias locales.
9. Cerrar sesion.

## Flujo Profesional Para Demo

1. Entrar con `Demo profesional`.
2. Mostrar Dashboard profesional.
3. Abrir Servicios.
4. Activar o abrir presencia profesional, segun el estado actual.
5. Mostrar perfil publico profesional.
6. Abrir Actividad.
7. Abrir Perfil y preferencias.
8. Cerrar sesion.

## Modulos Listos Para Mostrar

- Auth local con accesos demo.
- Mascotas con alta, edicion, eliminacion y persistencia.
- QR local persistente y trazabilidad.
- Historial de actividad por mascota.
- Feed general con busqueda, filtros y navegacion contextual.
- Mensajeria local persistente por cuenta.
- Notificaciones internas persistentes y navegables.
- Preferencias locales por cuenta.
- Modo profesional local con workspace y presencia publica.

## Modulos Locales/Demo

- Los datos viven localmente en el navegador/dispositivo.
- Las notificaciones son internas, no push reales.
- QR y avistamientos usan trazabilidad local, sin camara ni geolocalizacion real.
- Google Auth/Firebase/backend no estan conectados en esta demo.
- No hay deploy automatico ni publicacion en stores.

## Que No Mostrar Como Feature Final

- No presentar notificaciones internas como push reales.
- No presentar QR como escaneo con camara real.
- No presentar ubicacion como geolocalizacion del dispositivo.
- No presentar cuentas demo como usuarios productivos.
- No presentar preferencias de plan como pagos reales.

## Cierre De Demo

- Terminar en Perfil y cerrar sesion.
- Aclarar que el objetivo de esta version es validar el ecosistema local y la navegacion completa antes de conectar servicios externos.
