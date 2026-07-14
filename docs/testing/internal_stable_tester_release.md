# Mascotify internal stable tester release

Fecha/hora: 2026-05-19 13:53:25 -03:00

Rama de nota: `release/internal-stable-tester-build`

Commit probado: `2e8380cd04e4f9a5275aa07f7c5229f7d21a48e0`

## Objetivo

Preparar una version interna estable para testers de Mascotify en Android y web/desktop local, sin publicar en tiendas, sin deploy publico, sin pagos reales y sin Ads reales.

## Funcionalidades principales para probar

- Login demo familiar y profesional.
- Alta, edicion, detalle e historial de mascotas.
- QR persistente por mascota y pantalla publica segura.
- Catalogo solidario de mascotas perdidas dentro de Mascotas.
- Notificaciones internas y feed de actividad.
- Mensajes locales/demo.
- Clips y exploracion demo/local.
- Preferencias de perfil y configuracion.
- Responsive mobile en flujos principales.

## Artefactos generados

- APK Android debug: carpeta local de salida `mascotify_functional_builds\android\`.
- Paquete web localhost: carpeta local de salida `mascotify_functional_builds\web\`.
- Instrucciones externas para testers: carpeta local de salida `mascotify_functional_builds\`.

Copias historicas:

- Android: archivo historico local fuera del repo.
- Web: archivo historico local fuera del repo.

## Validaciones locales

Resultado local: OK.

- `tooling\git_flow\check_local.bat`: OK.
- `flutter analyze`: OK.
- `flutter test`: OK, 199 tests passed.
- `flutter build web`: OK.
- `tooling\mobile\build_android_debug.bat`: OK.
- `tooling\demo\package_web_functional_review.bat`: OK.
- ZIP web validado con `INICIAR_MASCOTIFY.bat`, `mascotify-local-server.ps1`, instrucciones, `index.html`, `flutter_bootstrap.js`, `flutter.js`, `main.dart.js`, `assets`, `canvaskit` e `icons`.
- ZIP extraido en ruta temporal con espacios y probado en localhost: `http://127.0.0.1:53177/`, `flutter_bootstrap.js` y `main.dart.js` respondieron HTTP 200.

## Validacion backend local

Resultado backend local: OK.

- `npm.cmd ci`: OK.
- `npx.cmd prisma validate`: OK usando `DATABASE_URL` temporal tipo CI, sin modificar `.env`.
- `npx.cmd prisma generate`: OK.
- `npm.cmd run build`: OK.
- `npm.cmd test`: OK, 33 tests passed.

Nota: PowerShell bloqueo `npm.ps1` por politica local de ejecucion. Se uso `npm.cmd`, sin cambiar la configuracion del sistema.

## GitHub Actions

Workflow disponible: `Mascotify CI` en `.github/workflows/flutter-ci.yml`.

`gh` no esta instalado en este entorno, por lo que no se pudo disparar manualmente una corrida con GitHub CLI.

Se consulto la API publica de GitHub:

- Ultima corrida de `main`: `https://github.com/leantass/mascotify/actions/runs/26109205982`
- Commit: `2e8380cd04e4f9a5275aa07f7c5229f7d21a48e0`
- Estado: completed.
- Conclusion: failure.
- Backend job: success.
- Flutter job: failure.
- Paso fallido: `Analyze Flutter project`.
- Los logs detallados no estan disponibles sin iniciar sesion; la pagina publica muestra `Process completed with exit code 1`.
- Advertencia adicional de GitHub: acciones basadas en Node.js 20 deprecadas para fechas futuras.

La validacion local equivalente de Flutter paso en Windows con Flutter 3.41.7, pero GitHub Actions fallo en `flutter analyze` sobre runner Ubuntu. No se oculta este resultado: el release interno queda apto para testing local por validaciones locales, pero CI remoto necesita revision de la falla de analyzer en GitHub.

## Que deben probar testers

- Instalar APK Android y recorrer login demo familiar.
- Crear y editar mascotas normales.
- Abrir detalle de mascota y revisar QR.
- Probar Mascotas perdidas como catalogo solidario.
- Crear aviso de mascota perdida valido.
- Validar que no haya precios, compra, rescates ni recompensas obligatorias.
- Revisar notificaciones internas y feed.
- Probar ZIP web con `INICIAR_MASCOTIFY.bat`.
- Reportar cualquier overflow, pantalla en blanco, bloqueo o texto confuso.

## Limitaciones conocidas

- No es produccion.
- No esta publicado en Play Store.
- No hay deploy web publico.
- No hay deploy Railway publico en esta fase.
- No hay pagos reales.
- No hay Ads reales.
- Varias funciones siguen en modo demo/local.
- El QR fisico entre dispositivos requiere `QR_PUBLIC_BASE_URL` con URL publica y backend publico accesible.
- `localhost` y `127.0.0.1` solo sirven en la misma computadora.
- Push real con app cerrada queda pendiente para una fase futura con FCM/APNs.
- GitHub Actions remoto fallo en Flutter analyze y debe revisarse antes de considerar CI verde.

## Checklist de feedback

- Dispositivo o computadora usada.
- Sistema operativo y version.
- Navegador, si aplica.
- Flujo probado.
- Resultado esperado.
- Resultado obtenido.
- Captura, video o mensaje de error.
- Si fue Android, modelo de telefono y version de Android.
- Si fue web, confirmar si se uso `INICIAR_MASCOTIFY.bat` y si la ventana negra quedo abierta.
