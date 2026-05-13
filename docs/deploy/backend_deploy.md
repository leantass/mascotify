# Mascotify - Deploy publico del backend

## Objetivo

Preparar el backend Node.js/TypeScript de Mascotify para un primer deploy publico en proveedores como Render o Railway.

Un celular Android o iOS no puede consumir `localhost` de la maquina de desarrollo. Para que Flutter Clips use feed remoto, likes, follows, share y subida firmada con Cloudinary, la app necesita una URL publica, por ejemplo:

```text
https://mascotify-backend.onrender.com/api/v1
```

Esta guia no hace deploy automatico, no crea secretos y no publica credenciales.

## Estado del backend

- Runtime: Node.js 20 o superior.
- Framework: Express.
- Build: TypeScript a `dist/`.
- Start: `npm start` ejecuta `node dist/server.js`.
- Puerto: usa `process.env.PORT` con fallback local `4000`.
- Healthcheck publico:
  - `GET /health`
  - `GET /api/v1/health`
- Prisma: configurado con PostgreSQL mediante `DATABASE_URL`.
- Cloudinary: upload firmado por backend, sin exponer `CLOUDINARY_API_SECRET` al cliente.
- CORS: configurable con `CORS_ORIGIN`.

## Variables de entorno

Configurar en Render/Railway, nunca commitear en `.env` real:

```text
PORT=4000
NODE_ENV=production
DATABASE_URL=
CORS_ORIGIN=http://localhost:3000,http://localhost:8080,http://localhost:5000,https://TU_WEB_PUBLICA
CLOUDINARY_CLOUD_NAME=
CLOUDINARY_API_KEY=
CLOUDINARY_API_SECRET=
CLOUDINARY_UPLOAD_FOLDER=mascotify/clips
```

Notas:

- `PORT` suele ser inyectado por Render/Railway; no hace falta fijarlo si el proveedor lo setea.
- `DATABASE_URL` debe apuntar a PostgreSQL para deploy real.
- `CORS_ORIGIN` es una lista separada por comas. Para apps mobile nativas normalmente no hay header `Origin`; para Flutter Web si importa.
- No usar `localhost` como URL final para Android/iOS.

## Comandos backend

Desde `backend/`:

```bash
npm ci
npm run prisma:generate
npm run build
npm start
```

Tests:

```bash
npm test
```

Prisma produccion:

```bash
npm run prisma:migrate:deploy
```

Si todavia no hay migraciones productivas versionadas para el estado actual de la base, no improvisar comandos destructivos. Para un primer entorno temporal se puede evaluar `npm run db:push`, pero debe quedar documentado como sincronizacion de desarrollo, no como estrategia de migraciones productivas.

## Deploy en Render

### Opcion A: Root Directory = `backend`

Configuracion sugerida:

```text
Root Directory: backend
Build Command: npm ci && npm run prisma:generate && npm run build
Start Command: npm start
Health Check Path: /health
```

Variables:

- `NODE_ENV=production`
- `DATABASE_URL=<postgres-public/internal-url>`
- `CORS_ORIGIN=<origenes-web-permitidos>`
- `CLOUDINARY_CLOUD_NAME=<valor>`
- `CLOUDINARY_API_KEY=<valor>`
- `CLOUDINARY_API_SECRET=<valor-secreto>`
- `CLOUDINARY_UPLOAD_FOLDER=mascotify/clips`

### Opcion B: Root Directory = repo raiz

Configuracion sugerida:

```text
Build Command: cd backend && npm ci && npm run prisma:generate && npm run build
Start Command: cd backend && npm start
Health Check Path: /health
```

Usar esta opcion si el proveedor necesita ver el repo completo.

## Deploy en Railway

### Opcion A: servicio apuntando a `backend`

Configuracion sugerida:

```text
Build Command: npm ci && npm run prisma:generate && npm run build
Start Command: npm start
```

Agregar plugin/servicio PostgreSQL y copiar su `DATABASE_URL` al backend.

### Opcion B: servicio desde raiz del repo

```text
Build Command: cd backend && npm ci && npm run prisma:generate && npm run build
Start Command: cd backend && npm start
```

Railway tambien inyecta `PORT`; el backend ya lo lee desde `process.env.PORT`.

## Base de datos y Prisma

El schema actual usa:

```prisma
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}
```

Para deploy real:

- Usar PostgreSQL administrado.
- Configurar `DATABASE_URL` como variable secreta del proveedor.
- Ejecutar `npm run prisma:generate` durante build.
- Ejecutar `npm run prisma:migrate:deploy` cuando existan migraciones versionadas listas para produccion.
- No usar SQLite para produccion.
- No ejecutar migraciones destructivas sin backup.

## Healthcheck

Probar despues del deploy:

```bash
curl https://TU_BACKEND/health
curl https://TU_BACKEND/api/v1/health
```

Respuesta esperada:

```json
{
  "status": "ok",
  "service": "mascotify-backend",
  "timestamp": "2026-05-13T12:00:00.000Z"
}
```

El healthcheck no requiere auth, base de datos ni Cloudinary.

## Cloudinary

El backend firma uploads con:

- `CLOUDINARY_CLOUD_NAME`
- `CLOUDINARY_API_KEY`
- `CLOUDINARY_API_SECRET`
- `CLOUDINARY_UPLOAD_FOLDER`

El secreto `CLOUDINARY_API_SECRET` solo vive en el proveedor backend. Flutter nunca debe recibirlo.

Si Cloudinary no esta configurado, el endpoint de firma devuelve error controlado y Flutter mantiene fallback local/demo.

## Probar endpoints de Clips

Header temporal hasta auth real:

```text
x-user-id: demo-user-local
```

Feed:

```bash
curl -H "x-user-id: demo-user-local" https://TU_BACKEND/api/v1/clips/feed
```

Upload signature:

```bash
curl -X POST -H "x-user-id: demo-user-local" https://TU_BACKEND/api/v1/clips/upload-signature
```

## Flutter apuntando al backend publico

Para Flutter Web local:

```bash
flutter run -d chrome --dart-define=SOCIAL_CLIPS_API_BASE_URL=https://TU_BACKEND/api/v1
```

Para APK debug:

```bash
flutter build apk --debug --dart-define=SOCIAL_CLIPS_API_BASE_URL=https://TU_BACKEND/api/v1
```

Para Android release/App Bundle:

```bash
flutter build appbundle --release --dart-define=SOCIAL_CLIPS_API_BASE_URL=https://TU_BACKEND/api/v1
```

Si no se define `SOCIAL_CLIPS_API_BASE_URL`, Flutter usa su configuracion local por defecto y conserva fallback demo si el backend no responde.

## Checklist previo a publicar URL en una app

- [ ] Backend desplegado y `GET /health` OK.
- [ ] `DATABASE_URL` configurado.
- [ ] Prisma Client generado.
- [ ] Estrategia de migraciones definida.
- [ ] Cloudinary configurado sin exponer `API_SECRET`.
- [ ] `CORS_ORIGIN` incluye la URL Web publica.
- [ ] Feed remoto probado con `x-user-id`.
- [ ] Flutter compilado con `SOCIAL_CLIPS_API_BASE_URL`.
- [ ] Fallback local verificado si backend cae.
- [ ] Logs del proveedor revisados.

## Pendientes futuros

- Auth real en vez de `x-user-id`.
- Moderacion/reportes de contenido.
- Storage y limites productivos de video.
- Migraciones productivas versionadas y pipeline controlado.
- Observabilidad, rate limits y alertas.
- Dominio propio para backend.

