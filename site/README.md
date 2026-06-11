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

## URLs futuras esperadas

- `https://[DOMINIO]/privacidad`
- `https://[DOMINIO]/terminos`
- `https://[DOMINIO]/eliminacion-de-cuenta`
- `https://[DOMINIO]/soporte`

## Pendientes antes de publicar

- Completar responsable legal.
- Completar email de soporte.
- Completar dominio.
- Hacer revisión legal.
- Revisar textos finales según funciones reales activas.
- Conectar formularios si se desea.

## Estado de esta fase

No hay deploy en esta fase. El objetivo es dejar la base visual, legal y técnica lista para una publicación futura.
