# Diagnostico y testing de QR publico

## Por que no funciono desde otro telefono

El QR que se veia en la ficha de mascota no era un QR real escaneable. Era una representacion visual demo y mostraba el identificador `qrId` (`MSC-...`). Un telefono externo no puede abrir `MSC-...` porque no es una URL.

Ademas, aunque la app ya tenia una URL visible debajo, si no se configura una base publica, el fallback es una ruta local como `/pet/qr/:qrId`. Esa ruta solo funciona dentro de la app/web actual; no sirve como QR fisico para un telefono cualquiera.

## Localhost y 127.0.0.1 no sirven

`localhost` y `127.0.0.1` siempre apuntan al propio dispositivo que los abre. Si un telefono escanea `http://127.0.0.1:53177/q/MSC-...`, el telefono intenta conectarse a si mismo, no a la PC del desarrollador.

Para que un QR fisico funcione desde otro telefono necesita:

- una URL publica real, por ejemplo `https://mascotify.app/q/MSC-...`; o
- una URL LAN accesible desde la misma Wi-Fi, por ejemplo `http://192.168.1.20:53177/q/MSC-...`.

## Configuracion

Flutter acepta estas variables por `--dart-define`:

- `QR_PUBLIC_BASE_URL=https://dominio-publico`
- `MASCOTIFY_PUBLIC_QR_BASE_URL=https://dominio-publico`
- `MASCOTIFY_QR_API_BASE_URL=https://backend-publico/api/v1`

`QR_PUBLIC_BASE_URL` y `MASCOTIFY_PUBLIC_QR_BASE_URL` definen que codifica el QR:

`BASE/q/:qrId`

Si no se configuran, Mascotify muestra estado `QR local/demo` y avisa que no sirve desde otro telefono.

## Estados visibles

- `QR publico listo`: tiene dominio publico configurable.
- `QR testing LAN`: usa IP privada tipo `192.168.x.x`; sirve solo en la misma Wi-Fi.
- `QR local/demo`: no tiene base publica o apunta a `localhost/127.0.0.1`; no sirve para una chapita real.

## Como probar con dominio publico

1. Desplegar la web publica.
2. Desplegar backend publico si se quiere alerta entre dispositivos.
3. Compilar Flutter Web con:

```powershell
C:\src\flutter\bin\flutter.bat build web --release `
  --dart-define=QR_PUBLIC_BASE_URL=https://TU_WEB_PUBLICA `
  --dart-define=MASCOTIFY_QR_API_BASE_URL=https://TU_BACKEND_PUBLICO/api/v1
```

4. Registrar/sincronizar el QR de la mascota en backend.
5. Escanear desde otro telefono.

## Como probar por LAN

Se agrego tooling opcional:

```powershell
tooling\demo\package_web_lan_qr_review.bat
```

Ese paquete:

- detecta la IP LAN de la PC;
- compila con `QR_PUBLIC_BASE_URL=http://IP_DE_LA_PC:53177`;
- crea un launcher que escucha en `0.0.0.0:53177`;
- permite abrir la web desde otro telefono en la misma Wi-Fi.

Limitaciones LAN:

- Windows Firewall puede pedir permiso;
- solo funciona en la misma red;
- si cambia la IP de la PC hay que regenerar el paquete;
- la alerta entre dispositivos sigue necesitando backend accesible desde el telefono.

## Alerta interna, polling y push

La alerta interna aparece cuando la app del dueno puede leer eventos QR. En modo local/demo se registra dentro del mismo dispositivo/cuenta.

Entre dispositivos reales hace falta backend publico:

- el telefono escaner envia `POST /api/v1/qr/public/:qrId/scans`;
- la app del dueno consulta `GET /api/v1/qr/owner/scans?unread=true`;
- push con app cerrada requiere FCM/APNs y no esta prometido en esta fase.

## Google Maps sin API key

Cuando el evento trae coordenadas, el detalle usa:

`https://www.google.com/maps/search/?api=1&query=LAT,LNG`

No se usa Google Maps API Key.

## Privacidad

La pagina publica no muestra:

- telefono privado del dueno;
- email privado;
- direccion;
- ubicacion del hogar;
- dato privado de verificacion.

Solo muestra informacion publica minima de la mascota y el formulario seguro para avisar ubicacion.
