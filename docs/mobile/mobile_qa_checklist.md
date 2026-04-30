# Mascotify - Checklist QA mobile

## Objetivo

Validar que Mascotify sea usable en pantallas de celular, principalmente Android, sin overflows visibles, bloqueos de navegacion ni formularios inaccesibles.

## Dispositivos y tamanos sugeridos

- 360 x 800: Android compacto.
- 390 x 844: telefono medio.
- 412 x 915: telefono grande.
- Emulador Android con API reciente.
- Dispositivo Android fisico cuando este disponible.

## Prueba rapida en Chrome mobile-like

```bat
C:\src\flutter\bin\flutter.bat run -d chrome
```

Luego usar DevTools del navegador y activar un viewport mobile. Esta prueba ayuda a revisar layout, scroll y textos, pero no reemplaza el build Android.

## Prueba en emulador Android

1. Abrir Android Studio.
2. Iniciar un emulador Android.
3. Verificar dispositivos disponibles:

```bat
C:\src\flutter\bin\flutter.bat devices
```

4. Ejecutar:

```bat
C:\src\flutter\bin\flutter.bat run -d <device-id>
```

## Prueba en dispositivo Android fisico

1. Activar opciones de desarrollador y depuracion USB.
2. Conectar el dispositivo.
3. Aceptar la autorizacion USB.
4. Verificar:

```bat
C:\src\flutter\bin\flutter.bat devices
```

5. Ejecutar:

```bat
C:\src\flutter\bin\flutter.bat run -d <device-id>
```

## Checklist de flujos criticos

- [ ] Login demo familia.
- [ ] Login demo profesional.
- [ ] Alternar iniciar sesion / crear cuenta.
- [ ] Onboarding familia.
- [ ] Onboarding profesional.
- [ ] Dashboard familia.
- [ ] Navegacion principal mobile.
- [ ] Mascotas: estado vacio, listado, alta, detalle, editar y eliminar.
- [ ] QR/trazabilidad e historial QR.
- [ ] Historial de actividad por mascota.
- [ ] Feed general: busqueda, filtros y estado sin resultados.
- [ ] Mensajes: inbox, abrir conversacion y enviar mensaje.
- [ ] Notificaciones: listado, marcar leida y navegacion contextual.
- [ ] Perfil/configuracion: tabs, preferencias y plan.
- [ ] Logout.
- [ ] Persistencia despues de cerrar y abrir la app.

## Cosas a mirar

- Overflows amarillos/negros o errores de RenderFlex.
- Scrolls anidados dificiles de usar.
- Teclado tapando campos importantes.
- Botones demasiado chicos o muy pegados.
- Textos cortados o solapados.
- Navegacion inferior/lateral segun ancho.
- Cards demasiado apretadas.
- Formularios largos en pantallas compactas.
- Estados vacios comprensibles.
- Persistencia local entre sesiones.

## Criterio de aprobacion manual

La demo mobile queda aprobada para revision interna si los flujos criticos pueden completarse en un telefono compacto y en uno medio/grande sin bloqueos, pantallas blancas, errores visuales graves ni perdida de datos locales.
