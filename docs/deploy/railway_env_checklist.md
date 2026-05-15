# Mascotify - Checklist de variables Railway

Configurar estas variables en el servicio backend de Railway. No commitear `.env` real ni copiar secretos al repo.

| Variable | Ejemplo | Secreta | Notas |
| --- | --- | --- | --- |
| `NODE_ENV` | `production` | No | Define modo runtime del backend. |
| `DATABASE_URL` | `postgresql://...` | Si | La entrega Railway PostgreSQL. Debe vivir solo como env var del proveedor. |
| `CLOUDINARY_CLOUD_NAME` | `mi-cloud` | Config sensible | No es tan secreta como el secret, pero tratarla como configuracion privada del entorno. |
| `CLOUDINARY_API_KEY` | `123456789` | Config sensible | No ponerla en Flutter ni en docs publicas con valor real. |
| `CLOUDINARY_API_SECRET` | `********` | Si | Nunca debe exponerse al frontend/mobile. |
| `CLOUDINARY_UPLOAD_FOLDER` | `mascotify/clips` | No | Carpeta destino para clips en Cloudinary. |
| `CORS_ORIGIN` | `*` | No | Para primera prueba mobile/web. En produccion, usar origenes web reales separados por coma. |

## Variables opcionales

| Variable | Ejemplo | Secreta | Notas |
| --- | --- | --- | --- |
| `PORT` | `4000` | No | Railway la inyecta automaticamente. No hace falta definirla normalmente. |

## Verificacion rapida

- [ ] `DATABASE_URL` esta en el servicio backend, no solo en PostgreSQL.
- [ ] `CLOUDINARY_API_SECRET` existe y no aparece en Flutter.
- [ ] `CORS_ORIGIN` permite la URL Web que se va a usar.
- [ ] `NODE_ENV=production`.
- [ ] El healthcheck publico responde en `/health`.
