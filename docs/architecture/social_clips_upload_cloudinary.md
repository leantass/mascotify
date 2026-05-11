# Social Clips Upload With Cloudinary

## Objetivo

Esta fase agrega una primera ruta real para subir videos propios de Clips usando Cloudinary como proveedor de media. Cloudinary se usa por su soporte de video, CDN, transformaciones futuras y uploads firmados sin exponer secretos en Flutter.

La app conserva fallback local: Explorar y Clips siguen funcionando aunque backend o Cloudinary no esten configurados.

## Variables De Entorno

Configurar en backend, sin commitear valores reales:

```text
CLOUDINARY_CLOUD_NAME=
CLOUDINARY_API_KEY=
CLOUDINARY_API_SECRET=
CLOUDINARY_UPLOAD_FOLDER=mascotify/clips
```

`CLOUDINARY_API_SECRET` solo vive en backend. No debe ir a Flutter, GitHub, builds web/mobile ni logs.

## Flujo Firmado

1. Flutter abre el formulario "Subir clip".
2. Flutter selecciona un video propio con `file_picker`.
3. Flutter pide firma a `POST /api/v1/clips/upload-signature` con `x-user-id`.
4. Backend genera firma SHA-1 para Cloudinary usando `CLOUDINARY_API_SECRET`.
5. Backend devuelve `cloudName`, `apiKey`, `timestamp`, `signature`, `folder`, `resourceType` y `uploadUrl`.
6. Flutter sube el archivo a Cloudinary con multipart form.
7. Cloudinary responde `secure_url`, `public_id` y metadata.
8. Flutter llama `POST /api/v1/clips` con `videoUrl`, `thumbnailUrl`, `cloudinaryPublicId` y metadata del clip.
9. El feed remoto puede mostrar el clip subido.

## Backend

Backend agrega:

- `CloudinaryService` para generar firmas.
- `POST /api/v1/clips/upload-signature`.
- Campo `cloudinaryPublicId` en `Clip`.
- Soporte de `cloudinaryPublicId` en create/update/feed.

Si Cloudinary no esta configurado, el endpoint responde error controlado `MEDIA_UPLOAD_DISABLED`.

## Flutter

Flutter agrega:

- boton "Subir clip" en Clips.
- formulario con titulo, descripcion, animal y categoria.
- seleccion de video con `file_picker`.
- cliente preparado para firma, upload a Cloudinary y creacion del clip.
- feedback seguro si backend/Cloudinary no estan disponibles.

No hay upload real en tests. Se usan fakes.

## Limites Recomendados

- Duracion maxima inicial sugerida: 60 segundos.
- Tamano maximo inicial sugerido: 100 MB.
- Formatos sugeridos: `mp4`, `mov`, `webm`, segun soporte por plataforma.
- Rechazar archivos vacios y formatos no soportados antes de subir.
- Revisar costos/cuotas de Cloudinary antes de abrir la funcion a todos los usuarios.

## Seguridad

- No usar unsigned upload como solucion final.
- No exponer `CLOUDINARY_API_SECRET`.
- No subir videos externos o con copyright.
- Agregar auth real antes de produccion.
- Agregar rate limits y auditoria de uploads.

## Pendientes

- Cargar credenciales reales en entorno seguro.
- Probar upload real con cuenta Cloudinary.
- Validar duracion/tamano/formato antes del upload.
- Generar thumbnails automaticos.
- Moderacion y reportes.
- Comentarios.
- Algoritmo de recomendacion.
- Auth real y permisos por autor.
