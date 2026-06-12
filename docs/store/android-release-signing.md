# Android release signing - Mascotify

La firma release permite generar un AAB valido para Google Play. Los secretos
no deben commitearse ni compartirse por chat.

## Archivos esperados

- `android/key.properties`: configuracion local con passwords. No commitear.
- `android/app/upload-keystore.jks`: keystore local. No commitear.
- `android/key.properties.template`: plantilla sin secretos.

## Crear upload key

Ejemplo local con `keytool`:

```bat
keytool -genkey -v -keystore android\app\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Guardar las passwords en un gestor seguro. Hacer backup privado del keystore:
si se pierde la upload key, el proceso de recuperacion con Google Play puede
demorar y bloquear releases.

## Configurar `android/key.properties`

Crear el archivo local:

```properties
storePassword=REPLACE_WITH_SECRET
keyPassword=REPLACE_WITH_SECRET
keyAlias=upload
storeFile=app/upload-keystore.jks
```

No commitear ese archivo.

## Verificar firma

Ejecutar:

```bat
tooling\android\check_release_signing.bat
```

El script no imprime passwords. Solo confirma si existen las claves y keystore.

## Generar AAB

Con firma configurada:

```bat
C:\src\flutter\bin\flutter.bat build appbundle --release
```

El AAB esperado queda en:

`build\app\outputs\bundle\release\app-release.aab`
