# Mascotify Public Website

## Stack

* PHP
* HTML
* Tailwind CSS compilado
* JavaScript Vanilla
* .htaccess

## Arquitectura

Carpetas principales:

* `config`: constantes globales y bootstrap del entorno.
* `includes/core`: helpers globales y funciones SEO.
* `includes/layout`: head, header, navigation, footer, cookie banner y layout principal.
* `includes/components`: piezas reutilizables de cards, secciones y accesos.
* `includes/schema`: arrays PHP para JSON-LD.
* `includes/views`: contenido real de cada pagina.
* `assets`: CSS, JS, imagenes, favicon e iconos.

## Desarrollo local

Desde `site/`:

```bash
php -S localhost:8088 router.php
```

CSS:

```bash
npm install
npm run build:css
npm run watch:css
```

## Rutas

* `/`
* `/privacidad`
* `/terminos`
* `/eliminacion-de-cuenta`
* `/soporte`
* `/legal`

## Acceso a Mascotify

La seccion `#usar-mascotify` contempla:

* Mascotify Web: `[URL_APP_WEB_MASCOTIFY]`
* App Store: `[URL_APP_STORE_MASCOTIFY]`
* Play Store: `[URL_PLAY_STORE_MASCOTIFY]`

## Deploy cPanel

Subir el contenido de `site/` al document root del dominio.

No subir:

* `node_modules`
* archivos temporales
* backups locales
* ZIPs
* builds Flutter

## Pendientes

* confirmar dominio final
* confirmar URL de app web
* confirmar URL de App Store
* confirmar URL de Play Store
* completar email soporte
* revision legal
* validacion SSL/HTTPS en cPanel
