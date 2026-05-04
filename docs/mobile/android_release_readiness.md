# Mascotify - Android release readiness

## Objetivo

Preparar Mascotify para una futura publicacion Android sin publicar todavia, sin generar release firmado, sin crear keystore real y sin commitear secretos.

## Estado Android actual

- Proyecto Android: existe en `android/`.
- Gradle: usa Kotlin DSL (`build.gradle.kts`).
- App module: `android/app/build.gradle.kts`.
- Manifest principal: `android/app/src/main/AndroidManifest.xml`.
- Nombre visible actual: `Mascotify`.
- Package/applicationId actual: `com.mascotify.app`.
- Namespace Android actual: `com.mascotify.app`.
- Version actual desde `pubspec.yaml`: `1.0.0+1`.
- `versionName`: `1.0.0`.
- `versionCode`: `1`.
- `compileSdk`: toma `flutter.compileSdkVersion`.
- `targetSdk`: toma `flutter.targetSdkVersion`.
- `minSdk`: toma `flutter.minSdkVersion`.
- Iconos: existen `ic_launcher.png` en densidades `mdpi`, `hdpi`, `xhdpi`, `xxhdpi` y `xxxhdpi`.
- Signing release: preparado de forma condicional con `android/key.properties`, pero no hay `key.properties` presente.
- Plantilla local: `android/key.properties.example`.
- Secretos: `.gitignore` excluye `key.properties`, `*.jks` y `*.keystore`.

## Permisos actuales

Manifest principal:

- No declara permisos funcionales explicitos.
- Declara la `MainActivity` exportada como launcher.

Manifests debug/profile:

- Declaran `android.permission.INTERNET` para herramientas de desarrollo Flutter, hot reload y debugging.

No hay permisos de camara, geolocalizacion, push notifications ni almacenamiento declarados para produccion en esta etapa.

## Build APK debug

Comando directo:

```bat
C:\src\flutter\bin\flutter.bat build apk --debug
```

Script existente:

```bat
tooling\mobile\build_android_debug.bat
```

Salida esperada:

```text
build\app\outputs\flutter-apk\app-debug.apk
```

El APK debug sirve para pruebas internas. No es una version productiva ni Play Store.

## Diagnostico Android seguro

```bat
tooling\mobile\android_release_check.bat
```

El script ejecuta:

```bat
C:\src\flutter\bin\flutter.bat --version
C:\src\flutter\bin\flutter.bat doctor
C:\src\flutter\bin\flutter.bat build apk --debug
```

No toca Git, no crea keystore, no genera release firmado y no publica nada.

## Debug APK vs release APK vs app bundle

- Debug APK: build de desarrollo, instalable para QA interno.
- Release APK: APK optimizado para distribucion directa, requiere signing correcto antes de distribuirse.
- App bundle (`.aab`): formato recomendado para Play Store; tambien requiere signing/configuracion de release.

Comando futuro para app bundle:

```bat
tooling\mobile\build_android_appbundle_release.bat
```

El script requiere `android/key.properties` local y no crea ni commitea secretos.

## Keystore y secretos

Para una release real se debe crear un keystore fuera del repositorio o en una ubicacion segura local/CI.

No commitear:

- `key.properties`
- archivos `.jks`
- passwords
- aliases privados
- credenciales de Play Console
- certificados o claves de signing

La configuracion actual solo habilita signing release si existen `key.properties`, todas sus claves requeridas y el archivo de keystore referenciado.

Ver tambien:

```text
docs/mobile/android_play_release.md
docs/mobile/play_store_checklist.md
```

## Que falta para Play Store

- Android SDK local funcionando.
- Licencias Android aceptadas.
- Build debug validado en dispositivo real.
- Build release firmado con keystore real seguro.
- App bundle validado.
- Politica de privacidad publica.
- Revision de datos recolectados/declaracion Play Console.
- Auth real definida si corresponde.
- Backend real definido si la version productiva lo requiere.
- Iconos finales.
- Capturas por formato.
- Descripcion corta/larga.
- Testers internos.

## Riesgos comunes

- Cambiar `applicationId` tarde puede complicar updates y releases.
- Perder el keystore impide actualizar una app publicada con esa firma.
- Commitear secretos compromete la publicacion.
- Pedir permisos Android antes de necesitarlos puede complicar revision y confianza.
- Publicar una demo local como producto real puede generar expectativas incorrectas.
- QR/camara/geolocalizacion/push requieren permisos, privacidad y QA real cuando se implementen.

## Pasos recomendados futuros

1. Configurar Android SDK local y validar `flutter doctor`.
2. Probar `tooling\mobile\android_release_check.bat`.
3. Probar en emulador y dispositivo fisico.
4. Definir `applicationId` definitivo antes de Play Store.
5. Preparar iconos finales.
6. Crear keystore real fuera del repositorio.
7. Configurar signing release con secretos seguros.
8. Generar app bundle.
9. Completar checklist Play Store.
10. Recién entonces avanzar a testing interno en Play Console.
