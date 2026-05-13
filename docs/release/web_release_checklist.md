# Mascotify - Web release checklist

## Build

- [ ] `C:\src\flutter\bin\flutter.bat analyze`.
- [ ] `C:\src\flutter\bin\flutter.bat test`.
- [ ] `C:\src\flutter\bin\flutter.bat build web`.
- [ ] Verificar `build/web/index.html`.
- [ ] Probar build con servidor estatico local.
- [ ] Generar zip demo si corresponde con `tooling/demo/package_web_demo.bat`.

## Metadata

- [ ] Revisar `web/index.html`.
- [ ] Revisar `web/manifest.json`.
- [ ] Confirmar favicon.
- [ ] Confirmar iconos PWA.
- [ ] Confirmar texto de descripcion.
- [ ] Confirmar `theme_color`.
- [ ] Confirmar politica de privacidad y soporte publicos.

## Deploy futuro

- [ ] Elegir hosting: Vercel, Netlify, Firebase Hosting, Cloudflare Pages o propio.
- [ ] Configurar dominio.
- [ ] Configurar HTTPS.
- [ ] Configurar cache headers.
- [ ] Validar rutas y refresh.
- [ ] Validar mobile web.
- [ ] Validar desktop web.

## Riesgos

- [ ] No exponer variables privadas en build web.
- [ ] No depender de backend local para experiencia basica.
- [ ] Revisar privacidad si se conecta backend productivo.

