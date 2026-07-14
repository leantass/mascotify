# iOS release signing - Mascotify

Fecha: 2026-06-18

## Estado desde Windows

Windows puede preparar archivos Flutter, docs, metadata y paquetes de apoyo, pero
no puede generar un Archive firmado ni subir un IPA a TestFlight sin Mac/Xcode o
un CI macOS seguro.

## Requisitos

- Apple Developer Program activo.
- App creada en App Store Connect.
- Bundle Identifier definitivo.
- Team correcto configurado en Xcode.
- Certificado Apple Distribution y provisioning profile si se usa firma manual.
- Acceso a Mac con Xcode o CI macOS.

No commitear certificados, `.p12`, `.cer`, `.mobileprovision`, `.ipa`,
`AuthKey_*.p8`, API keys de App Store Connect ni archivos de exportacion con
secretos.

## Bundle Identifier

El proyecto iOS actual usa `com.mascotify.app`.

Bundle identifier recomendado para cerrar antes de App Store Connect:
`com.leantass.mascotify`.

Si se cambia, debe hacerse en Xcode en el target Runner y debe coincidir con el
Bundle ID registrado en Apple Developer y App Store Connect.

## Ruta recomendada en Mac

1. Clonar el repo.
2. Hacer checkout de la rama validada o de `main` ya mergeada.
3. Instalar Flutter estable compatible.
4. Ejecutar `flutter pub get`.
5. Ejecutar `cd ios && pod install` si el proyecto usa CocoaPods en esa Mac.
6. Abrir `ios/Runner.xcworkspace`.
7. Seleccionar el Team correcto.
8. Confirmar Bundle ID, Display Name `Mascotify` y deployment target.
9. Usar automatic signing o profiles manuales seguros.
10. Ejecutar Product > Archive.
11. Validar el archive en Organizer.
12. Upload to App Store Connect.
13. Esperar procesamiento y usar TestFlight para testers internos.

## Firma manual

Si se decide firma manual:

1. Crear Apple Distribution certificate.
2. Crear provisioning profile App Store para el Bundle ID.
3. Instalar certificado/profile en el Mac o CI seguro.
4. Configurar Signing & Capabilities en Xcode.
5. Exportar con opciones locales no commiteadas.

## Firma automatica

Automatic signing es aceptable para el primer flujo manual si el Team esta bien
configurado y no se suben credenciales al repo.
