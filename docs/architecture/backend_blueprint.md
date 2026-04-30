# Mascotify Backend Blueprint

## 1. Objetivo Del Backend Real

El backend real de Mascotify deberia convertir la demo local en una plataforma sincronizada, multi-dispositivo y preparada para produccion.

Resolveria:

- Identidad real de usuarios y sesiones.
- Persistencia remota de cuentas, mascotas, QR, actividad, mensajes, notificaciones y preferencias.
- Separacion segura entre datos privados, datos publicos y datos compartibles.
- Sincronizacion entre dispositivos.
- Base para push notifications, mensajeria en tiempo real, imagenes, pagos y administracion.

Pasaria de local/demo a remoto:

- Auth local y cuentas demo.
- `SharedPreferences` como fuente principal.
- Mascotas CRUD.
- QR y trazabilidad.
- Historial/feed.
- Mensajeria y notificaciones internas.
- Preferencias y plan.
- Perfil profesional.

Podria seguir funcionando localmente:

- Modo demo/local para ventas, QA y desarrollo.
- Cache local de lectura.
- Algunas preferencias no sensibles.
- Offline futuro, si se decide implementarlo despues de la primera version online.

## 2. Stack Recomendado

### Recomendacion Principal

- Node.js + TypeScript.
- NestJS.
- PostgreSQL.
- Prisma ORM.
- JWT access token + refresh token persistido/rotado.
- Object storage futuro para imagenes.
- Redis opcional para cache, rate limiting, colas y presencia.
- WebSocket opcional futuro para mensajeria real.

### Por Que NestJS

NestJS es una buena opcion para Mascotify porque el dominio ya se ordena naturalmente por modulos: Auth, Users, Pets, QR, Activity, Messages, Notifications, Preferences y Professional. Aporta estructura, dependency injection, guards, pipes, DTOs y testing sin inventar demasiado framework propio.

Express o Fastify tambien son validos. Si el equipo prefiere control fino y menor abstraccion, Fastify + TypeScript puede ser una alternativa. La recomendacion inicial es NestJS sobre Fastify adapter si se busca estructura y performance razonable.

### Por Que PostgreSQL

Mascotify necesita relaciones claras: usuarios, roles, mascotas, QR, eventos, conversaciones, mensajes, notificaciones y preferencias. PostgreSQL permite constraints, indices, transacciones, JSONB puntual, busqueda simple y evolucion a busqueda avanzada mas adelante.

### Por Que Prisma

Prisma acelera modelado, migraciones y tipado en TypeScript. Para una primera version backend reduce friccion. Si el proyecto crece hacia consultas muy complejas, se puede complementar con SQL directo.

### Tecnologias No Decididas Todavia

- REST vs GraphQL: REST es suficiente para iniciar y consistente con `api_contracts.md`.
- Proveedor cloud: Render, Fly, Railway, AWS, GCP o Azure.
- Proveedor de imagenes: S3-compatible, Cloudinary o similar.
- Tiempo real: polling inicial, WebSocket/SSE futuro.
- Pagos: Stripe, Mercado Pago u otro proveedor segun mercado.

## 3. Arquitectura Sugerida

La API deberia organizarse por modulos con boundaries claros.

### Auth

Responsabilidad:

- Registro.
- Login.
- Refresh tokens.
- Logout.
- Recuperacion de cuenta futura.

Entidades:

- `users`
- `refresh_tokens`
- `audit_logs`

Endpoints relacionados:

- `/auth/register`
- `/auth/login`
- `/auth/refresh`
- `/auth/logout`

Dependencias:

- Users.
- Audit logs.

### Users

Responsabilidad:

- Perfil base de usuario.
- Roles disponibles.
- Rol activo.
- Datos de cuenta.

Entidades:

- `users`
- `user_profiles`
- `user_roles`

Endpoints relacionados:

- `/users/me`
- `/users/me/active-role`

Dependencias:

- Auth.
- Preferences.

### Pets

Responsabilidad:

- CRUD de mascotas.
- Detalle privado.
- Perfil publico controlado.
- Relacion con QR y eventos.

Entidades:

- `pets`
- `pet_public_profiles`
- `pet_qr_codes`

Endpoints relacionados:

- `/pets`
- `/pets/{petId}`
- `/public/pets/{publicId}`

Dependencias:

- Users.
- QR.
- Activity.

### QR / Traceability

Responsabilidad:

- QR publico no predecible.
- Consulta publica segura.
- Eventos QR.
- Reportes de avistaje.
- Historial privado.

Entidades:

- `pet_qr_codes`
- `qr_events`
- `sighting_reports`

Endpoints relacionados:

- `/qr/{publicId}`
- `/qr/{publicId}/events`
- `/qr/{publicId}/sightings`
- `/pets/{petId}/qr-history`

Dependencias:

- Pets.
- Notifications.
- Activity.

### Activity

Responsabilidad:

- Historial por mascota.
- Eventos internos derivados de acciones.
- Base para feed y notificaciones.

Entidades:

- `pet_activity_events`

Endpoints relacionados:

- `/pets/{petId}/activity`

Dependencias:

- Pets.
- Feed.
- Notifications.

### Feed

Responsabilidad:

- Actividad agregada de usuario/cuenta.
- Filtros por tipo.
- Busqueda simple.
- Paginacion.

Entidades:

- `activity_feed_items`, si se decide materializar.
- O vistas/queries derivadas desde eventos.

Endpoints relacionados:

- `/feed`

Dependencias:

- Activity.
- Messages.
- Notifications.
- QR.

### Messages

Responsabilidad:

- Conversaciones.
- Mensajes.
- Leido/no leido.
- Aislamiento por cuenta y rol.

Entidades:

- `message_threads`
- `message_participants`
- `message_entries`

Endpoints relacionados:

- `/messages/threads`
- `/messages/threads/{threadId}`
- `/messages/threads/{threadId}/messages`
- `/messages/threads/{threadId}/read`

Dependencias:

- Users.
- Pets.
- Notifications.

### Notifications

Responsabilidad:

- Notificaciones internas.
- Estados leido/no leido.
- Destinos contextuales.
- Preferencias de notificacion.

Entidades:

- `notifications`
- `user_preferences`

Endpoints relacionados:

- `/notifications`
- `/notifications/{notificationId}/read`
- `/notifications/read-all`

Dependencias:

- Users.
- Activity.
- Messages.
- QR.

### Preferences

Responsabilidad:

- Preferencias de privacidad, seguridad y notificaciones.
- Plan visible actual, sin pagos reales al inicio.

Entidades:

- `user_preferences`
- `plans`
- `subscriptions` futuro.

Endpoints relacionados:

- `/preferences`
- `/plan`
- `/plan/change-request`

Dependencias:

- Users.
- Notifications.
- Plans.

### Professional Profiles

Responsabilidad:

- Presencia profesional.
- Servicios.
- Estado publico.
- Perfil publico profesional.

Entidades:

- `professional_profiles`
- `professional_services`

Endpoints relacionados:

- `/professional/presence`
- `/professional/me`
- `/public/professionals/{professionalId}`

Dependencias:

- Users.
- Preferences.
- Plans futuro.

### Plans / Subscription Future

Responsabilidad:

- Catalogo de planes.
- Estado de suscripcion.
- Integracion futura con proveedor de pagos.

Entidades:

- `plans`
- `subscriptions`
- `billing_events` futuro.

Dependencias:

- Users.
- Professional.
- Audit logs.

### Admin Future

Responsabilidad:

- Moderacion.
- Auditoria.
- Soporte.
- Gestion de reportes y abuso.

Entidades:

- `audit_logs`
- `admin_actions`
- `abuse_reports` futuro.

Dependencias:

- Todos los modulos sensibles.

## 4. Modelo De Datos Inicial

No es SQL final. Es una guia suficientemente concreta para empezar schema y migraciones.

### `users`

Campos principales:

- `id`
- `email`
- `password_hash`
- `owner_name`
- `city`
- `active_role`
- `created_at`
- `updated_at`
- `deleted_at`

Relaciones:

- Tiene `user_profiles`.
- Tiene `pets`.
- Tiene `user_preferences`.
- Tiene `professional_profiles`.

Indices:

- Unique `email`.
- Index `active_role`.
- Index `deleted_at`.

Seguridad/privacidad:

- Nunca exponer `password_hash`.
- Soft delete recomendado.
- Email normalizado.

### `user_profiles`

Campos:

- `id`
- `user_id`
- `role` (`family`, `professional`)
- `display_name`
- `summary`
- `created_at`
- `updated_at`

Relaciones:

- Pertenece a `users`.

Indices:

- Unique `(user_id, role)`.

Notas:

- Permite que una cuenta tenga perfil familiar y profesional sin duplicar usuario.

### `pets`

Campos:

- `id`
- `user_id`
- `name`
- `species`
- `breed`
- `age_label`
- `sex`
- `location_label`
- `biography`
- `status`
- `created_at`
- `updated_at`
- `deleted_at`

Relaciones:

- Pertenece a `users`.
- Tiene `pet_public_profiles`.
- Tiene `pet_qr_codes`.
- Tiene `pet_activity_events`.

Indices:

- Index `(user_id, deleted_at)`.
- Index `name` para busqueda simple futura.

Privacidad:

- `location_label` no debe implicar geolocalizacion exacta.
- Publicar solo campos aprobados.

### `pet_public_profiles`

Campos:

- `id`
- `pet_id`
- `public_slug`
- `enabled`
- `display_name`
- `public_summary`
- `contact_policy`
- `created_at`
- `updated_at`

Relaciones:

- Pertenece a `pets`.

Indices:

- Unique `public_slug`.
- Index `(pet_id, enabled)`.

Privacidad:

- No exponer email, telefono ni direccion exacta por defecto.

### `pet_qr_codes`

Campos:

- `id`
- `pet_id`
- `public_id`
- `status`
- `enabled`
- `created_at`
- `last_used_at`
- `revoked_at`

Relaciones:

- Pertenece a `pets`.
- Tiene `qr_events`.

Indices:

- Unique `public_id`.
- Index `(pet_id, status)`.

Seguridad:

- `public_id` debe ser no predecible.
- Permitir rotacion/revocacion.

### `qr_events`

Campos:

- `id`
- `qr_code_id`
- `pet_id`
- `type`
- `source`
- `approx_location_label`
- `ip_hash`
- `user_agent_hash`
- `created_at`

Relaciones:

- Pertenece a `pet_qr_codes`.
- Pertenece a `pets`.

Indices:

- Index `(pet_id, created_at desc)`.
- Index `(qr_code_id, created_at desc)`.
- Index `type`.

Privacidad:

- Hash o truncar datos tecnicos.
- Retencion limitada si se guardan senales publicas.

### `sighting_reports`

Campos:

- `id`
- `qr_code_id`
- `pet_id`
- `message`
- `location_label`
- `contact_name`
- `contact_email`
- `status`
- `created_at`
- `reviewed_at`

Indices:

- Index `(pet_id, created_at desc)`.
- Index `status`.

Seguridad:

- Rate limiting.
- Moderacion.
- No publicar datos del reportante.

### `pet_activity_events`

Campos:

- `id`
- `user_id`
- `pet_id`
- `type`
- `title`
- `description`
- `related_entity_type`
- `related_entity_id`
- `created_at`

Relaciones:

- Pertenece a `users`.
- Pertenece a `pets`.

Indices:

- Index `(pet_id, created_at desc)`.
- Index `(user_id, created_at desc)`.
- Index `type`.

Notas:

- Fuente natural para historial y parte del feed.

### `activity_feed_items`

Campos:

- `id`
- `user_id`
- `type`
- `title`
- `description`
- `source_label`
- `destination_type`
- `destination_id`
- `sort_at`
- `created_at`

Relaciones:

- Pertenece a `users`.

Indices:

- Index `(user_id, sort_at desc)`.
- Index `(user_id, type, sort_at desc)`.

Notas:

- Opcional. Se puede derivar desde eventos primero y materializar despues si performance lo pide.

### `message_threads`

Campos:

- `id`
- `pet_id`
- `created_by_user_id`
- `status`
- `last_message_preview`
- `last_message_at`
- `created_at`
- `updated_at`

Relaciones:

- Tiene `message_participants`.
- Tiene `message_entries`.
- Puede relacionarse con `pets`.

Indices:

- Index `(last_message_at desc)`.
- Index `pet_id`.

Privacidad:

- Acceso solo a participantes autorizados.

### `message_participants`

Campos:

- `id`
- `thread_id`
- `user_id`
- `role`
- `last_read_at`
- `created_at`

Indices:

- Unique `(thread_id, user_id)`.
- Index `(user_id, last_read_at)`.

### `message_entries`

Campos:

- `id`
- `thread_id`
- `sender_user_id`
- `text`
- `created_at`
- `deleted_at`

Indices:

- Index `(thread_id, created_at asc)`.

Seguridad:

- Moderacion futura.
- Limites de longitud.
- Reporte/bloqueo futuro.

### `notifications`

Campos:

- `id`
- `user_id`
- `type`
- `title`
- `description`
- `destination_type`
- `destination_id`
- `read_at`
- `created_at`

Indices:

- Index `(user_id, created_at desc)`.
- Index `(user_id, read_at)`.
- Index `type`.

Notas:

- Internas primero; push puede agregarse despues.

### `user_preferences`

Campos:

- `id`
- `user_id`
- `notifications_enabled`
- `messages_notifications_enabled`
- `pet_activity_notifications_enabled`
- `ecosystem_updates_notifications_enabled`
- `privacy_level`
- `security_level`
- `public_profile_enabled`
- `show_basic_info_on_public_profile`
- `ecosystem_suggestions_enabled`
- `created_at`
- `updated_at`

Indices:

- Unique `user_id`.

Privacidad:

- Defaults conservadores.

### `professional_profiles`

Campos:

- `id`
- `user_id`
- `business_name`
- `category`
- `description`
- `status`
- `public_profile_enabled`
- `created_at`
- `updated_at`

Relaciones:

- Pertenece a `users`.
- Tiene `professional_services`.

Indices:

- Unique `user_id`, si solo se permite una presencia inicial.
- Index `(status, public_profile_enabled)`.
- Index `category`.

### `professional_services`

Campos:

- `id`
- `professional_profile_id`
- `name`
- `description`
- `position`
- `enabled`

Indices:

- Index `(professional_profile_id, position)`.

### `plans`

Campos:

- `id`
- `name`
- `slug`
- `description`
- `status`
- `created_at`

Indices:

- Unique `slug`.

### `subscriptions`

Campos:

- `id`
- `user_id`
- `plan_id`
- `status`
- `billing_provider`
- `provider_subscription_id`
- `current_period_end`
- `created_at`
- `updated_at`

Indices:

- Index `(user_id, status)`.
- Index `provider_subscription_id`.

Notas:

- Futuro. No bloquear primera version sin pagos reales.

### `audit_logs`

Campos:

- `id`
- `actor_user_id`
- `action`
- `entity_type`
- `entity_id`
- `metadata`
- `created_at`

Indices:

- Index `(actor_user_id, created_at desc)`.
- Index `(entity_type, entity_id)`.

Seguridad:

- No guardar secretos.
- Retencion y acceso restringidos.

## 5. Auth Y Roles

Roles iniciales:

- `family`: administra mascotas, QR, mensajes, notificaciones y preferencias familiares.
- `professional`: administra presencia profesional, servicios y perfil publico profesional.
- `admin`: futuro, solo para soporte/moderacion/auditoria.

Registro:

- Crear `users`.
- Crear `user_profiles` para el rol inicial.
- Crear `user_preferences` con defaults.
- Emitir session inicial.

Login:

- Validar email/password.
- Emitir access token corto.
- Emitir refresh token rotado y persistido con hash.

Tokens:

- Access token corto, por ejemplo 15 minutos.
- Refresh token mas largo, por ejemplo 7 a 30 dias.
- Rotacion de refresh token en cada uso.
- Revocacion por logout.

Permisos:

- Todo recurso privado se filtra por `user_id` o participantes.
- No confiar en IDs enviados por el cliente sin verificar ownership.
- `family` puede acceder a sus mascotas, QR, mensajes y notificaciones.
- `professional` puede acceder a su perfil profesional y servicios.
- `admin` futuro debe usar permisos finos y audit logs.

Acceso publico:

- Mascota publica por `public_id` o `public_slug`, con datos minimizados.
- Profesional publico por ID/slug, solo si esta activo.
- QR publico no requiere sesion pero si rate limiting.

## 6. QR Y Seguridad

Estrategia:

- Usar `public_id` no predecible, no el `pet_id`.
- Permitir revocar y regenerar QR.
- Separar perfil publico de mascota del detalle privado.
- No exponer email, telefono, direccion exacta ni datos internos.
- Registrar eventos publicos con minimo dato tecnico.
- Agregar rate limiting desde la primera version publica.
- Agregar moderacion para reportes de avistaje.

Pagina publica segura:

- Mostrar solo nombre, especie y resumen aprobado.
- Ofrecer reporte de avistaje protegido.
- Evitar enumeracion de IDs.
- No revelar si una mascota tiene datos sensibles cargados.

Abuso:

- Rate limit por IP/huella tecnica.
- Captcha o challenge futuro.
- Cola de moderacion para reportes sospechosos.

## 7. Mensajeria Futura

Version inicial:

- REST + polling.
- Listar threads.
- Abrir thread.
- Enviar mensaje.
- Marcar leido.

Version futura:

- WebSocket o SSE para mensajes en tiempo real.
- Presencia opcional.
- Push notifications para mensajes.

Reglas:

- Solo participantes autorizados ven threads.
- Un mensaje pertenece a un thread.
- `last_read_at` por participante para unread.
- No mezclar mensajes entre roles si la cuenta opera como familia y profesional.

Futuro:

- Bloqueo.
- Reportes.
- Moderacion.
- Adjuntos.
- Plantillas/automations profesionales.

## 8. Notificaciones Futuras

Primera etapa:

- Notificaciones internas persistidas.
- Leido/no leido.
- Destino contextual estable.
- Preferencias por tipo.

Eventos generadores:

- Mascota creada/editada/eliminada.
- QR consultado.
- Avistaje recibido.
- Mensaje recibido.
- Perfil profesional activado.
- Cambios relevantes de cuenta.

Push futuro:

- Agregar tabla de device tokens.
- Respetar preferencias.
- Manejar opt-in por plataforma.
- Fallback a inbox interno.

## 9. Migracion Desde Local/Demo

Estado actual:

- `AppData` es fachada usada por UI.
- `PersistentLocalMascotifyDataSource` es fuente activa local.
- `SharedPreferences` guarda snapshots por cuenta.
- `RemoteMascotifyDataSource` existe como placeholder abstracto.

### Fase 1

- Mantener local como demo.
- Crear implementacion remota apagada.
- Agregar config de runtime/feature flag.
- Agregar tests de contrato para cada modulo.

### Fase 2

- Auth real.
- Usuarios/perfiles.
- Sesion remota.
- Mantener demo local separada.

### Fase 3

- Mascotas y QR.
- Mapear IDs locales a IDs remotos.
- Decidir importacion manual o reset de demo.

### Fase 4

- Historial/feed/notificaciones.
- Definir si feed se deriva o materializa.
- Mantener destinos contextuales compatibles con UI.

### Fase 5

- Mensajeria.
- REST/polling inicial.
- Unread por participante.

### Fase 6

- Profesional.
- Planes.
- Admin futuro.
- Auditoria y moderacion.

Recomendacion:

- No migrar todo de golpe.
- No hacer que la UI consuma HTTP directamente.
- El cambio debe ocurrir debajo de `MascotifyDataSource` o repositorios internos.

## 10. Estrategia De Sincronizacion

Opciones:

- Online only inicial.
- Local cache de lectura.
- Offline first completo.

Recomendacion inicial:

- Online only para produccion v1.
- Mantener demo/local como modo separado.
- Agregar cache de lectura despues, si la UX lo pide.
- Evitar offline mutations hasta tener resolucion de conflictos.

Conflictos:

- Usar `updated_at` y version/revision por entidad.
- Para PATCH, considerar optimistic concurrency con `If-Match` o `version`.
- En conflicto, backend responde `409 CONFLICT`.
- UI decide recargar o pedir confirmacion.

## 11. Seguridad Y Privacidad

Datos personales:

- Email y nombre son privados.
- Cifrado en transito obligatorio.
- Hash fuerte de passwords.
- Minimizacion de datos en logs.

Mascotas:

- Detalle privado solo para owner.
- Perfil publico separado y controlado.
- Soft delete para evitar perdida accidental y preservar auditoria.

QR publico:

- IDs no predecibles.
- Rate limiting.
- No datos privados por defecto.
- Reportes protegidos contra spam.

Mensajes:

- Acceso solo a participantes.
- Moderacion/reportes futuro.
- No incluir contenido de mensajes completos en logs.

Notificaciones:

- Filtrar por usuario.
- Destinos validados.
- Preferencias respetadas.

Logs:

- No guardar tokens, passwords ni datos sensibles completos.
- Audit logs para acciones sensibles.

Backups:

- Backups automaticos.
- Restore probado.
- Retencion definida.

Eliminacion de datos:

- Soft delete inicial.
- Flujo futuro de exportacion/eliminacion definitiva.
- Revisar obligaciones legales antes de produccion.

## 12. Deploy Futuro

Opciones razonables:

- Render, Fly.io o Railway para primera version simple.
- AWS/GCP/Azure si se requiere mayor control operativo.
- PostgreSQL managed.
- Object storage S3-compatible para imagenes.
- Redis managed si se agregan colas, cache o rate limiting distribuido.

Ambientes:

- `local`
- `staging`
- `production`

Variables de entorno:

- `DATABASE_URL`
- `JWT_ACCESS_SECRET`
- `JWT_REFRESH_SECRET`
- `CORS_ORIGINS`
- `APP_ENV`
- `OBJECT_STORAGE_*` futuro
- `REDIS_URL` futuro
- `PAYMENTS_*` futuro

Web app hosting:

- Flutter web puede alojarse separado del backend.
- Configurar CORS y base URL por ambiente.

Mobile futuro:

- API estable versionada.
- Push tokens por plataforma.
- Deep links para QR/perfiles.

## 13. Roadmap Tecnico Recomendado

### Etapa 1: Backend Base

- Repo/backend skeleton.
- NestJS + TypeScript.
- Prisma + PostgreSQL.
- Healthcheck.
- Config/env validation.
- Error model estandar.
- Logging seguro.

### Etapa 2: Auth

- Register/login/refresh/logout.
- Hash passwords.
- Guards por JWT.
- Refresh token rotation.
- Tests de auth.

### Etapa 3: Usuarios Y Mascotas

- Users/me.
- Roles family/professional.
- CRUD mascotas.
- Perfil publico de mascota separado.
- Tests de ownership.

### Etapa 4: QR

- QR public ID no predecible.
- Consulta publica.
- Eventos QR.
- Reportes de avistaje.
- Rate limiting inicial.

### Etapa 5: Activity, Feed, Notifications

- Eventos por mascota.
- Feed derivado o materializado.
- Notificaciones internas.
- Read/unread.
- Destinos contextuales.

### Etapa 6: Messages

- Threads.
- Entries.
- Read state.
- Polling inicial.
- Preparar WebSocket futuro.

### Etapa 7: Professional

- Presencia profesional.
- Servicios.
- Perfil publico profesional.
- Estado visible/no visible.

### Etapa 8: Admin Y Deploy Productivo

- Audit logs.
- Admin minimo.
- Staging.
- Backups.
- Observabilidad.
- Runbook operativo.

## 14. Riesgos Y Decisiones Abiertas

- Stack final: NestJS recomendado, pero Express/Fastify siguen posibles.
- REST vs GraphQL.
- Polling vs WebSocket para mensajes.
- Estrategia de imagenes y storage.
- Privacidad exacta del QR publico.
- Geolocalizacion real o solo referencias aproximadas.
- Proveedor de pagos.
- Moderacion de mensajes/reportes.
- Escalabilidad de feed.
- Estrategia offline.
- Migracion de datos locales existentes.
- Requisitos legales de datos personales y eliminacion.

## Regla De Esta Fase

Este blueprint no implementa backend. No crea servidor, no agrega dependencias, no cambia la app Flutter y no activa servicios reales. Sirve como guia tecnica para una futura etapa de implementacion.
