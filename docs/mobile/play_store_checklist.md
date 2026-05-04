# Mascotify - Checklist Play Store

## Cuenta y app

- [ ] Cuenta Google Play Console activa.
- [ ] App creada en Play Console.
- [ ] Package/applicationId confirmado: `com.mascotify.app`.
- [ ] Nombre visible confirmado: `Mascotify`.
- [ ] VersionName revisado.
- [ ] VersionCode incrementado para la subida.
- [ ] Target SDK API 35 o superior confirmado para Google Play.
- [ ] Compile SDK compatible con el SDK Android instalado localmente o en CI.

## Signing

- [ ] Keystore real creado fuera del repo.
- [ ] Passwords guardados en gestor seguro.
- [ ] `android/key.properties` creado solo localmente.
- [ ] `.jks` o `.keystore` fuera de git.
- [ ] `tooling\mobile\build_android_appbundle_release.bat` genera `.aab`.
- [ ] Se conserva backup seguro de keystore.
- [ ] El `.aab` no se genera con una keystore temporal o de prueba.

## Store listing

- [ ] Descripcion corta.
- [ ] Descripcion larga.
- [ ] Icono de alta resolucion.
- [ ] Capturas de telefono.
- [ ] Feature graphic si aplica.
- [ ] Categoria.
- [ ] Email/contacto de soporte.
- [ ] URL de politica de privacidad.

## Politicas y datos

- [ ] Politica de privacidad publicada.
- [ ] Data Safety completado.
- [ ] Content rating completado.
- [ ] Target audience completado.
- [ ] Declarar si la app funciona en modo local/demo.
- [ ] Revisar datos locales, auth futura y backend futuro.
- [ ] Revisar permisos futuros de camara/QR.
- [ ] Revisar permisos futuros de geolocalizacion.
- [ ] Revisar push notifications futuras.

## QA antes de subir

- [ ] `tooling\git_flow\check_local.bat` verde.
- [ ] APK debug probado.
- [ ] AAB release generado.
- [ ] Prueba en dispositivo fisico.
- [ ] Prueba en emulador.
- [ ] Login demo familia.
- [ ] Login demo profesional.
- [ ] Onboarding.
- [ ] Mascotas CRUD.
- [ ] QR/trazabilidad.
- [ ] Feed con busqueda/filtros.
- [ ] Mensajes.
- [ ] Notificaciones.
- [ ] Preferencias.
- [ ] Logout.

## Tracks Play

- [ ] Subir primero a internal testing.
- [ ] Agregar testers internos.
- [ ] Validar instalacion desde Play.
- [ ] Revisar crashes/pre-launch report.
- [ ] Corregir bloqueos antes de produccion.
- [ ] Enviar a produccion solo con aprobacion final.
