# Mascotify - Android Play Release

## Objetivo

Preparar un Android App Bundle release (`.aab`) para subir manualmente a Google Play Console, sin publicar automaticamente y sin commitear secretos.

La app actual sigue funcionando como demo/local mientras no exista backend real conectado.

## Estado actual auditado

- App name visible: `Mascotify`.
- Package/applicationId: `com.mascotify.app`.
- Namespace Android: `com.mascotify.app`.
- Version actual: `1.0.0+1`.
- `versionName`: `1.0.0`.
- `versionCode`: `1`.
- `compileSdk`: `flutter.compileSdkVersion`.
- `targetSdk`: `flutter.targetSdkVersion`.
- `minSdk`: `flutter.minSdkVersion`.
- Manifest principal: no declara permisos funcionales explicitos.
- Debug/profile: declaran `android.permission.INTERNET` para tooling Flutter.
- Iconos: existen `ic_launcher.png` por densidad en `android/app/src/main/res/mipmap-*`.
- Signing release: Gradle lee `android/key.properties` solo si existe y esta completo.
- Secretos: `.gitignore` excluye `key.properties`, `*.jks` y `*.keystore`.

## APK debug vs AAB release

- APK debug: sirve para instalar y probar internamente; no es Play Store.
- AAB release: formato esperado por Google Play para publicar o probar por tracks internos.
- Release firmado: requiere keystore real, `key.properties` local y passwords seguros.

## Crear keystore local

No crear ni guardar la keystore dentro de una carpeta publica o sincronizada sin control. Una ubicacion local posible:

```text
C:\Users\<usuario>\.mascotify\release-upload.jks
```

Ejemplo de comando:

```bat
keytool -genkey -v -keystore C:\Users\<usuario>\.mascotify\release-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias mascotify
```

Guardar las claves/passwords en un gestor seguro. Perder la keystore puede impedir actualizar la app publicada.

## Crear android\key.properties

Copiar:

```bat
copy android\key.properties.example android\key.properties
```

Completar localmente:

```properties
storePassword=<password-del-store>
keyPassword=<password-de-la-key>
keyAlias=mascotify
storeFile=C:\\Users\\<usuario>\\.mascotify\\release-upload.jks
```

No commitear:

- `android/key.properties`
- archivos `.jks`
- archivos `.keystore`
- passwords
- credenciales de Play Console

## Generar App Bundle release

Con `android/key.properties` local completo:

```bat
tooling\mobile\build_android_appbundle_release.bat
```

Comando Flutter equivalente:

```bat
C:\src\flutter\bin\flutter.bat build appbundle --release
```

Salida esperada:

```text
build\app\outputs\bundle\release\app-release.aab
```

## Subir a Play Console

1. Crear la app en Google Play Console.
2. Confirmar package id: `com.mascotify.app`.
3. Completar ficha de Play Store.
4. Completar politica de privacidad.
5. Completar Data Safety.
6. Completar target audience.
7. Completar content rating.
8. Subir capturas e iconos requeridos.
9. Crear track de internal testing.
10. Subir `app-release.aab`.
11. Invitar testers internos.
12. Validar instalacion desde Play Internal Testing.
13. Recién despues evaluar produccion.

## Checklist Play Console

- Nombre app.
- Descripcion corta.
- Descripcion larga.
- Icono.
- Capturas de telefono.
- Feature graphic si aplica.
- Politica de privacidad.
- Data Safety.
- Target audience.
- Content rating.
- Contacto de soporte.
- Internal testing.
- Revision final antes de produccion.

## Notas importantes

- No publicar una demo local como producto final sin explicar su alcance.
- Si se habilitan camara, QR real, geolocalizacion o push, revisar permisos y privacidad antes de subir.
- Si se conecta backend/auth real, actualizar Data Safety y politica de privacidad.
- Incrementar `versionCode` para cada nueva subida a Play.
