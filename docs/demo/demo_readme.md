# Mascotify - Demo web local

## Que es Mascotify

Mascotify es una app Flutter/web-desktop pensada como ecosistema para mascotas, familias y profesionales. La demo actual permite gestionar mascotas, perfiles, QR, actividad, mensajes, notificaciones y preferencias con persistencia local.

## Estado de la demo

La demo funciona de forma local y persistente en el navegador o entorno local. No usa backend real y no publica datos en servicios externos.

Es una demo web estatica/local para mostrar navegacion, flujos principales y estado actual del producto.

## Funcionalidades incluidas

- Login/demo familia.
- Login/demo profesional.
- Onboarding local.
- Gestion de mascotas.
- Edicion y eliminacion de mascotas.
- QR y trazabilidad local.
- Historial de actividad por mascota.
- Feed general de actividad con filtros y busqueda.
- Mensajeria local persistente.
- Notificaciones internas persistentes y navegables.
- Preferencias y plan local persistente.
- Perfil profesional/demo.
- Build web.
- Tests automaticos.

## Que NO incluye todavia

- Backend real.
- Firebase/Google Auth real configurado.
- Push notifications reales.
- Camara real para QR.
- Geolocalizacion real.
- Pagos reales.
- Publicacion en stores.
- Deploy productivo.

## Requisitos locales

- Flutter instalado en `C:\src\flutter`.
- Chrome disponible.
- Git si se trabaja con ramas.
- Python opcional para servir la build web local.

## Como correr en modo desarrollo

Desde la raiz del proyecto:

```bat
C:\src\flutter\bin\flutter.bat run -d chrome
```

## Como validar localmente

Validacion completa local:

```bat
tooling\git_flow\check_local.bat
```

Validacion manual equivalente:

```bat
C:\src\flutter\bin\flutter.bat analyze
C:\src\flutter\bin\flutter.bat test
C:\src\flutter\bin\flutter.bat build web
```

## Como generar build web

```bat
tooling\demo\build_web_demo.bat
```

La salida queda en:

```text
build\web
```

## Como servir la demo web local

```bat
tooling\demo\serve_web_demo.bat
```

URL local:

```text
http://localhost:8080
```

## Como generar paquete ZIP entregable

```bat
tooling\demo\package_web_demo.bat
```

Salida esperada:

```text
dist\demo\mascotify-demo-web.zip
```

## Como probar la demo sugerida

1. Entrar con demo familia.
2. Crear mascota.
3. Editar mascota.
4. Abrir detalle.
5. Revisar QR/trazabilidad.
6. Revisar historial.
7. Ir al feed.
8. Probar filtros/busqueda.
9. Revisar mensajes.
10. Revisar notificaciones.
11. Cambiar preferencias.
12. Cerrar sesion.
13. Entrar con demo profesional.
14. Revisar dashboard profesional/perfil publico.

## Validacion automatica

GitHub Actions ejecuta automaticamente:

- `flutter analyze`
- `flutter test`
- `flutter build web`

El workflow corre en `push`, `pull_request`, ejecucion manual y schedule nocturno.

## Notas para entrega

El zip `dist\demo\mascotify-demo-web.zip` contiene una build web estatica. Despues de descomprimirlo, servir la carpeta con un servidor estatico simple:

```bat
python -m http.server 8080
```

O:

```bat
py -m http.server 8080
```

Luego abrir:

```text
http://localhost:8080
```

No conviene abrir `index.html` directamente con doble click si aparecen problemas de rutas, carga o pantalla blanca.

## Proximas fases sugeridas

- Backend real.
- Auth real.
- Push notifications reales.
- QR con camara.
- Geolocalizacion.
- Deploy web productivo.
- App mobile release.
