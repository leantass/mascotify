# AdMob Integration Readiness

## Estado Actual

Mascotify tiene una base local/demo para placements publicitarios, placeholders, sponsors identificados y rewarded ads simulados. No hay SDK real, IDs reales, requests externos ni trafico publicitario.

## Pasos Futuros Para AdMob Real

1. Crear cuenta AdMob.
2. Agregar datos de pago.
3. Crear app Android.
4. Crear app iOS cuando exista iOS.
5. Crear AdMob App ID.
6. Crear Ad Units para banner, native, rewarded e interstitial solo si alguna vez se habilita.
7. Agregar el plugin Flutter `google_mobile_ads`.
8. Configurar `AndroidManifest.xml` con App ID.
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
- No guardar IDs reales en el repo.
- No tocar `.env` ni secretos.
- No mostrar placeholders en pantallas sensibles.
- No activar SDK real sin test ads y consentimiento.
