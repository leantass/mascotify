# Mascotify Backend

Backend base real de Mascotify. Esta carpeta contiene el primer servidor Node.js + TypeScript, separado de la app Flutter.

## Estado

Implementado por ahora:

- Servidor Express minimo.
- Healthcheck.
- Configuracion de entorno basica.
- Build TypeScript.
- Tests de backend.

Todavia no implementa:

- Auth real.
- Usuarios.
- Mascotas.
- QR/trazabilidad.
- Base de datos.
- Prisma.
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
```
