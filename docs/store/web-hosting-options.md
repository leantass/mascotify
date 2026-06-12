# Web hosting options - Mascotify

No se detecto hosting frontend productivo configurado para esta preparacion.
El backend contiene configuracion Railway, pero eso no publica la web Flutter.

## Opciones posibles

- GitHub Pages: simple para sitio estatico si el repo decide usar Pages.
- Firebase Hosting: buena opcion para Flutter web y cache control.
- Vercel o Netlify: utiles para build web estatico.
- Hosting propio/CDN: viable si hay dominio, HTTPS y pipeline definido.

## Requisitos antes de publicar web

- Definir dominio y entorno.
- Configurar pipeline documentado.
- Publicar politica de privacidad y terminos con URL estable.
- Confirmar cache busting y service worker.
- No subir secretos al repo.

## Estado actual

- Build web release: preparado localmente.
- Review local: disponible por `tooling/demo`.
- Deploy web publico: pendiente de configuracion.
