# Security hardening report - Mascotify

Fecha: 2026-06-18

## Alcance

Auditoria defensiva local sobre el repositorio Mascotify. No se atacaron
servicios externos, dominios publicos ni APIs productivas.

## Secretos y hardcodes sensibles

- No se detectaron `.env`, keystores, certificados Apple, APK, AAB, IPA ni
  secretos reales trackeados.
- `android/key.properties` y `android/app/upload-keystore.jks` estan ignorados.
- Se detectaron placeholders y ejemplos en documentacion, mantenidos como
  ejemplos no sensibles.
- Se detectaron passwords dummy en tests y cuentas demo; se mantienen porque no
  son credenciales reales y estan en contexto de demo/testing.

## Cambios aplicados

- Se removieron ZIPs historicos de entrega del repo y se reforzo `.gitignore`
  con `*.zip` y `/dist/`.
- Se reemplazo el hash FNV casero del auth local por un hasher dedicado
  PBKDF2-HMAC-SHA256 versionado usando `crypto`.
- El login local conserva compatibilidad con hashes legacy y los migra al nuevo
  formato despues de una autenticacion correcta.
- El backend Express agrega headers defensivos:
  - `X-Content-Type-Options: nosniff`
  - `Referrer-Policy: no-referrer`
  - `X-Frame-Options: DENY`
  - `Permissions-Policy`
  - `Content-Security-Policy`
- El backend limita JSON requests a `256kb`.
- `npm audit fix` y actualizacion segura de `tsx` resolvieron vulnerabilidades
  npm conocidas sin usar `--force`.
- Documentacion con rutas absolutas de otro usuario fue reemplazada por rutas
  genericas de outputs locales.

## Dependencias

- Flutter/Dart: `flutter pub outdated` revisado. No se aplico upgrade masivo.
- Se agrego `crypto` para hashing local.
- Backend Node: `npm audit` paso a 0 vulnerabilidades despues de actualizar
  dependencias no breaking.

## Storage local

La app sigue usando `SharedPreferences` para demo/local. Esto es aceptable para
preferencias y datos demo, pero no debe considerarse almacenamiento seguro para
credenciales reales. Antes de produccion con auth real se debe usar proveedor de
identidad/backend y almacenamiento seguro de tokens segun plataforma.

## Permisos

- Android release no declara permisos de camara, ubicacion, microfono ni storage
  productivos.
- iOS no agrega usage descriptions innecesarias.
- Privacy manifest iOS se mantiene para UserDefaults sin tracking.

## QR, matching y profesionales beta

- QR publico mantiene foco en no exponer telefono, email ni direccion exacta.
- Matching usa zona general y no expone contacto directo productivo.
- Profesionales permanece como beta/proximamente, sin pagos ni agenda real.

## Pendientes

- Reemplazar auth local demo por auth real/backoffice antes de produccion.
- Definir hosting web con headers HTTP reales: CSP, X-Content-Type-Options,
  Referrer-Policy, Permissions-Policy y frame-ancestors.
- Completar datos legales reales, privacy policy URL y App Store/Play privacy.
- Revisar manualmente archivos grandes para modularizacion gradual por feature.
