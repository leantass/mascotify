# Clips demo locales

Los clips demo de Explorar viven en:

- `lib/shared/data/clips_mock_data.dart`
- modelo: `lib/shared/models/social_models.dart` (`ExploreClip`)

La pantalla de Explorar lee los clips a traves de `AppData.exploreClips`, por lo que no hace falta tocar la UI para agregar contenido demo nuevo.

## Como agregar un clip

Agregar un nuevo `ExploreClip` en `ClipsMockData.clips` con:

- `id`: unico, estable y legible, por ejemplo `clip-07`.
- `title`: titulo corto visible en la card.
- `description`: descripcion breve, sin links externos.
- `category`: una de las categorias de `ClipsMockData.categories`.
- `animalType`: tipo de animal o `General`.
- `likes` y `comments`: contadores demo no negativos.
- `sourceLabel`: opcional, por ejemplo `Mascotify demo`.
- `thumbnailAssetPath`: opcional, solo si existe un asset propio.
- `videoAssetPath`: opcional, solo si existe un video propio.
- `isDemoContent`: dejar `true` para contenido demo/local.

## Assets propios

Las carpetas preparadas son:

- `assets/images/clips/`
- `assets/videos/clips/`

Usar paths relativos a la app, por ejemplo:

```dart
thumbnailAssetPath: 'assets/images/clips/milo-qr.png',
videoAssetPath: 'assets/videos/clips/milo-qr.mp4',
```

Si no hay `videoAssetPath`, la UI muestra un placeholder seguro con indicador de play y el texto `Clip demo local`.

## Categorias

Categorias disponibles:

- `Todos`
- `Tiernos`
- `Bloopers`
- `Consejos`
- `Rescates`
- `Profesionales`

`Todos` se usa como filtro general. Los clips individuales deben usar una categoria especifica, no `Todos`.

## Que no hacer

- No usar videos con copyright.
- No usar links externos random.
- No embeber TikTok, Instagram u otros servicios externos.
- No cargar archivos pesados sin revisar peso, licencia y necesidad real.
- No depender de internet.
- No hacer scraping.

## Como validar

Ejecutar:

```powershell
C:\src\flutter\bin\flutter.bat test
C:\src\flutter\bin\flutter.bat build web
tooling\git_flow\check_local.bat
```

Para validacion completa de fase, tambien ejecutar:

```powershell
C:\src\flutter\bin\flutter.bat analyze
```
