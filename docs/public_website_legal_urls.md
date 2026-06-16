# URLs públicas y legales de Mascotify

## URL principal
[URL_PUBLICA_MASCOTIFY]

## URLs legales
- Política de privacidad: [URL_PUBLICA_MASCOTIFY]/privacidad.html
- Términos y condiciones: [URL_PUBLICA_MASCOTIFY]/terminos.html
- Eliminación de cuenta y datos: [URL_PUBLICA_MASCOTIFY]/eliminacion-de-cuenta.html
- Soporte: [URL_PUBLICA_MASCOTIFY]/soporte.html
- Índice legal: [URL_PUBLICA_MASCOTIFY]/legal.html

## Uso esperado en Play Console y App Store
Estas URLs están pensadas para:
- Play Console
- App Store Connect
- Página pública de Mascotify
- Links legales dentro de la app
- Soporte y eliminación de cuenta/datos

## Puntos de integración en Flutter
- `lib/features/profile/presentation/screens/profile_screen.dart`: muestra las opciones de cuenta y es un punto natural para enlazar privacidad, términos, soporte y legal.
- `lib/shared/data/mock_data.dart`: define la opción `Configuración`, hoy sin wiring a URLs legales reales.
- `lib/features/auth/presentation/screens/auth_placeholder_screen.dart`: ya menciona el canal de soporte en el diálogo de recuperación de acceso y puede reutilizar las URLs centralizadas cuando se conecte ese flujo.
- `lib/shared/config/legal_links.dart`: concentra las URLs legales para evitar hardcodearlas en múltiples pantallas.

## Pendientes antes de publicar
- Confirmar dominio final.
- Completar responsable legal.
- Completar email de soporte.
- Revisar textos con asesoría legal.
- Publicar el sitio.
- Verificar que las URLs funcionen públicamente antes de subir la app a stores.

## Aclaración legal
Los textos legales actuales son una base preliminar y requieren revisión legal antes de su publicación definitiva.
