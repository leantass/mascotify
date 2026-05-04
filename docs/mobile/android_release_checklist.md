# Mascotify - Checklist Android pre Play Store

## Identidad de app

- [ ] Confirmar nombre visible final: `Mascotify`.
- [ ] Confirmar package/applicationId final: `com.mascotify.app`.
- [ ] Confirmar versionName.
- [ ] Confirmar versionCode.
- [ ] Confirmar iconos finales en todas las densidades.
- [ ] Confirmar splash/launch theme.

## Configuracion Android

- [ ] `flutter doctor` sin errores criticos.
- [ ] Android SDK instalado.
- [ ] Licencias Android aceptadas.
- [ ] `minSdk`, `targetSdk` y `compileSdk` revisados.
- [ ] Permisos Android declarados solo si son necesarios.
- [ ] Sin placeholders peligrosos en manifest/build files.

## Signing y secretos

- [ ] Crear keystore real fuera del repositorio.
- [ ] Guardar passwords en lugar seguro.
- [ ] No commitear `key.properties`.
- [ ] No commitear `.jks`.
- [ ] Validar signing release local/CI con secretos seguros.
- [ ] Documentar responsable y recuperacion del keystore.

## Producto y datos

- [ ] Politica de privacidad publica.
- [ ] Declaracion de manejo de datos para Play Console.
- [ ] Auth real futura definida si la release deja de ser demo.
- [ ] Backend real futuro definido si hay datos remotos.
- [ ] Borrado/exportacion de datos definido si corresponde.
- [ ] Textos honestos sobre modo demo/local o produccion.

## Funcionalidad sensible futura

- [ ] Push notifications: permisos, opt-in y privacidad.
- [ ] QR/camara: permiso de camara y fallback.
- [ ] Geolocalizacion: permisos, precision y proposito.
- [ ] Mensajeria: moderacion, bloqueo/reporte y privacidad.
- [ ] Pagos/planes: politica y proveedor si se implementa.

## QA Android

- [ ] Tests Flutter verdes.
- [ ] Build web verde.
- [ ] APK debug generado.
- [ ] Prueba en emulador Android.
- [ ] Prueba en dispositivo Android fisico.
- [ ] Pruebas en varias resoluciones.
- [ ] Teclado en formularios.
- [ ] Scrolls y botones tactiles.
- [ ] Navegacion atras/sistema.
- [ ] Persistencia local.
- [ ] Performance basica.

## Play Store assets

- [ ] Nombre de ficha.
- [ ] Descripcion corta.
- [ ] Descripcion completa.
- [ ] Capturas de telefono.
- [ ] Capturas de tablet si aplica.
- [ ] Icono de alta resolucion.
- [ ] Feature graphic.
- [ ] Categoria.
- [ ] Contacto de soporte.
- [ ] Testers internos.

## Build release futuro

- [ ] Build release APK firmado.
- [ ] Build app bundle (`.aab`) firmado.
- [ ] Instalar build release en dispositivo de prueba.
- [ ] Validar crash-free smoke test.
- [ ] Subir primero a testing interno, no a produccion directa.
