# Mascotify beta interna

Fecha: 2026-06-12

Esta beta interna esta pensada para validacion en telefono Android y web local antes de cualquier publicacion publica.

## Version 1.0.0+2

- AAB release firmado generado localmente para Google Play Internal Testing.
- Paquete local `play-upload` preparado con AAB, hash SHA256 y documentacion de tienda.
- APK debug interno preparado para pruebas directas en telefono.
- Web review local preparada con cache busting.
- Clips con viewer vertical, HUD mas limpio y seekbar inferior estilo TikTok.
- Matching tipo swipe/card visible desde el inicio.
- Ayuda centralizada/contextual disponible cuando aplica.
- Profesionales pet visible como beta/proximamente, sin modulo real activo.
- Documentacion inicial de terminos, privacidad, Data Safety, Play Console y
  store listing agregada para preparacion de publicacion.

## Android Internal Testing

- AAB local: `C:\Users\PC\Desktop\Proyecto\mascotify_functional_builds\release\mascotify-android-release-latest.aab`
- Paquete para Play Console: `C:\Users\PC\Desktop\Proyecto\mascotify_functional_builds\play-upload`
- Firma release: configurada localmente con keystore fuera del repo.
- Secretos: `android/key.properties` y la keystore local no se commitean.
- Publicacion Play: pendiente de subida manual a Internal Testing.

## Incluye

- Experiencia principal orientada a familias y tutores.
- Clips con viewer vertical, controles HUD y seekbar inferior estilo TikTok.
- Matching tipo swipe con cards visibles desde el inicio.
- Ayuda centralizada y accesos contextuales cuando aplica.
- Profesionales pet visibles como beta/proximamente, sin modulo operativo real.
- Builds internos para QA Android y review web local.

## No incluye publicacion publica

- No publica en Play Store.
- No activa pagos ni AdMob produccion.
- No despliega web productiva.
- No conecta backend real de matching, chat, agenda o reservas.

## Pendiente antes de publicar

- Revisar terminos y politica con datos legales reales.
- Completar Data Safety de Google Play con proveedores definitivos.
- Confirmar ficha, iconos, capturas y textos de tienda.
- Completar subida manual a Google Play Internal Testing.
- Configurar hosting web publico si se decide publicar web.
