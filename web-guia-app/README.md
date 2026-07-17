# Mascotify Web Guia App

Web PHP independiente para informacion publica de Mascotify, soporte, privacidad, terminos, eliminacion de cuenta y centro legal.

## Estructura

- `config/`: configuracion y bootstrap de la app.
- `includes/core/`: helpers y SEO.
- `includes/layout/`: layout compartido.
- `includes/components/`: componentes reutilizables.
- `includes/views/`: contenido de cada pagina.
- `assets/`: estilos, JavaScript e imagenes.

## Validacion local

```powershell
php -l index.php
php -l privacidad.php
php -l terminos.php
php -l eliminacion-de-cuenta.php
php -l soporte.php
php -l legal.php
php -l config\config.php
php -l config\bootstrap.php
php -l includes\core\functions.php
php -l includes\core\seo.php
php -l includes\layout\head.php
php -l includes\layout\main.php
php -l includes\layout\header.php
php -l includes\layout\footer.php
php -l includes\layout\navigation.php
```

## Servidor local

```powershell
php -S localhost:8088
```
