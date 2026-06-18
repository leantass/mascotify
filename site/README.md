# Mascotify Public Website

Este micrositio estatico reune una landing publica de Mascotify y las paginas
legales minimas necesarias para futura publicacion en stores y web.

## Rutas disponibles

- `index.html`
- `privacidad.html`
- `terminos.html`
- `eliminacion-de-cuenta.html`
- `soporte.html`
- `legal.html`

## URL publica principal

Mientras no se confirme el dominio final, usar este placeholder unico:

- `[URL_PUBLICA_MASCOTIFY]`

Debe reemplazarse antes de publicar en Play Console, App Store Connect o
enlazarlo desde la app.

## Acceso a Mascotify

La seccion `#usar-mascotify` concentra los accesos a la app:

- Mascotify Web: `[URL_APP_WEB_MASCOTIFY]`
- App Store: `[URL_APP_STORE_MASCOTIFY]`

Uso:

- Boton "Ir a la app" en header
- CTA principal del hero
- Link en footer
- Seccion comercial "Usa Mascotify" dentro de `index.html`

Pendientes:

- Reemplazar `[URL_APP_WEB_MASCOTIFY]` cuando exista la URL final de la app web.
- Reemplazar `[URL_APP_STORE_MASCOTIFY]` cuando la app este publicada en App Store.
- Si todavia no existe link real, mantener el estado "Proximamente".

## URLs legales

- `[URL_PUBLICA_MASCOTIFY]/privacidad.html`
- `[URL_PUBLICA_MASCOTIFY]/terminos.html`
- `[URL_PUBLICA_MASCOTIFY]/eliminacion-de-cuenta.html`
- `[URL_PUBLICA_MASCOTIFY]/soporte.html`
- `[URL_PUBLICA_MASCOTIFY]/legal.html`

## Como abrir localmente

Opcion simple:

- Abrir `index.html` directamente en el navegador.

Opcion servidor:

```bash
python -m http.server 8088
```

Alternativa en Windows si `python` no esta disponible:

```bash
py -m http.server 8088
```

Luego abrir:

- `http://localhost:8088/index.html`

## Pendientes antes de publicar

- Confirmar dominio final.
- Completar responsable legal.
- Completar email de soporte.
- Hacer revision legal.
- Revisar textos finales segun funciones reales activas.
- Verificar que todas las URLs respondan publicamente.
- Conectar formularios si se desea.

## Estado de esta fase

No hay deploy en esta fase. El objetivo es dejar la base visual, legal y
tecnica lista para una publicacion futura.
