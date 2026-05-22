# AdMob Integration Readiness

## Estado Actual

Mascotify tiene una base local/demo para placements publicitarios, placeholders, sponsors identificados y rewarded ads. El SDK oficial `google_mobile_ads` ya esta agregado y el App ID Android esta configurado, pero los anuncios reales no quedan activos por defecto.

La integracion es test-safe:

- `ADMOB_ENABLED=false` por defecto.
- `ADMOB_USE_REAL_IDS=false` por defecto.
- Si AdMob esta apagado, la app usa placeholders/demo o no muestra espacio segun el placement.
- Si AdMob se activa con IDs reales apagados, se usan IDs oficiales de prueba de Google.
- Los IDs reales quedan registrados solo para una build futura controlada.

## IDs Registrados

- Android App ID: `ca-app-pub-7918381399703521~3080162315`.
- Banner Android real: `ca-app-pub-7918381399703521/2571375944`.
- Native Android real: `ca-app-pub-7918381399703521/2786998366`.
- Rewarded Android real: `ca-app-pub-7918381399703521/3651007955`.

## Modo Test

Para probar test ads en Android:

```bash
flutter run --dart-define=ADMOB_ENABLED=true --dart-define=ADMOB_USE_REAL_IDS=false
```

Para generar APK debug con test ads:

```bash
flutter build apk --debug --dart-define=ADMOB_ENABLED=true --dart-define=ADMOB_USE_REAL_IDS=false
```

Para una build futura con IDs reales, usar solo despues de cumplir privacidad, consentimiento, Play Store y revision AdMob:

```bash
flutter build apk --release --dart-define=ADMOB_ENABLED=true --dart-define=ADMOB_USE_REAL_IDS=true
```

No usar IDs reales en debug normal, no hacer clicks propios, no pedir clicks y no generar trafico artificial.

## Estado Por Formato

- Banner: preparado con `BannerAd` Android y test ID por defecto.
- Rewarded: preparado para acciones voluntarias; solo otorga recompensa si el anuncio termina.
- Native: ID registrado; Native real queda pendiente de `NativeAdFactory` Android/iOS.
- Interstitial: no implementado y flag apagado.
- iOS: queda pendiente hasta crear app iOS, App ID y configurar `Info.plist`.

## Pasos Futuros Para AdMob Real

1. Crear cuenta AdMob.
2. Agregar datos de pago.
3. Crear app Android.
4. Crear app iOS cuando exista iOS.
5. Crear AdMob App ID.
6. Crear Ad Units para banner, native, rewarded e interstitial solo si alguna vez se habilita.
7. Agregar el plugin Flutter `google_mobile_ads`. ✅
8. Configurar `AndroidManifest.xml` con App ID. ✅
9. Configurar `Info.plist` cuando exista iOS.
10. Inicializar el SDK.
11. Usar test ad units.
12. Agregar UMP/consentimiento.
13. Configurar politica de privacidad.
14. Completar Data Safety en Google Play.
15. Configurar `app-ads.txt` en el dominio del desarrollador.
16. Probar en modo test.
17. Recien despues usar IDs reales.
18. Nunca hacer clicks propios sobre anuncios reales.
19. Nunca publicar con IDs demo.
20. Nunca activar ads reales en pantallas sensibles.

## Interstitials

Los interstitials quedan deshabilitados hasta revision de UX y politicas. No deben aparecer al abrir la app, en acciones sensibles ni durante flujos de salud, QR, mascotas perdidas, mensajes, privacidad o suscripcion.

## Web Publica Y AdSense

AdSense queda pendiente para una web publica revisada. No reemplaza AdMob mobile y no debe mezclarse con la app Flutter mobile sin una arquitectura web especifica.

## Guardrails Tecnicos

- Mantener `AdPlacement` y `AdBlockedSurface` como fuente de verdad de ubicaciones.
- Mantener `PlanEntitlement` como fuente de verdad de Free/Plus/Pro.
- Mantener IDs reales centralizados y protegidos por flags.
- No tocar `.env` ni secretos.
- No mostrar placeholders en pantallas sensibles.
- No activar SDK real sin test ads y consentimiento.
- No inicializar AdMob en web, desktop ni iOS hasta que exista configuracion iOS propia.
