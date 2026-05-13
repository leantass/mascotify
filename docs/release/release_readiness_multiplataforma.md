# Mascotify - Release readiness multiplataforma

## Estado general

Mascotify ya tiene una base avanzada para demo y validacion local:

- Flutter web/mobile/desktop con proyecto Android, iOS, Web y Windows presente.
- Backend inicial para clips sociales y upload Cloudinary preparado.
- Fallback local/demo en Flutter para que Explorar no dependa solo del backend.
- CI existente para `flutter analyze`, `flutter test` y `flutter build web`.
- Suite automatizada amplia.
- Build web validado.
- APK debug ya usado para QA en Android real.

Esta auditoria no publica la app, no sube archivos a tiendas, no crea keystores y no incluye secretos.

## Android

Estado observado:

- Proyecto Android: `android/`.
- Gradle: Kotlin DSL en `android/app/build.gradle.kts`.
- `applicationId`: `com.mascotify.app`.
- `namespace`: `com.mascotify.app`.
- Nombre visible: `Mascotify`.
- Version Flutter: `1.0.0+1` desde `pubspec.yaml`.
- `versionName`: `1.0.0`.
- `versionCode`: `1`.
- `compileSdk`, `targetSdk` y `minSdk`: toman los valores de Flutter.
- Manifest principal: no declara permisos funcionales explicitos.
- Debug/profile: declaran `INTERNET` para tooling Flutter.
- Iconos launcher: existen en densidades `mipmap-*`.
- Signing release: preparado de forma condicional si existe `android/key.properties` completo y la keystore referenciada existe.

Readiness:

- APK debug: listo para validacion local.
- App Bundle release: pendiente de `android/key.properties` real y keystore segura fuera de Git.
- Google Play: pendiente de ficha, politicas, data safety, capturas, testing interno y versionado de release.

Notas de seguridad:

- No commitear `key.properties`, `.jks`, `.keystore`, passwords ni credenciales Play Console.
- Hay un `key.properties` local en la raiz del repo, ignorado por Git; no se debe publicar ni copiar a documentacion.
- El Gradle Android espera `android/key.properties` para release signing, no secretos en Flutter.
- En esta auditoria no se genero AAB release porque `android/key.properties` no existe.

## iOS

Estado observado:

- Proyecto iOS presente en `ios/`.
- `CFBundleDisplayName`: `Mascotify`.
- `PRODUCT_BUNDLE_IDENTIFIER`: `com.mascotify.app`.
- Deployment target iOS: `13.0`.
- Version iOS: toma `FLUTTER_BUILD_NAME` y `FLUTTER_BUILD_NUMBER`.
- Icon set y launch screen existen.

Readiness:

- La configuracion base existe.
- No se puede compilar, firmar ni publicar iOS desde Windows.
- Requiere Mac con Xcode, CocoaPods/Flutter iOS toolchain, Apple Developer Program, certificados, provisioning profiles y App Store Connect.
- Antes de produccion se recomienda TestFlight.

## Web

Estado observado:

- Proyecto web presente en `web/`.
- `web/manifest.json` define `Mascotify`, iconos, tema y display standalone.
- `web/index.html` tiene metadata, favicon, manifest y loading visual con logo.
- Scripts demo existentes:
  - `tooling/demo/build_web_demo.bat`
  - `tooling/demo/package_web_demo.bat`
  - `tooling/demo/serve_web_demo.bat`
- Documentacion demo existente en `docs/demo/demo_web_local.md`.

Readiness:

- `flutter build web` es el build principal validable desde Windows.
- El zip demo local puede generarse con el tooling existente.
- Deploy productivo pendiente de elegir hosting y configurar dominio/HTTPS.

Opciones futuras de deploy:

- Vercel.
- Netlify.
- Firebase Hosting.
- Cloudflare Pages.
- Hosting propio con servidor estatico.

## Windows desktop

Estado observado:

- Proyecto Windows presente en `windows/`.
- `flutter config --list` no muestra deshabilitacion de Windows desktop.
- `windows/CMakeLists.txt` define `BINARY_NAME` como `mascotify`.
- Ejecutable esperado: `mascotify.exe`.
- Icono Windows existe en `windows/runner/resources/app_icon.ico`.
- Metadata de `windows/runner/Runner.rc` todavia conserva valores genericos como `CompanyName = com.example` y `ProductName = mascotify`.

Readiness:

- Build Windows puede validarse desde esta maquina si Visual Studio con C++ Desktop y Windows SDK estan instalados.
- Para distribucion real falta definir metadata final, firma de codigo, instalador/paquete y canal de distribucion.
- Se agrego script seguro:
  - `tooling/desktop/build_windows_release.bat`
- Validacion local actual: `flutter build windows` falla porque Visual Studio no esta instalado. `flutter doctor` reporta que se requiere la workload "Desktop development with C++".

## Validacion local de esta auditoria

Ejecutado desde Windows el 2026-05-13:

- `tooling\git_flow\check_local.bat`: OK.
- `C:\src\flutter\bin\flutter.bat build apk --debug`: OK.
- `C:\src\flutter\bin\flutter.bat build web`: OK en reintento. El primer intento fallo por un error transitorio del runtime Dart al crear `DartWorker`.
- `C:\src\flutter\bin\flutter.bat build windows`: pendiente por entorno. Error: `Unable to find suitable Visual Studio toolchain`.
- iOS build: no ejecutado porque Windows no puede compilar/publicar iOS.

## Checklist antes de publicar

- [ ] Definir si la primera publicacion sera demo, beta cerrada o producto publico.
- [ ] Confirmar nombre final, marca, iconos, screenshots y textos comerciales.
- [ ] Confirmar versionado por plataforma.
- [ ] Revisar politicas de privacidad, soporte y manejo de datos.
- [ ] Revisar permisos por plataforma.
- [ ] Conectar backend/auth reales si la version deja de ser demo local.
- [ ] Probar smoke test manual en cada plataforma.
- [ ] Validar performance y navegacion en pantallas chicas.
- [ ] Revisar accesibilidad basica y contraste.
- [ ] Evitar publicar secretos o credenciales.
- [ ] Preparar plan de rollback/update.

## Que puede hacerse desde Windows

- `flutter analyze`.
- `flutter test`.
- `flutter build web`.
- `flutter build apk --debug`.
- `flutter build appbundle --release` si existe keystore Android local segura.
- `flutter build windows` si Visual Studio/C++ toolchain esta instalado.
- Empaquetar demo web zip.
- Auditar configuracion y documentacion.

## Que requiere Mac

- Compilar iOS.
- Firmar iOS.
- Probar en simulador iOS y dispositivos iPhone/iPad desde Xcode.
- Crear archivo para App Store/TestFlight.
- Gestionar certificados/provisioning de Apple.
- Subir a App Store Connect con tooling Apple.

## Que requiere cuentas externas

- Google Play Console para Android.
- Apple Developer Program y App Store Connect para iOS.
- Hosting o proveedor cloud para Web.
- Certificado de firma de codigo para Windows si se distribuye instalador firmado.
- Cloudinary configurado con credenciales reales si se habilita upload de video real.
- Backend productivo si se conectan clips sociales reales.

## Riesgos

- Publicar una demo local como producto final sin aclarar alcance.
- Perder la keystore Android.
- Commitear secretos.
- Cambiar `applicationId` o bundle id tarde.
- Declarar permisos antes de necesitarlos.
- Publicar sin moderacion suficiente si hay contenido social real.
- Publicar Windows sin firma puede generar advertencias SmartScreen.
- Publicar iOS sin pasar por TestFlight aumenta riesgo de rechazo.

## Proximo orden recomendado

1. Mantener `main` verde con `check_local`.
2. Validar Android debug en dispositivo real.
3. Completar Android signing local y generar AAB para testing interno.
4. Completar metadata final Web y elegir hosting.
5. Validar Windows build y ajustar metadata/firma/instalador.
6. Preparar Mac/Xcode para iOS y pasar por TestFlight.
7. Solo despues avanzar a releases publicas por tienda/canal.
