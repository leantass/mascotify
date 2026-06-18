# iOS CI options - Mascotify

Fecha: 2026-06-18

## Opcion 1: Mac local

Camino recomendado para el primer TestFlight. Permite revisar Xcode, signing,
capabilities, archive, privacy report y upload manual.

## Opcion 2: GitHub Actions macOS

El repo incluye un workflow manual `ios-build-check.yml` para validar iOS en
`macos-latest` sin secretos y sin subir a TestFlight.

Para subir a TestFlight desde CI se requeririan secretos en GitHub Actions:

- App Store Connect API key.
- Issuer ID.
- Key ID.
- Certificado/provisioning o estrategia segura de firma.

No guardar esos valores en el repo.

## Opcion 3: Codemagic o Bitrise

Servicios moviles con soporte iOS y manejo de signing. Requieren configurar
certificados, provisioning profiles y App Store Connect de forma segura.

## Opcion 4: Fastlane Match

Puede centralizar certificados/profiles en un repo privado cifrado. Usarlo solo
con una politica clara de acceso, rotacion y almacenamiento de secretos.
