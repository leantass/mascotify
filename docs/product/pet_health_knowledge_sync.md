# Mascotify - Actualización futura de conocimiento sanitario

## Objetivo

Mantener actualizada la base de conocimiento de vacunas y salud preventiva sin convertir datos externos en recomendaciones automáticas.

La app debe orientar y organizar la libreta sanitaria, pero no reemplaza la indicación de un veterinario.

## Arquitectura futura

1. El backend mantiene un catálogo versionado de reglas sanitarias.
2. Las fuentes oficiales o profesionales se cargan en una tabla de fuentes.
3. Un job de actualización revisa novedades en fuentes permitidas.
4. Las novedades quedan en estado `detected`.
5. Un admin o veterinario revisa la novedad.
6. Si se aprueba, se publica una nueva versión del catálogo.
7. La app descarga solamente versiones publicadas.
8. Los usuarios reciben aviso si la nueva versión afecta a sus mascotas.

## Estados de una novedad

- `detected`
- `under_review`
- `approved`
- `rejected`
- `published`
- `deprecated`

## Regla de seguridad

La app nunca recomienda automáticamente información detectada pero no aprobada.

Una novedad detectada puede servir para revisión interna, pero no debe aparecer como guía sanitaria para usuarios hasta estar aprobada y publicada.

## Fuentes sugeridas

- Guías WSAVA para perros y gatos.
- Guías AAHA para perros.
- SENASA Argentina para antirrábica y normativa local.
- AAEP para equinos.
- Merck Veterinary Manual para especies específicas.
- Organismos oficiales nacionales o regionales.
- Asociaciones veterinarias reconocidas.

## Fuentes no aptas para recomendación automática

- Blogs sin autoridad.
- Redes sociales.
- Foros.
- Contenido generado por usuarios.
- Páginas comerciales sin respaldo técnico.

## Contrato futuro de backend

Endpoints documentados, no implementados en esta fase:

```http
GET /api/v1/pet-health/knowledge/latest?country=AR
GET /api/v1/pet-health/knowledge/:version
GET /api/v1/pet-health/updates
POST /api/v1/admin/pet-health/knowledge
POST /api/v1/admin/pet-health/updates/:id/approve
POST /api/v1/admin/pet-health/updates/:id/reject
```

Respuesta esperada:

```json
{
  "version": "AR-2026.05",
  "country": "AR",
  "publishedAt": "2026-05-20T00:00:00.000Z",
  "reviewedBy": "Equipo veterinario",
  "rules": [],
  "sourceSummary": "Fuentes oficiales y profesionales revisadas",
  "disclaimer": "Orientativo. Confirmar siempre con veterinario."
}
```

## Fuera de alcance actual

- Scraping real.
- Backend de actualización sanitaria.
- Panel admin veterinario.
- Push real con Firebase/FCM/APNs.
- Publicación automática de recomendaciones nuevas.
