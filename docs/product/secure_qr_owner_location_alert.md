# QR fisico con alerta de ubicacion al dueno

## Objetivo

El QR de Mascotify puede pegarse fisicamente en collar o chapita. Cuando alguien lo escanea desde otro telefono, abre una pagina publica segura para avisar donde vio o encontro la mascota sin exponer datos privados de la familia.

## URL publica del QR

El QR debe codificar una URL publica configurable:

`https://DOMINIO_PUBLICO/q/:qrId`

En Flutter la base se configura con `MASCOTIFY_PUBLIC_QR_BASE_URL`. Si no esta configurada, la app conserva fallback local/demo con `/pet/qr/:qrId`.

Importante: `localhost` no sirve para una chapita escaneada desde otro telefono. Para pruebas reales entre dispositivos, el QR debe apuntar a un dominio publico o a una URL accesible desde la misma red.

## Pagina publica segura

La pantalla publica muestra solo informacion minima:

- nombre publico de la mascota;
- tipo de animal;
- raza/tipo si corresponde;
- color o senas publicas;
- estado normal/perdida/encontrada.

No muestra telefono, email, direccion, ubicacion privada del hogar ni dato privado de verificacion.

## Ubicacion con consentimiento

La ubicacion exacta del escaner solo puede obtenerse si la persona acepta el permiso del dispositivo o navegador. Si acepta, el evento guarda latitud, longitud, precision, timestamp y `locationSource = DEVICE_GEOLOCATION`.

Si no acepta o no esta disponible, la pagina permite carga manual de pais, provincia/region, ciudad/localidad, zona aproximada, comentario y contacto opcional. En ese caso se guarda `locationSource = MANUAL`.

## Backend

La fase agrega endpoints backend-ready:

- `POST /api/v1/qr/pets`: registra o actualiza datos publicos minimos de la mascota/QR con `x-user-id`.
- `GET /api/v1/qr/public/:qrId`: devuelve solo datos publicos seguros.
- `POST /api/v1/qr/public/:qrId/scans`: crea evento de escaneo sin auth.
- `GET /api/v1/qr/owner/scans`: lista eventos del dueno con `x-user-id`.
- `PATCH /api/v1/qr/owner/scans/:id/read`: marca evento como leido.

Los modelos Prisma son `QrRegisteredPet` y `QrScanEvent`. No guardan secretos ni datos privados del dueno en la respuesta publica.

## Alerta interna actual

En Flutter local/demo, el evento de escaneo crea notificacion interna, historial de mascota y entrada de actividad. Con backend publico, la app del dueno puede consultar `GET /api/v1/qr/owner/scans?unread=true` para mostrar alerta interna.

Push real con app cerrada requiere Firebase Cloud Messaging/APNs y queda pendiente para una fase productiva.

## Google Maps sin API key

El detalle del evento muestra `Abrir en Google Maps` cuando hay coordenadas. Usa URL simple sin API key:

`https://www.google.com/maps/search/?api=1&query=LAT,LNG`

No se usa Google Maps SDK ni mapa embebido.

## Seguridad y anti-cobro

Mascotify bloquea mensajes con intencion clara de cobro, rescate, transferencia, alias, CBU, Mercado Pago o deposito. La pagina publica recuerda: no pidas ni pagues dinero por devolver una mascota.

## Rate limiting

El modo local/demo evita eventos identicos repetidos en pocos segundos. El backend implementa deduplicacion basica por `qrId` y fingerprint del reporte. En produccion debe sumarse rate limiting por IP/qrId y moderacion.

## Pendientes productivos

- Deploy publico del backend/web con dominio real.
- Sincronizacion automatica de mascotas locales hacia `POST /api/v1/qr/pets`.
- Polling periodico o canal realtime para alertas internas.
- Push notifications reales con FCM/APNs.
- Moderacion, auditoria y rate limiting productivo por IP/qrId.
