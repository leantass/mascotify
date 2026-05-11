# Social Clips Backend

## Objetivo

Esta fase agrega la base backend para convertir Clips de Mascotify en una experiencia social tipo Reels/TikTok, preparada para videos propios subidos por usuarios en fases futuras.

La implementacion actual cubre metadata, feed, likes, follows y shares. No sube archivos, no reproduce video avanzado y no conecta Flutter todavia.

## Auth Temporal

Los endpoints mutables usan el header temporal:

```http
x-user-id: user_123
```

Este header solo permite probar backend local y tests automatizados hasta integrar auth real. No simula seguridad productiva, no reemplaza `Authorization: Bearer <token>` y no debe usarse como control definitivo de permisos.

## Modelos

### Clip

Representa la metadata de un video social.

Campos principales:

- `id`
- `authorId`
- `title`
- `description`
- `animalType`
- `category`
- `videoUrl`
- `thumbnailUrl`
- `durationSeconds`
- `likesCount`
- `commentsCount`
- `sharesCount`
- `status`: `ACTIVE`, `HIDDEN`, `REPORTED`, `DELETED`
- `createdAt`
- `updatedAt`

`videoUrl` y `thumbnailUrl` son strings de metadata por ahora. En una fase futura apuntaran a storage propio o proveedor elegido.

### ClipLike

Guarda likes por usuario y clip.

- `clipId`
- `userId`
- `createdAt`
- indice unico por `clipId + userId`

El indice evita duplicar likes del mismo usuario.

### UserFollow

Guarda relaciones de seguimiento entre usuarios.

- `followerId`
- `followingId`
- `createdAt`
- indice unico por `followerId + followingId`

El indice evita duplicar follows.

## Endpoints

Base path: `/api/v1`.

### Clips

- `GET /clips/feed`
- `GET /clips/:id`
- `POST /clips`
- `PATCH /clips/:id`
- `DELETE /clips/:id`

`POST /clips` requiere `x-user-id` y crea el clip con ese usuario como autor.

`GET /clips/feed` devuelve clips activos ordenados por recientes, con paginacion simple:

```json
{
  "items": [
    {
      "id": "clip_123",
      "authorId": "user_123",
      "title": "Rescate con final feliz",
      "description": "Metadata inicial del clip.",
      "animalType": "Perro",
      "category": "Rescates",
      "videoUrl": "mascotify://videos/rescate.mp4",
      "thumbnailUrl": "assets/images/clips/rescate.png",
      "durationSeconds": 24,
      "likesCount": 10,
      "commentsCount": 0,
      "sharesCount": 2,
      "status": "ACTIVE",
      "author": {
        "id": "user_123",
        "displayName": "Familia Demo",
        "avatarUrl": null
      },
      "isLiked": true,
      "isFollowingAuthor": false
    }
  ],
  "pageInfo": {
    "nextCursor": null,
    "hasNextPage": false
  }
}
```

### Likes

- `POST /clips/:id/like`
- `DELETE /clips/:id/like`

Ambos requieren `x-user-id`. Like es idempotente a nivel funcional: repetirlo no duplica contador.

### Follows

- `POST /users/:id/follow`
- `DELETE /users/:id/follow`

Ambos requieren `x-user-id`. El `:id` es el usuario a seguir o dejar de seguir.

### Share

- `POST /clips/:id/share`

Incrementa `sharesCount`. No invoca share nativo del sistema ni servicios externos.

## Storage Futuro

Esta fase no implementa storage ni upload real. La evolucion esperada es:

1. Agregar endpoint de upload con limites de peso, duracion y tipo MIME.
2. Guardar videos propios en storage elegido.
3. Generar thumbnails propios.
4. Reemplazar `videoUrl` y `thumbnailUrl` con URLs firmadas o rutas publicas controladas.
5. Agregar moderacion antes de publicar contenido.

## Conexion Futura Con Flutter

Flutter todavia no consume estos endpoints. La siguiente fase deberia agregar una fuente remota que respete la fachada actual de datos de la app, manteniendo mocks/local como fallback o demo.

El visor inmersivo podra leer:

- feed paginado desde `GET /clips/feed`
- estado `isLiked`
- estado `isFollowingAuthor`
- contadores `likesCount` y `sharesCount`

## Pendientes

- Auth real y permisos por autor.
- Subida real de video.
- Storage propio o proveedor externo.
- Thumbnails definitivos.
- Moderacion y reportes.
- Comentarios.
- Algoritmo de recomendacion.
- Limites de duracion, peso y frecuencia.
- Observabilidad y rate limiting.
