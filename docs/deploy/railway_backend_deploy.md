# Mascotify - Deploy del backend en Railway

## Objetivo

Dejar el backend de Mascotify listo para una publicacion manual/asistida en Railway. La app Android/Web necesita una URL publica porque `localhost` no sirve desde un celular real.

Esta guia no hace deploy automatico, no guarda secretos en el repo y no reemplaza la configuracion de cuentas externas.

## 1. Crear proyecto Railway

1. Entrar a Railway y crear un proyecto nuevo.
2. Elegir deploy desde GitHub.
3. Conectar el repo `leantass/mascotify`.
4. Crear un servicio para el backend.

Railway puede hacer autodeploy desde la rama vinculada. En `Service Settings` se puede cambiar la rama usada para deploy. Para produccion, usar `main` cuando la fase ya este mergeada.

## 2. Root Directory recomendado

Configuracion recomendada:

```text
Root Directory: backend
```

Con esta opcion Railway usa `backend/package.json` y `backend/railway.json`.

Si se prefiere usar la raiz del repo como root, configurar comandos con `cd backend`:

```text
Build Command: cd backend && npm ci && npx prisma generate && npm run build
Start Command: cd backend && npm start
```

## 3. PostgreSQL

1. Agregar PostgreSQL dentro del proyecto Railway.
2. Copiar la variable `DATABASE_URL` del servicio PostgreSQL al servicio backend.
3. No copiar `DATABASE_URL` a archivos del repo.

El schema Prisma actual usa PostgreSQL. Para deploy productivo estable, versionar migraciones y ejecutar:

```bash
npx prisma migrate deploy
```

El repo todavia no tiene carpeta `prisma/migrations`. Por eso `backend/railway.json` no ejecuta migraciones automaticamente. Cuando existan migraciones versionadas, actualizar el build command a:

```bash
npm ci && npx prisma generate && npx prisma migrate deploy && npm run build
```

Para un entorno temporal de prueba se puede usar `npx prisma db push` de forma manual y consciente, pero no debe tratarse como estrategia definitiva de produccion.

## 4. Variables de entorno

Configurar en Railway, dentro del servicio backend:

```text
NODE_ENV=production
DATABASE_URL=<railway-postgres-url>
CLOUDINARY_CLOUD_NAME=<cloud-name>
CLOUDINARY_API_KEY=<api-key>
CLOUDINARY_API_SECRET=<api-secret>
CLOUDINARY_UPLOAD_FOLDER=mascotify/clips
CORS_ORIGIN=*
```

Notas:

- Railway inyecta `PORT`; no hace falta definirlo manualmente.
- `CORS_ORIGIN=*` permite probar rapido Flutter Web y mobile durante esta etapa inicial.
- Para produccion publica, reemplazar `*` por una lista separada por comas con origenes web reales.
- Mobile nativo normalmente no envia header `Origin`, pero Flutter Web si.
- `CLOUDINARY_API_SECRET` nunca debe llegar a Flutter.

## 5. Build y start

Con `Root Directory = backend`:

```text
Build Command: npm ci && npx prisma generate && npm run build
Start Command: npm start
Healthcheck Path: /health
```

Cuando haya migraciones Prisma versionadas:

```text
Build Command: npm ci && npx prisma generate && npx prisma migrate deploy && npm run build
```

## 6. Dominio publico

En Railway:

1. Abrir el servicio backend.
2. Ir a `Settings` o `Networking`.
3. Generar dominio publico.
4. Guardar la URL base, por ejemplo:

```text
https://mascotify-backend-production.up.railway.app
```

## 7. Probar healthcheck

Probar desde navegador o terminal:

```bash
curl https://TU_BACKEND/health
curl https://TU_BACKEND/api/v1/health
```

Respuesta esperada:

```json
{
  "status": "ok",
  "service": "mascotify-backend",
  "timestamp": "2026-05-15T12:00:00.000Z"
}
```

El healthcheck no requiere auth, base de datos ni Cloudinary.

## 8. Probar endpoints de clips

Mientras no haya auth real, el backend usa el header temporal `x-user-id`.

```bash
curl -H "x-user-id: demo-user-local" https://TU_BACKEND/api/v1/clips/feed
```

Firma de upload Cloudinary:

```bash
curl -X POST -H "x-user-id: demo-user-local" https://TU_BACKEND/api/v1/clips/upload-signature
```

Si Cloudinary no esta configurado, el endpoint debe devolver error controlado y Flutter conserva fallback local.

## 9. Configurar Flutter con backend publico

Web local:

```bash
flutter run -d chrome --dart-define=SOCIAL_CLIPS_API_BASE_URL=https://TU_BACKEND/api/v1
```

APK debug:

```bash
flutter build apk --debug --dart-define=SOCIAL_CLIPS_API_BASE_URL=https://TU_BACKEND/api/v1
```

Android App Bundle:

```bash
flutter build appbundle --release --dart-define=SOCIAL_CLIPS_API_BASE_URL=https://TU_BACKEND/api/v1
```

Si no se define `SOCIAL_CLIPS_API_BASE_URL`, Flutter mantiene su configuracion local y fallback demo.

## 10. Si falla el deploy

- Revisar logs del servicio backend en Railway.
- Confirmar que `Root Directory` sea `backend`.
- Confirmar que `DATABASE_URL` exista en el servicio backend.
- Confirmar que `npm ci`, `npx prisma generate` y `npm run build` pasan localmente.
- Si falla Prisma por migraciones inexistentes, usar el build command sin `migrate deploy` hasta versionar migraciones.
- Si falla Cloudinary, revisar variables sin exponer secretos.
- Si Flutter Web queda bloqueado por CORS, revisar `CORS_ORIGIN`.

## Pendientes antes de produccion fuerte

- Auth real en vez de `x-user-id`.
- Migraciones Prisma versionadas.
- Dominio propio.
- Restriccion fina de CORS para Web publica.
- Moderacion de videos.
- Limites de upload por duracion, peso y formato.
- Observabilidad, rate limits y alertas.
