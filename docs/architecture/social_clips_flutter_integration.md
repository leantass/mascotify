# Social Clips Flutter Integration

## Objetivo

Flutter ya puede consumir el backend social de Clips de Mascotify de forma opcional. La app intenta cargar el feed remoto y, si el backend no responde o devuelve un error, mantiene la experiencia demo/local existente.

Esta integracion no reemplaza los clips demo y no conecta upload, storage ni streaming avanzado.

## Base URL

La URL base esta centralizada en `AppEnvironment.socialClipsApiBaseUrl`.

Default local:

```text
http://localhost:4000/api/v1
```

Se puede cambiar en build time con:

```text
--dart-define=MASCOTIFY_CLIPS_API_BASE_URL=https://example.com/api/v1
```

No hay secretos ni `.env` nuevo en esta fase.

## Cliente API

El cliente Flutter vive en:

```text
lib/features/explore/data/social_clips_api_client.dart
```

Implementa:

- `fetchFeed`
- `likeClip`
- `unlikeClip`
- `shareClip`
- `followUser`
- `unfollowUser`

Usa JSON REST contra `/api/v1` y el header temporal:

```http
x-user-id: <app-user-id>
```

Este header es temporal hasta integrar auth real. No representa seguridad productiva.

## Repository Y Fallback

La capa:

```text
lib/features/explore/data/social_clips_repository.dart
```

intenta cargar clips desde backend. Si falla por timeout, conexion, response invalida o error HTTP, devuelve `ClipsMockData` como fallback local.

La UI puede distinguir:

- `remote`
- `localFallback`

Cuando se usa fallback, Explorar muestra un aviso no invasivo:

```text
Mostrando clips demo locales
```

## UI

`ExploreScreen` mantiene la seccion Clips existente, filtros y visor inmersivo. La pantalla arranca con clips locales seguros y luego reemplaza por feed remoto si esta disponible.

Acciones conectadas cuando el clip viene del backend:

- like/unlike
- share
- follow/unfollow del creador

Si el clip es demo local, las acciones siguen siendo locales y no dependen del backend.

## Tests

Los tests de integracion usan fakes y no requieren un backend real corriendo. Cubren feed remoto, fallback local, acciones remotas, filtros, visor y mobile viewport.

## Pendientes

- Auth real y reemplazo de `x-user-id`.
- Upload real de videos.
- Storage real para videos y thumbnails.
- Cache local del feed remoto.
- Paginacion avanzada e infinite scroll.
- Moderacion y reportes.
- Comentarios.
- Algoritmo de recomendacion.
