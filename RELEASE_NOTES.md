# Mascotify beta interna

Fecha: 2026-06-12

Esta beta interna esta pensada para validacion en telefono Android y web local antes de cualquier publicacion publica.

## Version 1.0.0+6

- Hardening defensivo local/controlado: auditoria de secretos, hardcodes,
  dependencias, storage local, permisos, QR, matching y web/backend.
- Auth local de demo migra de hash FNV casero a PBKDF2-HMAC-SHA256 versionado,
  con compatibilidad de lectura para hashes previos.
- Backend local/API suma headers defensivos, limite JSON explicito y
  dependencias auditadas sin vulnerabilidades npm conocidas tras la actualizacion.
- ZIPs historicos de entrega removidos del repo y reglas de ignore reforzadas
  para evitar commitear artefactos de release.
- Reportes de seguridad y pentest seguro agregados sin incluir secretos.
- Requiere regenerar AAB/APK/web review para este build antes de subir a
  testing interno.

## Version 1.0.0+5

- Preparacion iOS/TestFlight agregada sin publicar en App Store Connect.
- Privacy manifest iOS incluido para Runner con declaracion de UserDefaults y
  sin tracking.
- Documentacion iOS creada para signing, TestFlight, App Store listing, privacy
  manifest y opciones de CI macOS.
- Workflow manual macOS agregado para validar build iOS simulator sin secretos
  y sin upload a TestFlight.
- Requiere Mac/Xcode o CI macOS seguro para generar Archive/IPA y subir a
  TestFlight.

## Version 1.0.0+4

- Formularios alineados al modo oscuro: campos de texto, selects/dropdowns,
  buscadores y campos en sheets/dialogs usan superficies slate/blue-gray,
  bordes sutiles, focus visible, placeholders legibles y estados de error
  coherentes.
- Alta/edicion de mascota, salud/vacunas, mascotas perdidas, QR seguro,
  login demo y contactos de soporte heredan el sistema visual dark-friendly.
- Modo claro conserva su comportamiento y contraste.
- APK debug interno, AAB release firmado, paquete `play-upload` y web review
  deben regenerarse con este build antes de subir a Internal Testing.

## Version 1.0.0+3

- Modo oscuro agregado con selector de Apariencia en Configuracion.
- Opciones de tema: usar sistema, modo claro y modo oscuro.
- Preferencia de tema guardada localmente y aplicada al abrir la app.
- Temas claro/oscuro preparados para pantallas principales, ayuda, clips,
  matching, modales, cards, chips, botones, loaders y navegacion.
- Help actualizado con el tema "Apariencia y modo oscuro".
- APK debug interno, AAB release firmado, paquete `play-upload` y web review
  deben regenerarse con este build antes de subir a Internal Testing.

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
