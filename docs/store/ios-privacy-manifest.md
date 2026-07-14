# iOS privacy manifest - Mascotify

Fecha: 2026-06-18

## Archivo

El proyecto incluye `ios/Runner/PrivacyInfo.xcprivacy` y lo agrega al target
Runner como recurso de iOS.

## Declaracion actual

- `NSPrivacyTracking`: `false`.
- `NSPrivacyTrackingDomains`: vacio.
- `NSPrivacyCollectedDataTypes`: vacio en el manifest nativo.
- `NSPrivacyAccessedAPITypes`: declara `NSPrivacyAccessedAPICategoryUserDefaults`
  con razon `CA92.1`.

La razon `CA92.1` cubre el uso de preferencias locales exclusivas de la app. En
Mascotify aplica a `shared_preferences`, que hoy guarda estado local como tema,
idioma, datos demo/locales y preferencias de experiencia.

## Alcance honesto de esta beta

- No se declara tracking.
- No se declara AdMob produccion.
- No se declara pagos reales.
- No se declara backend productivo obligatorio.
- No se declara geolocalizacion precisa nativa productiva.
- Los datos de mascotas, salud, vacunas, matching, reportes y QR son parte de
  la experiencia local/demo/beta y deben reflejarse en App Store Connect App
  Privacy antes de cualquier publicacion.

## Pendientes antes de App Store/TestFlight

1. Abrir el proyecto en Xcode.
2. Ejecutar Archive en Mac.
3. Generar el Privacy Report desde el Organizer de Xcode.
4. Comparar el reporte con la ficha App Privacy de App Store Connect.
5. Revisar los manifests de SDKs/plugins incluidos por CocoaPods o Swift
   Package Manager.
6. Actualizar politica de privacidad, App Privacy y este manifest si se activan:
   backend real, Google/Firebase productivo, analytics, crash reporting,
   notificaciones, uploads reales, geolocalizacion, anuncios o pagos.

Referencias oficiales:

- Apple Privacy Manifest files: https://developer.apple.com/documentation/bundleresources/privacy-manifest-files
- Apple required reason APIs: https://developer.apple.com/documentation/bundleresources/describing-use-of-required-reason-api
