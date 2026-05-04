# Mascotify - Prueba en Android real o emulador

## Objetivo

Validar Mascotify en un dispositivo Android real o emulador usando `flutter run`, con foco en interaccion tactil, teclado, scroll, performance basica y layout real de celular.

## APK debug vs flutter run

- APK debug: genera un archivo instalable (`app-debug.apk`) para copiar o instalar manualmente.
- `flutter run`: compila, instala y ejecuta la app directamente en un dispositivo/emulador detectado por Flutter.

Para QA rapido con logs de desarrollo, preferir `flutter run`. Para compartir una build interna, usar APK debug.

## Ver dispositivos disponibles

Desde la raiz del proyecto:

```bat
tooling\mobile\android_devices.bat
```

Comando Flutter equivalente:

```bat
C:\src\flutter\bin\flutter.bat devices
```

El script solo lista dispositivos. No modifica archivos, no instala la app y no toca Git.

## Correr la app en Android

Con un celular o emulador Android disponible:

```bat
tooling\mobile\run_android_debug.bat
```

El script ejecuta primero `flutter devices` y despues:

```bat
C:\src\flutter\bin\flutter.bat run -d android
```

No genera release firmado, no toca keystore y no publica nada.

## Conectar celular Android fisico

1. Abrir Configuracion en Android.
2. Ir a Informacion del telefono.
3. Tocar varias veces "Numero de compilacion" hasta activar opciones de desarrollador.
4. Volver a Configuracion.
5. Entrar en Opciones de desarrollador.
6. Activar "Depuracion USB".
7. Conectar el celular por USB.
8. Aceptar la autorizacion de depuracion en el telefono.
9. Ejecutar:

```bat
tooling\mobile\android_devices.bat
```

Si el dispositivo aparece, correr:

```bat
tooling\mobile\run_android_debug.bat
```

## Probar en emulador Android

1. Abrir Android Studio.
2. Abrir Device Manager.
3. Crear o iniciar un emulador Android.
4. Esperar a que Android termine de iniciar.
5. Ejecutar:

```bat
tooling\mobile\android_devices.bat
```

6. Si el emulador aparece, ejecutar:

```bat
tooling\mobile\run_android_debug.bat
```

## Si Flutter no detecta el dispositivo

- Confirmar que el cable USB permite datos, no solo carga.
- Aceptar el dialogo de depuracion USB en el celular.
- Probar otro puerto USB.
- Reiniciar `adb` si Android SDK esta instalado.
- Abrir el emulador antes de ejecutar el script.
- Revisar que Android SDK este instalado y que `ANDROID_HOME` este configurado.
- Ejecutar `C:\src\flutter\bin\flutter.bat doctor` para diagnostico local.

No conviene tocar Gradle, signing, keystore o configuraciones Android del proyecto sin un error concreto que lo justifique.

## Checklist de flujos en celular real

- [ ] Login demo familia.
- [ ] Login demo profesional.
- [ ] Alternar iniciar sesion / crear cuenta.
- [ ] Onboarding familia/profesional.
- [ ] Home/dashboard.
- [ ] Navegacion principal.
- [ ] Mascotas: listado y estado vacio.
- [ ] Crear mascota.
- [ ] Editar mascota.
- [ ] Eliminar mascota.
- [ ] Detalle de mascota.
- [ ] QR/trazabilidad.
- [ ] Historial por mascota.
- [ ] Feed con filtros y busqueda.
- [ ] Mensajes: inbox, conversacion y envio.
- [ ] Notificaciones: listado, marcar leida y navegar.
- [ ] Preferencias/perfil.
- [ ] Logout.

## Checklist visual y tactil

- [ ] Teclado no tapa campos importantes.
- [ ] Scrolls se sienten naturales.
- [ ] Botones tactiles son comodos.
- [ ] No hay textos cortados.
- [ ] No hay overflows visibles.
- [ ] La navegacion inferior no queda apretada.
- [ ] Formularios largos siguen siendo usables.
- [ ] No hay pantallas blancas.
- [ ] Volver atras funciona en pantallas profundas.
- [ ] Performance basica aceptable al navegar y escribir.

## Limites de esta fase

- No Play Store.
- No release firmado.
- No keystore.
- No Firebase ni Google Auth real.
- No backend.
- No cambios funcionales.
