# Mascotify - Android release checklist

## Proyecto

- [ ] Confirmar `applicationId`: `com.mascotify.app`.
- [ ] Confirmar nombre visible: `Mascotify`.
- [ ] Confirmar version en `pubspec.yaml`.
- [ ] Incrementar `versionCode` antes de cada subida a Play.
- [ ] Revisar iconos launcher finales.
- [ ] Revisar splash/launch theme.

## Build

- [ ] `C:\src\flutter\bin\flutter.bat analyze`.
- [ ] `C:\src\flutter\bin\flutter.bat test`.
- [ ] `C:\src\flutter\bin\flutter.bat build apk --debug`.
- [ ] Probar APK debug en dispositivo real.
- [ ] Crear keystore real fuera del repositorio.
- [ ] Crear `android/key.properties` local completo.
- [ ] `C:\src\flutter\bin\flutter.bat build appbundle --release`.

## Play Store

- [ ] Crear app en Google Play Console.
- [ ] Completar ficha.
- [ ] Completar politica de privacidad.
- [ ] Completar Data Safety.
- [ ] Completar content rating.
- [ ] Completar target audience.
- [ ] Subir capturas.
- [ ] Subir icono y feature graphic.
- [ ] Crear track de internal testing.
- [ ] Subir AAB primero a internal testing.

## Seguridad

- [ ] No commitear `key.properties`.
- [ ] No commitear `.jks` ni `.keystore`.
- [ ] Guardar passwords en gestor seguro.
- [ ] Documentar responsable de la keystore.
- [ ] Revisar permisos Android antes de release.

