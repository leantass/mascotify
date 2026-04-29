# Runtime modes

## Modo actual: demo/local

Mascotify corre por defecto en `AppRuntimeMode.demoLocal`.

En este modo la app muestra una experiencia completa de demo local:

- Auth local con cuentas demo y cuentas creadas en el dispositivo.
- Mascotas, QR, historial, feed, mensajes, notificaciones y preferencias persistidas localmente.
- Demo web servida desde `build\web`.
- Paquete ZIP demo en `dist\demo\mascotify-demo-web.zip`.

La configuracion central vive en:

```text
lib/core/app_environment.dart
```

## Datos locales

Los datos se guardan localmente en el navegador/dispositivo mediante la capa persistente actual. La UI consume `AppData`, y `AppData` delega en `MascotifyDataSource`.

La implementacion activa sigue siendo:

```text
PersistentLocalMascotifyDataSource
```

## Que no esta conectado todavia

- Backend real.
- Auth productiva.
- Google Auth productivo.
- Firebase productivo.
- Pagos reales.
- Push notifications reales.
- Geolocalizacion real.
- Camara real para QR.
- Sincronizacion entre dispositivos.
- Deploy productivo.

## Que cambiaria en modo produccion

Un futuro modo produccion deberia cambiar la fuente activa de datos o sumar adaptadores por modulo debajo de `MascotifyDataSource`.

El objetivo es que la UI siga leyendo desde `AppData`, mientras la infraestructura decide si usa datos locales, cache, API REST, GraphQL u otra capa remota.

## Modulos a conectar a backend

- Auth y sesiones.
- Usuario, perfil y preferencias.
- Mascotas.
- QR y trazabilidad.
- Mensajes.
- Notificaciones.
- Feed e historial.
- Suscripciones y pagos.

## Modulos ya preparados para migrar

- La UI ya consume una fachada central (`AppData`).
- Existe un contrato comun (`MascotifyDataSource`).
- Existe una implementacion local persistente.
- Existe un placeholder remoto abstracto en `lib/shared/data/remote/`.
- Hay tests de regresion para persistencia local, demo y arquitectura.

## Limites actuales

- El modo produccion todavia no esta implementado.
- Cambiar `AppRuntimeMode.production` no conecta servicios reales por si solo.
- No hay estrategia de sync local/remoto activa.
- No hay resolucion de conflictos.
- No hay migracion de IDs locales a IDs remotos.

## Riesgos de migracion

- Conflictos entre datos locales y remotos.
- Sesiones vencidas o permisos por rol.
- Duplicacion de mascotas, mensajes o notificaciones al sincronizar.
- Experiencia offline incompleta.
- UI dependiendo de detalles de API si se saltea la fachada.

## Orden sugerido

1. Auth real y sesion productiva.
2. Usuario/perfil/preferencias.
3. Mascotas.
4. QR/trazabilidad.
5. Mensajes.
6. Notificaciones.
7. Feed/historial.
8. Pagos y suscripciones.

Cada paso deberia conservar la demo local hasta que el modulo productivo tenga tests de contrato y regresion.
