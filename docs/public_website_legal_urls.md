# URLs publicas y legales de Mascotify

## URL principal
[URL_PUBLICA_MASCOTIFY]

## Acceso a Mascotify
La seccion `#usar-mascotify` concentra los accesos a la app:
- Mascotify Web: [URL_APP_WEB_MASCOTIFY]
- App Store: [URL_APP_STORE_MASCOTIFY]
- Play Store: [URL_PLAY_STORE_MASCOTIFY]

Pendientes:
- Reemplazar `[URL_APP_WEB_MASCOTIFY]` cuando exista la URL final de la app web.
- Reemplazar `[URL_APP_STORE_MASCOTIFY]` cuando la app este publicada en App Store.
- Reemplazar `[URL_PLAY_STORE_MASCOTIFY]` cuando la app este publicada en Google Play.
- Si todavia no existe link real, mantener el estado "Proximamente".

## URLs legales
- Politica de privacidad: [URL_PUBLICA_MASCOTIFY]/privacidad
- Terminos y condiciones: [URL_PUBLICA_MASCOTIFY]/terminos
- Eliminacion de cuenta y datos: [URL_PUBLICA_MASCOTIFY]/eliminacion-de-cuenta
- Soporte: [URL_PUBLICA_MASCOTIFY]/soporte
- Indice legal: [URL_PUBLICA_MASCOTIFY]/legal

## Uso esperado en Play Console y App Store
Estas URLs estan pensadas para:
- Play Console
- App Store Connect
- Pagina publica de Mascotify
- Links legales dentro de la app
- Soporte y eliminacion de cuenta/datos

## Puntos de integracion en Flutter
- `lib/features/profile/presentation/screens/profile_screen.dart`: muestra las opciones de cuenta y es un punto natural para enlazar privacidad, terminos, soporte y legal.
- `lib/shared/data/mock_data.dart`: define la opcion `Configuracion`, hoy sin wiring a URLs legales reales.
- `lib/features/auth/presentation/screens/auth_placeholder_screen.dart`: ya menciona el canal de soporte en el dialogo de recuperacion de acceso y puede reutilizar las URLs centralizadas cuando se conecte ese flujo.
- `lib/shared/config/legal_links.dart`: concentra las URLs legales para evitar hardcodearlas en multiples pantallas.

## Pendientes antes de publicar
- Confirmar dominio final.
- Completar responsable legal.
- Completar email de soporte.
- Revisar textos con asesoria legal.
- Publicar el sitio.
- Verificar que las URLs funcionen publicamente antes de subir la app a stores.

## Aclaracion legal
Los textos legales actuales son una base preliminar y requieren revision legal antes de su publicacion definitiva.
