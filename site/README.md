# Mascotify Public Website

Este micrositio estático reúne una landing pública de Mascotify y las páginas legales mínimas
necesarias para futura publicación en stores y web.

## Rutas disponibles

- `index.html`
- `privacidad.html`
- `terminos.html`
- `eliminacion-de-cuenta.html`
- `soporte.html`
- `legal.html`

## URL pública principal

Mientras no se confirme el dominio final, usar este placeholder único:

- `[URL_PUBLICA_MASCOTIFY]`

Debe reemplazarse antes de publicar en Play Console, App Store Connect o enlazarlo desde la app.

## URL de la app

URL actual:

- `[URL_APP_MASCOTIFY]`

Uso:

- Botón "Ir a la app" en header
- CTA principal del hero
- Link en footer

Pendiente:

- Reemplazar `[URL_APP_MASCOTIFY]` por la URL final cuando la app esté publicada o cuando exista una URL web funcional definitiva.

## URLs legales

- `[URL_PUBLICA_MASCOTIFY]/privacidad.html`
- `[URL_PUBLICA_MASCOTIFY]/terminos.html`
- `[URL_PUBLICA_MASCOTIFY]/eliminacion-de-cuenta.html`
- `[URL_PUBLICA_MASCOTIFY]/soporte.html`
- `[URL_PUBLICA_MASCOTIFY]/legal.html`

## Cómo abrir localmente

Opción simple:

- Abrir `index.html` directamente en el navegador.

Opción servidor:

```bash
python -m http.server 8088
```

Alternativa en Windows si `python` no está disponible:

```bash
py -m http.server 8088
```

Luego abrir:

- `http://localhost:8088/index.html`

## Pendientes antes de publicar

- Confirmar dominio final.
- Completar responsable legal.
- Completar email de soporte.
- Hacer revisión legal.
- Revisar textos finales según funciones reales activas.
- Verificar que todas las URLs respondan públicamente.
- Conectar formularios si se desea.

## Estado de esta fase

No hay deploy en esta fase. El objetivo es dejar la base visual, legal y técnica lista para una publicación futura.
