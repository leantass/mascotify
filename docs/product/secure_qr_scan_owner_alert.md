# QR seguro con alerta al dueño

El QR de Mascotify está pensado para estar físicamente en collar, chapita o accesorio de la mascota. Al escanearlo, la persona que la encontró entra a una página pública segura.

## Página pública segura

- Identifica la mascota por `qrId`.
- Muestra nombre, tipo, raza y estado básico.
- No muestra nombre del dueño, email, teléfono, dirección privada ni ubicación del hogar.
- Explica que Mascotify protege los datos privados de la familia.
- Permite avisar de forma segura dónde se vio la mascota.

## Ubicación con consentimiento

La ubicación real del escáner solo puede obtenerse con permiso del dispositivo o navegador. En web, el flujo intenta usar geolocalización del navegador. Si el usuario rechaza, si el entorno no lo permite o si falla el permiso, se ofrece carga manual:

- País.
- Provincia o región.
- Ciudad o localidad.
- Zona aproximada.
- Comentario opcional.
- Contacto opcional.

## Evento para el dueño

Cada aviso crea un evento local/demo con:

- Mascota y QR.
- Fecha/hora.
- Fuente de ubicación: geolocalización, manual o desconocida.
- Coordenadas y precisión si existen.
- Ubicación manual si fue cargada.
- Comentario y contacto opcional.
- Estado pendiente.
- Marca de seguridad si aparece intención de cobro.

## Alerta interna

En esta fase no hay push real. Mascotify crea una notificación interna/local para el dueño:

- “Alguien escaneó el QR de [mascota].”
- Incluye ubicación reportada.
- Si la mascota está marcada como perdida, se prioriza como “Posible avistaje de mascota perdida”.
- También se agrega al historial QR y al feed de actividad.

## Detalle del evento

El dueño puede abrir el historial QR y ver:

- Mascota.
- Fecha/hora.
- Ubicación reportada.
- Coordenadas y precisión si existen.
- Comentario.
- Contacto opcional.
- Recomendaciones de seguridad.
- Copia de coordenadas o link externo a mapa sin usar API key.

## Seguridad

- No pedir ni pagar dinero por devolver una mascota.
- Verificar señas privadas.
- Encontrarse en un lugar público.
- Ir acompañado si es posible.
- Reportar intentos de cobro.

Los campos de comentario y contacto bloquean intención clara de cobro, rescate, transferencia, alias, CBU, Mercado Pago o depósitos.

## Backend futuro

La fase actual funciona en modo local/demo. Para producción queda pendiente:

- `POST /api/v1/qr-scans`.
- `GET /api/v1/pets/:id/qr-scans`.
- `PATCH /api/v1/qr-scans/:id/status`.
- Rate limiting por IP y `qrId`.
- Moderación y antifraude real.
- Push notifications reales al dueño.
