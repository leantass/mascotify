# Google Play Internal Testing - Mascotify

Este documento prepara la subida manual o automatizada segura. No publica
produccion.

## Archivo a subir

- Para Google Play se requiere AAB release firmado.
- El APK debug interno sirve para pruebas directas en telefono, pero no para un
  release Play Console.
- Paquete local preparado:
  `C:\Users\PC\Desktop\Proyecto\mascotify_functional_builds\play-upload`
- AAB local esperado:
  `mascotify-android-release-latest.aab`
- Version/build actual para el paquete nuevo: `1.0.0+3`.

## Pasos manuales

1. Crear app en Play Console.
2. Completar ficha de tienda minima.
3. Completar Politica de privacidad, Data Safety, Ads declaration, Content
   rating y Target audience.
4. Configurar App signing.
5. Generar AAB release firmado localmente.
6. Crear track Internal Testing.
7. Agregar testers.
8. Subir AAB.
9. Cargar notas de release.
10. Enviar a revision interna.

## No hacer todavia

- No pasar a produccion publica.
- No activar rollout abierto.
- No activar pagos reales.
- No activar AdMob produccion.

## Estado actual

- Automatizacion Play: no detectada.
- Service account segura: no detectada.
- AAB release: generado localmente con firma release.
- Subida Play: pendiente de ejecucion manual o configuracion segura de credenciales.
- El paquete `1.0.0+3` debe reemplazar al build interno anterior antes de
  enviarlo a testers.
