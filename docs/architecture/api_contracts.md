# Mascotify API Contracts

## Introduccion

Este documento define contratos sugeridos para una futura API/backend real de Mascotify. No describe funcionalidad activa: la app actual sigue funcionando como demo/local, con persistencia local y sin llamadas HTTP reales.

El objetivo es que un equipo backend pueda empezar con un mapa claro de recursos, requests, responses, errores y orden de implementacion sin obligar todavia una tecnologia concreta. REST y GraphQL siguen siendo decisiones abiertas; los ejemplos usan REST JSON porque es facil de leer y versionar.

## Convenciones Generales

- Base path sugerido: `/api/v1`.
- Formato: JSON UTF-8.
- IDs: strings estables, idealmente UUID o ULID.
- Timestamps: ISO 8601 UTC, por ejemplo `2026-04-29T18:40:00Z`.
- Auth futura: `Authorization: Bearer <accessToken>`.
- Separacion por cuenta: todo recurso privado debe resolverse desde el usuario autenticado y su cuenta activa.
- Roles: una cuenta puede operar como `family`, `professional` o ambos.
- Paginacion futura: cursor-based para listas grandes.
- Busqueda: parametros query simples al inicio; motor especializado queda como decision futura.
- Idempotencia: mutaciones sensibles pueden aceptar `Idempotency-Key`.

### Paginacion Sugerida

```json
{
  "items": [],
  "pageInfo": {
    "nextCursor": "cursor_123",
    "hasNextPage": true
  }
}
```

### Modelo De Error Estandar

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Datos invalidos",
    "details": [
      {
        "field": "email",
        "message": "Email requerido"
      }
    ]
  }
}
```

Codigos iniciales sugeridos:

- `VALIDATION_ERROR`
- `UNAUTHENTICATED`
- `FORBIDDEN`
- `NOT_FOUND`
- `CONFLICT`
- `RATE_LIMITED`
- `INTERNAL_ERROR`

## Modelos Base Sugeridos

### User

```json
{
  "id": "usr_01",
  "email": "familia@mascotify.app",
  "ownerName": "Familia Gomez",
  "city": "Buenos Aires",
  "activeRole": "family",
  "availableRoles": ["family", "professional"],
  "createdAt": "2026-04-29T18:40:00Z",
  "updatedAt": "2026-04-29T18:40:00Z"
}
```

### Pet

```json
{
  "id": "pet_01",
  "accountId": "usr_01",
  "name": "Mora",
  "species": "Perro",
  "breed": "Mestiza",
  "ageLabel": "3 anos",
  "sex": "Hembra",
  "location": "Palermo",
  "biography": "Companera tranquila y sociable.",
  "qr": {
    "publicId": "qr_mora_01",
    "enabled": true,
    "status": "active"
  },
  "createdAt": "2026-04-29T18:40:00Z",
  "updatedAt": "2026-04-29T18:40:00Z"
}
```

### Activity Destination

```json
{
  "type": "pet",
  "petId": "pet_01",
  "threadId": null,
  "notificationId": null
}
```

## Auth / Usuarios

### POST `/api/v1/auth/register`

Descripcion: crea una cuenta real futura.

Auth requerida: no.

Request:

```json
{
  "ownerName": "Familia Gomez",
  "email": "familia@mascotify.app",
  "password": "password-seguro",
  "city": "Buenos Aires",
  "initialRole": "family"
}
```

Response `201`:

```json
{
  "user": {
    "id": "usr_01",
    "email": "familia@mascotify.app",
    "ownerName": "Familia Gomez",
    "city": "Buenos Aires",
    "activeRole": "family",
    "availableRoles": ["family"]
  },
  "session": {
    "accessToken": "access_token",
    "refreshToken": "refresh_token",
    "expiresAt": "2026-04-29T19:40:00Z"
  }
}
```

Errores: `VALIDATION_ERROR`, `CONFLICT`, `RATE_LIMITED`.

Notas: passwords nunca deben volver en responses. La politica real de contrasenas y MFA queda abierta.

### POST `/api/v1/auth/login`

Descripcion: autentica una cuenta.

Auth requerida: no.

Request:

```json
{
  "email": "familia@mascotify.app",
  "password": "password-seguro"
}
```

Response `200`: mismo formato que register.

Errores: `VALIDATION_ERROR`, `UNAUTHENTICATED`, `RATE_LIMITED`.

### POST `/api/v1/auth/refresh`

Descripcion: renueva access token.

Auth requerida: no; usa refresh token.

Request:

```json
{
  "refreshToken": "refresh_token"
}
```

Response `200`:

```json
{
  "accessToken": "new_access_token",
  "expiresAt": "2026-04-29T20:40:00Z"
}
```

Errores: `UNAUTHENTICATED`, `RATE_LIMITED`.

### GET `/api/v1/users/me`

Descripcion: obtiene usuario y cuenta activa.

Auth requerida: si.

Response `200`:

```json
{
  "user": {
    "id": "usr_01",
    "email": "familia@mascotify.app",
    "ownerName": "Familia Gomez",
    "city": "Buenos Aires",
    "activeRole": "family",
    "availableRoles": ["family", "professional"]
  }
}
```

Errores: `UNAUTHENTICATED`.

### PATCH `/api/v1/users/me`

Descripcion: actualiza perfil de usuario.

Auth requerida: si.

Request:

```json
{
  "ownerName": "Familia Gomez",
  "city": "Buenos Aires"
}
```

Response `200`: usuario actualizado.

Errores: `VALIDATION_ERROR`, `UNAUTHENTICATED`.

### POST `/api/v1/users/me/active-role`

Descripcion: cambia el modo activo entre familia/profesional.

Auth requerida: si.

Request:

```json
{
  "role": "professional"
}
```

Response `200`:

```json
{
  "activeRole": "professional"
}
```

Errores: `VALIDATION_ERROR`, `FORBIDDEN`.

Notas: no debe mezclar datos privados entre roles.

## Mascotas

### GET `/api/v1/pets`

Descripcion: lista mascotas de la cuenta activa.

Auth requerida: si.

Query: `cursor`, `limit`.

Response `200`:

```json
{
  "items": [
    {
      "id": "pet_01",
      "name": "Mora",
      "species": "Perro",
      "breed": "Mestiza",
      "qr": {
        "publicId": "qr_mora_01",
        "enabled": true,
        "status": "active"
      }
    }
  ],
  "pageInfo": {
    "nextCursor": null,
    "hasNextPage": false
  }
}
```

Errores: `UNAUTHENTICATED`.

### POST `/api/v1/pets`

Descripcion: crea una mascota.

Auth requerida: si.

Request:

```json
{
  "name": "Mora",
  "species": "Perro",
  "breed": "Mestiza",
  "ageLabel": "3 anos",
  "sex": "Hembra",
  "location": "Palermo",
  "biography": "Companera tranquila y sociable.",
  "qrEnabled": true
}
```

Response `201`: `Pet`.

Errores: `VALIDATION_ERROR`, `UNAUTHENTICATED`.

Notas: crear mascota deberia emitir un evento interno de historial.

### GET `/api/v1/pets/{petId}`

Descripcion: detalle privado de mascota.

Auth requerida: si.

Response `200`: `Pet`.

Errores: `UNAUTHENTICATED`, `FORBIDDEN`, `NOT_FOUND`.

### PATCH `/api/v1/pets/{petId}`

Descripcion: edita una mascota.

Auth requerida: si.

Request: campos parciales de `Pet`.

Response `200`: `Pet` actualizado.

Errores: `VALIDATION_ERROR`, `FORBIDDEN`, `NOT_FOUND`, `CONFLICT`.

### DELETE `/api/v1/pets/{petId}`

Descripcion: elimina o archiva una mascota.

Auth requerida: si.

Response `204`.

Errores: `FORBIDDEN`, `NOT_FOUND`, `CONFLICT`.

Notas: considerar soft delete para preservar historial y mensajes relacionados.

### GET `/api/v1/public/pets/{publicId}`

Descripcion: perfil publico de mascota asociado a QR o link publico.

Auth requerida: no.

Response `200`:

```json
{
  "id": "pet_01",
  "publicId": "qr_mora_01",
  "name": "Mora",
  "species": "Perro",
  "profileSummary": "Mora tiene un perfil publico protegido.",
  "contactPolicy": "protected"
}
```

Errores: `NOT_FOUND`, `RATE_LIMITED`.

Notas: no exponer email, telefono o domicilio exacto sin reglas explicitas.

## QR / Trazabilidad

### GET `/api/v1/qr/{publicId}`

Descripcion: consulta un QR publico y devuelve informacion segura.

Auth requerida: no.

Response `200`:

```json
{
  "publicId": "qr_mora_01",
  "pet": {
    "id": "pet_01",
    "name": "Mora",
    "species": "Perro"
  },
  "status": "active",
  "allowedActions": ["view_public_profile", "report_sighting"]
}
```

Errores: `NOT_FOUND`, `RATE_LIMITED`.

Notas: registrar consulta anonima solo si cumple privacidad y consentimiento.

### POST `/api/v1/qr/{publicId}/events`

Descripcion: registra un evento QR, como escaneo o apertura publica.

Auth requerida: no para eventos publicos; si para eventos internos.

Request:

```json
{
  "type": "scan",
  "source": "public_qr",
  "approximateLocation": {
    "label": "Palermo",
    "lat": null,
    "lng": null
  }
}
```

Response `201`:

```json
{
  "id": "qr_evt_01",
  "publicId": "qr_mora_01",
  "type": "scan",
  "createdAt": "2026-04-29T18:40:00Z"
}
```

Errores: `VALIDATION_ERROR`, `NOT_FOUND`, `RATE_LIMITED`.

### POST `/api/v1/qr/{publicId}/sightings`

Descripcion: reporta un avistaje desde perfil publico.

Auth requerida: no inicialmente; puede requerir captcha o rate limit.

Request:

```json
{
  "message": "La vi cerca de Plaza Italia.",
  "locationLabel": "Palermo",
  "contactName": "Ana",
  "contactEmail": "ana@example.com"
}
```

Response `201`:

```json
{
  "id": "sighting_01",
  "status": "received",
  "createdAt": "2026-04-29T18:40:00Z"
}
```

Errores: `VALIDATION_ERROR`, `NOT_FOUND`, `RATE_LIMITED`.

Notas: proteger contra spam y no exponer datos del reportante sin consentimiento.

### GET `/api/v1/pets/{petId}/qr-history`

Descripcion: obtiene historial QR privado de una mascota.

Auth requerida: si.

Query: `cursor`, `limit`, `type`.

Response `200`:

```json
{
  "items": [
    {
      "id": "qr_evt_01",
      "type": "scan",
      "title": "QR escaneado",
      "detail": "Se abrio el perfil publico protegido.",
      "createdAt": "2026-04-29T18:40:00Z"
    }
  ],
  "pageInfo": {
    "nextCursor": null,
    "hasNextPage": false
  }
}
```

Errores: `FORBIDDEN`, `NOT_FOUND`.

## Historial De Actividad

### GET `/api/v1/pets/{petId}/activity`

Descripcion: lista eventos internos por mascota.

Auth requerida: si.

Query: `type`, `cursor`, `limit`.

Response `200`:

```json
{
  "items": [
    {
      "id": "act_01",
      "petId": "pet_01",
      "type": "created",
      "title": "Mascota creada",
      "description": "Mora fue agregada a la cuenta.",
      "createdAt": "2026-04-29T18:40:00Z"
    }
  ],
  "pageInfo": {
    "nextCursor": null,
    "hasNextPage": false
  }
}
```

Errores: `FORBIDDEN`, `NOT_FOUND`.

### POST `/api/v1/pets/{petId}/activity`

Descripcion: crea un evento interno, cuando no derive automaticamente de otra mutacion.

Auth requerida: si.

Request:

```json
{
  "type": "notification",
  "title": "Recordatorio",
  "description": "Control veterinario pendiente."
}
```

Response `201`: evento creado.

Errores: `VALIDATION_ERROR`, `FORBIDDEN`, `NOT_FOUND`.

Notas: preferir eventos derivados automaticamente para evitar inconsistencias.

## Feed General

### GET `/api/v1/feed`

Descripcion: lista actividad agregada del usuario/cuenta.

Auth requerida: si.

Query: `type`, `q`, `cursor`, `limit`.

Response `200`:

```json
{
  "items": [
    {
      "id": "feed_01",
      "type": "pet",
      "title": "Mascota creada",
      "description": "Mora fue agregada a la cuenta.",
      "sourceLabel": "Mascotas",
      "createdAt": "2026-04-29T18:40:00Z",
      "destination": {
        "type": "pet",
        "petId": "pet_01"
      }
    }
  ],
  "pageInfo": {
    "nextCursor": null,
    "hasNextPage": false
  }
}
```

Errores: `UNAUTHENTICATED`, `VALIDATION_ERROR`.

Notas: el feed puede ser materializado o derivado. Definir consistencia antes de escalar.

## Mensajeria

### GET `/api/v1/messages/threads`

Descripcion: lista conversaciones de la cuenta/rol activo.

Auth requerida: si.

Query: `cursor`, `limit`, `role`.

Response `200`:

```json
{
  "items": [
    {
      "id": "thread_01",
      "petId": "pet_01",
      "ownerName": "Contacto por Mora",
      "lastMessage": "Hola, queria consultar por Mora.",
      "unreadCount": 1,
      "updatedAt": "2026-04-29T18:40:00Z"
    }
  ],
  "pageInfo": {
    "nextCursor": null,
    "hasNextPage": false
  }
}
```

Errores: `UNAUTHENTICATED`.

### GET `/api/v1/messages/threads/{threadId}`

Descripcion: abre una conversacion.

Auth requerida: si.

Response `200`:

```json
{
  "id": "thread_01",
  "petId": "pet_01",
  "participants": ["usr_01", "usr_02"],
  "messages": [
    {
      "id": "msg_01",
      "senderId": "usr_02",
      "text": "Hola, queria consultar por Mora.",
      "createdAt": "2026-04-29T18:40:00Z",
      "readAt": null
    }
  ]
}
```

Errores: `FORBIDDEN`, `NOT_FOUND`.

### POST `/api/v1/messages/threads/{threadId}/messages`

Descripcion: envia mensaje.

Auth requerida: si.

Request:

```json
{
  "text": "Podemos seguir conversando por aca."
}
```

Response `201`:

```json
{
  "id": "msg_02",
  "senderId": "usr_01",
  "text": "Podemos seguir conversando por aca.",
  "createdAt": "2026-04-29T18:41:00Z"
}
```

Errores: `VALIDATION_ERROR`, `FORBIDDEN`, `NOT_FOUND`, `RATE_LIMITED`.

### POST `/api/v1/messages/threads/{threadId}/read`

Descripcion: marca conversacion como leida.

Auth requerida: si.

Response `204`.

Errores: `FORBIDDEN`, `NOT_FOUND`.

Notas: decidir tiempo real vs polling. WebSocket/SSE/push quedan abiertos.

## Notificaciones

### GET `/api/v1/notifications`

Descripcion: lista notificaciones de la cuenta activa.

Auth requerida: si.

Query: `unreadOnly`, `cursor`, `limit`.

Response `200`:

```json
{
  "items": [
    {
      "id": "notif_01",
      "type": "qr",
      "title": "Nuevo escaneo QR",
      "description": "El perfil publico de Mora fue consultado.",
      "isUnread": true,
      "createdAt": "2026-04-29T18:40:00Z",
      "destination": {
        "type": "qr_history",
        "petId": "pet_01"
      }
    }
  ],
  "pageInfo": {
    "nextCursor": null,
    "hasNextPage": false
  }
}
```

Errores: `UNAUTHENTICATED`.

### POST `/api/v1/notifications/{notificationId}/read`

Descripcion: marca una notificacion como leida.

Auth requerida: si.

Response `204`.

Errores: `FORBIDDEN`, `NOT_FOUND`.

### POST `/api/v1/notifications/read-all`

Descripcion: marca todas como leidas.

Auth requerida: si.

Response `204`.

Errores: `UNAUTHENTICATED`.

Notas: `destination` debe ser estable para mantener navegacion contextual.

## Preferencias / Plan

### GET `/api/v1/preferences`

Descripcion: obtiene preferencias de la cuenta activa.

Auth requerida: si.

Response `200`:

```json
{
  "notificationsEnabled": true,
  "messagesNotificationsEnabled": true,
  "petActivityNotificationsEnabled": true,
  "ecosystemUpdatesNotificationsEnabled": true,
  "privacyLevel": "balanced",
  "securityLevel": "standard",
  "publicProfileEnabled": true,
  "showBasicInfoOnPublicProfile": true,
  "ecosystemSuggestionsEnabled": true
}
```

Errores: `UNAUTHENTICATED`.

### PATCH `/api/v1/preferences`

Descripcion: actualiza preferencias.

Auth requerida: si.

Request: campos parciales de preferencias.

Response `200`: preferencias actualizadas.

Errores: `VALIDATION_ERROR`, `UNAUTHENTICATED`.

### GET `/api/v1/plan`

Descripcion: obtiene plan actual.

Auth requerida: si.

Response `200`:

```json
{
  "planName": "Mascotify Plus",
  "status": "active",
  "billingProvider": null
}
```

Errores: `UNAUTHENTICATED`.

### POST `/api/v1/plan/change-request`

Descripcion: registra intencion futura de cambio de plan. No procesa pagos reales todavia.

Auth requerida: si.

Request:

```json
{
  "targetPlan": "Mascotify Pro"
}
```

Response `202`:

```json
{
  "status": "pending_billing_integration",
  "targetPlan": "Mascotify Pro"
}
```

Errores: `VALIDATION_ERROR`, `UNAUTHENTICATED`.

Notas: pagos reales requieren proveedor, webhooks, auditoria y manejo de estados.

## Profesional

### POST `/api/v1/professional/presence`

Descripcion: activa presencia profesional para la cuenta.

Auth requerida: si.

Request:

```json
{
  "businessName": "Vet Palermo",
  "category": "Veterinaria",
  "services": ["Consulta general", "Vacunacion"],
  "operationLabel": "Atencion con turno"
}
```

Response `201`:

```json
{
  "id": "pro_01",
  "businessName": "Vet Palermo",
  "category": "Veterinaria",
  "status": "active",
  "publicProfileEnabled": true
}
```

Errores: `VALIDATION_ERROR`, `FORBIDDEN`, `CONFLICT`.

### GET `/api/v1/professional/me`

Descripcion: obtiene estado profesional privado de la cuenta.

Auth requerida: si.

Response `200`:

```json
{
  "id": "pro_01",
  "businessName": "Vet Palermo",
  "category": "Veterinaria",
  "status": "active",
  "services": ["Consulta general", "Vacunacion"]
}
```

Errores: `FORBIDDEN`, `NOT_FOUND`.

### PATCH `/api/v1/professional/me`

Descripcion: actualiza servicios, categoria o estado profesional.

Auth requerida: si.

Request: campos parciales del perfil profesional.

Response `200`: perfil actualizado.

Errores: `VALIDATION_ERROR`, `FORBIDDEN`, `NOT_FOUND`.

### GET `/api/v1/public/professionals/{professionalId}`

Descripcion: perfil publico profesional.

Auth requerida: no.

Response `200`:

```json
{
  "id": "pro_01",
  "businessName": "Vet Palermo",
  "category": "Veterinaria",
  "description": "Atencion profesional para mascotas.",
  "services": ["Consulta general", "Vacunacion"],
  "status": "active"
}
```

Errores: `NOT_FOUND`, `RATE_LIMITED`.

## Mapeo Local Actual A Backend Futuro

- `AppData`: fachada que hoy usan las pantallas. Debe seguir siendo el punto de entrada para evitar que la UI conozca HTTP o storage.
- `MascotifyDataSource`: contrato comun. Una implementacion remota futura deberia cumplir este contrato o dividirse internamente en repositorios por modulo.
- `PersistentLocalMascotifyDataSource`: implementacion activa local. Puede quedar como cache/offline o fallback durante migracion.
- `MockMascotifyDataSource` y datos mock: utiles para seeds, tests y demos; no deben confundirse con datos productivos.
- `RemoteMascotifyDataSource`: placeholder abstracto ya reservado para una futura capa remota. No hace red actualmente.
- Modelos en `lib/shared/models/`: base util para DTOs, aunque el backend puede requerir DTOs separados para no acoplar UI y API.
- Persistencia local: hoy es fuente de verdad local; en produccion podria ser cache con sync.

## Orden Recomendado De Backend

### Fase 1

- Auth real.
- Usuario/perfil.
- Mascotas.

Motivo: define identidad, permisos, cuenta activa y primer recurso central.

### Fase 2

- QR/trazabilidad.
- Historial por mascota.
- Feed.

Motivo: depende de mascotas e introduce eventos y destinos contextuales.

### Fase 3

- Mensajeria.
- Notificaciones.

Motivo: requiere reglas de lectura, orden, permisos, posible tiempo real y volumen creciente.

### Fase 4

- Profesional.
- Planes/pagos futuros.

Motivo: necesita roles maduros, presencia publica, auditoria y posiblemente integraciones externas.

## Riesgos Y Decisiones Abiertas

- Offline/local cache: decidir si la app puede mutar offline y luego sincronizar.
- Conflictos de sincronizacion: definir versionado, `updatedAt`, etags o revision numbers.
- Seguridad del QR publico: limitar datos expuestos, rate limiting, reportes abusivos y privacidad de contacto.
- Privacidad de datos: separar datos privados, publicos y compartibles por rol.
- Mensajes: decidir polling, WebSocket, SSE o push; tambien retencion y moderacion.
- Push notifications: definir proveedor, permisos y fallback interno.
- Pagos/planes: decidir proveedor, webhooks, estados, reintentos y conciliacion.
- Roles familia/profesional: definir permisos cuando una cuenta tenga ambos roles.
- Busqueda/feed: decidir si se deriva on-demand o se materializa.
- Eliminacion de datos: definir soft delete, exportacion y cumplimiento legal.

## Regla De Implementacion

Ningun endpoint de este documento esta implementado todavia. La app local debe seguir funcionando mientras se agreguen implementaciones remotas por modulo, con tests de contrato y regresion antes de cambiar la fuente activa.
