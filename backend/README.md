# Mascotify Backend

Backend base real de Mascotify. Esta carpeta contiene el primer servidor Node.js + TypeScript, separado de la app Flutter.

## Estado

Implementado por ahora:

- Servidor Express minimo.
- Healthcheck.
- Configuracion de entorno basica.
- Prisma configurado.
- Schema inicial de base de datos.
- Prisma Client.
- Modulo inicial de usuarios con repository/service.
- Build TypeScript.
- Tests de backend.

Todavia no implementa:

- Auth real.
- Endpoints publicos de usuarios.
- Mascotas.
- QR/trazabilidad.
- Migraciones productivas aplicadas.
- Firebase.
- Google Auth.
- Pagos.
- WebSocket.
- Deploy.
- Conexion con Flutter.

## Requisitos

- Node.js 20 o superior.
- npm.

## Instalacion

```bash
npm install
```

## Desarrollo

```bash
npm run dev
```

Por defecto el servidor escucha en:

```text
http://localhost:4000
```

Se puede cambiar con `PORT`.

## Build

Antes de compilar por primera vez, generar Prisma Client:

```bash
npm run prisma:generate
```

```bash
npm run build
```

## Tests

```bash
npm test
```

## Typecheck

```bash
npm run typecheck
```

## Endpoints disponibles

```text
GET /health
GET /api/v1/health
```

Respuesta:

```json
{
  "status": "ok",
  "service": "mascotify-backend",
  "timestamp": "2026-04-30T12:00:00.000Z"
}
```

## Variables de entorno

Ver `.env.example`.

```text
PORT=4000
NODE_ENV=development
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/mascotify
```

`DATABASE_URL` se usa para migraciones y comandos de base de datos. No se debe commitear un `.env` real ni secretos.

## Prisma

Generar Prisma Client:

```bash
npm run prisma:generate
```

Crear una migracion local cuando exista una base PostgreSQL configurada:

```bash
npm run prisma:migrate:dev
```

Sincronizar el schema contra una base local durante desarrollo:

```bash
npm run db:push
```

Modelos iniciales:

- `User`: usuario base con email, nombre visible y rol.
- `UserProfile`: perfil asociado al usuario para datos de cuenta y tipo de perfil.
- `UserRole`: roles `FAMILY`, `PROFESSIONAL` y `ADMIN`.

## Modulos backend

El modulo `users` contiene una primera capa interna de repository/service para crear usuarios y buscarlos por email o id. Todavia no expone endpoints publicos ni implementa login real.

## Proximos pasos

- Auth real y estrategia de sesion/JWT.
- Endpoints de usuarios.
- Base PostgreSQL local/dev con migraciones.
- Mascotas, QR y trazabilidad en backend.
- Conexion futura Flutter/backend.
