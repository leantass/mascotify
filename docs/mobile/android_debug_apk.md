# Mascotify - APK debug Android

## Que es

Un APK debug es un paquete instalable de Android pensado para pruebas locales e internas. Sirve para probar Mascotify en un celular o emulador Android sin publicar nada en Play Store.

No es una version productiva. No esta firmada para release, no usa keystore de produccion y no representa una publicacion oficial.

## Como generarlo

Desde la raiz del proyecto:

```bat
tooling\mobile\build_android_debug.bat
```

El script ejecuta:

```bat
C:\src\flutter\bin\flutter.bat build apk --debug
```

Si el build falla, el script frena y muestra el error. No toca Git, no instala automaticamente en dispositivos y no genera release firmado.

## Donde queda

Si el build es exitoso:

```text
build\app\outputs\flutter-apk\app-debug.apk
```

## Como pasarlo al celular

Opciones simples:

- Cable USB y copiar el archivo al almacenamiento del telefono.
- Enviarlo por Drive, correo o mensajeria interna de confianza.
- Usar `adb install` si Android SDK esta instalado y el dispositivo esta autorizado.

Ejemplo con ADB:

```bat
adb install build\app\outputs\flutter-apk\app-debug.apk
```

## Como instalarlo

En Android puede hacer falta habilitar instalacion desde fuentes desconocidas para la app que abre el APK, por ejemplo Archivos, Drive o navegador.

Pasos generales:

1. Abrir el APK en el celular.
2. Si Android bloquea la instalacion, abrir la configuracion que ofrece el sistema.
3. Permitir instalacion desde esa fuente.
4. Volver al APK e instalar.

Los nombres exactos cambian segun version de Android y fabricante.

## Que probar en celular

- Login demo familia.
- Login demo profesional.
- Alternar iniciar sesion / crear cuenta.
- Onboarding familia.
- Onboarding profesional.
- Home/dashboard.
- Mascotas: listado, alta, edicion y eliminacion.
- Detalle de mascota.
- QR/trazabilidad.
- Feed general con busqueda/filtros.
- Mensajes: inbox, conversacion y envio.
- Notificaciones: listado, marcar leida y navegacion.
- Perfil/preferencias.
- Logout.
- Cerrar y abrir la app para revisar persistencia local.

## Que mirar visualmente

- Overflows o textos cortados.
- Scrolls raros o zonas inaccesibles.
- Teclado tapando campos.
- Botones demasiado chicos.
- Navegacion inferior apretada.
- Formularios en pantallas chicas.
- Cards o chips demasiado comprimidos.
- Pantallas blancas o bloqueos al volver atras.

## Problemas comunes

- Android bloquea instalacion: habilitar instalacion desde fuentes desconocidas para la app usada para abrir el APK.
- APK viejo instalado: desinstalar la version anterior o instalar encima si Android lo permite.
- Android SDK no configurado: revisar `ANDROID_HOME` y Android Studio/SDK Manager.
- Gradle o Java fallan: validar la instalacion Android local antes de tocar configuracion del proyecto.
- Pantalla chica: revisar scroll, botones y formularios con el checklist mobile.
- Teclado tapa campos: probar alta/edicion de mascota y auth en dispositivo real.

## Limites

- No publica en Play Store.
- No genera release firmado.
- No toca keystore.
- No configura Firebase ni Google Auth real.
- No conecta backend.
