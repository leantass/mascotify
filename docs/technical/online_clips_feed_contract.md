# Online Clips Feed Contract

## Endpoint futuro

```http
GET /api/v1/clips/feed?source=all&category=bloopers&species=dog
```

La app Flutter debe llamar al backend propio de Mascotify. No debe llamar directo a Pexels, Pixabay u otros proveedores que requieran API key secreta.

## Respuesta

```json
{
  "clips": [
    {
      "id": "clip_123",
      "title": "Bloopers de perros",
      "caption": "Un perro aprendiendo un truco nuevo.",
      "videoUrl": "https://cdn.example.com/clips/clip_123.mp4",
      "thumbnailUrl": "https://cdn.example.com/clips/clip_123.jpg",
      "sourceType": "licensedStock",
      "sourceProvider": "Pexels",
      "sourceUrl": "https://www.pexels.com/video/...",
      "licenseLabel": "Pexels License",
      "attributionText": "Video by Creator Name on Pexels",
      "attributionUrl": "https://www.pexels.com/@creator",
      "providerClipId": "pexels_123",
      "category": "Bloopers",
      "species": "Perro",
      "tags": ["dog", "funny", "bloopers"],
      "durationSeconds": 14,
      "publishedAt": "2026-06-10T12:00:00Z",
      "fetchedAt": "2026-06-10T06:00:00Z",
      "expiresAt": "2026-07-10T06:00:00Z",
      "isExternalContent": true,
      "isCurated": true,
      "moderationStatus": "published",
      "contentOriginLabel": "Fuente: Pexels"
    }
  ],
  "updatedAt": "2026-06-10T06:00:00Z",
  "nextCursor": "cursor_456"
}
```

`items` se acepta temporalmente por compatibilidad, pero `clips` es la forma preferida.

## Campos de origen
- `sourceType`: `userUpload`, `curatedOnline`, `licensedStock`, `seededDemo`, `sponsor`.
- `sourceProvider`: `Mascotify`, `Pexels`, `Pixabay`, `CreatorPartner`, `Sponsor`, `Demo`.
- `sourceUrl`: pagina canonica del proveedor o creador.
- `licenseLabel`: licencia aplicable.
- `attributionText` y `attributionUrl`: atribucion visible o enlazable si el proveedor la exige.
- `providerClipId`: id original para auditoria y deduplicacion.

## Daily Job
El backend puede ejecutar un job diario que:
- consulta fuentes autorizadas
- usa API keys solo en servidor
- busca `dog bloopers`, `funny dogs`, `pets funny`, `cats funny`, `dog training`, `pet care`, `adoption pets`
- prioriza duracion corta, formato vertical, resolucion adecuada y contenido apto
- rechaza contenido sin licencia clara
- evita rehostear si la licencia no lo permite
- marca estados `detected`, `approved`, `rejected`, `published`, `expired`
- publica solamente clips aprobados o permitidos por reglas

## Cache y Fallback
El backend deberia cachear metadata del feed y devolver `updatedAt`/`nextCursor`. Flutter mantiene fallback local si:
- el backend no esta configurado
- no hay conexion
- el endpoint responde vacio
- ocurre error temporal

La UI debe mostrar:
- `Cargando clips...` durante carga inicial
- `Buscando videos nuevos...` si se activa refresh online
- `Sin conexion. Te mostramos clips guardados.` cuando entra fallback offline
- `No pudimos actualizar clips ahora.` cuando el feed online falla

## Seguridad
- No incluir API keys en Flutter.
- No incluir secretos en `.env` versionado.
- No fingir contenido externo como uploads reales de usuarios.
- No usar scraping ni descargas no autorizadas.
