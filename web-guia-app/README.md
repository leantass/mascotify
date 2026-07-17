# Mascotify Web Guia App

Landing publica PHP de Mascotify, independiente de la app Flutter y ubicada dentro del repo principal en `web-guia-app/`.

## Estructura

- `config/`: configuracion, placeholders y bootstrap.
- `includes/core/`: helpers, URLs, SEO y renderizado de vistas.
- `includes/layout/`: head, header, navegacion, main y footer.
- `includes/components/`: cards de funciones, plataformas, legales y paneles animados.
- `includes/views/`: home y paginas legales/soporte.
- `assets/`: CSS, JavaScript, imagenes SVG propias e iconos.

## Correr local

Desde `C:\Users\PC\Desktop\Proyecto\mascotify\web-guia-app`:

```powershell
php -S localhost:8088
```

Abrir:

- `http://localhost:8088/`
- `http://localhost:8088/privacidad`
- `http://localhost:8088/terminos`
- `http://localhost:8088/eliminacion-de-cuenta`
- `http://localhost:8088/soporte`
- `http://localhost:8088/legal`
- `http://localhost:8088/#usar-mascotify`

## Abrir web local automaticamente

Comando:

```bat
tooling\open_web_after_task.bat
```

Requisitos:

- PHP 8.1 o superior instalado o disponible en PATH.
- Google Chrome instalado.

URL local:

- `http://localhost:8088/`

El script busca PHP en PATH, XAMPP, Laragon, `C:\php` y `C:\tools\php`. Si PHP existe, levanta o reutiliza el servidor local en el puerto `8088`, abre Google Chrome explicitamente y agrega cache busting con `?cb=...`.

Si PHP no esta instalado:

- Instalar PHP 8.1, 8.2 o superior.
- Agregar PHP al PATH.
- Volver a ejecutar `tooling\open_web_after_task.bat`.

El script no abre Edge ni el navegador predeterminado si Chrome no se encuentra.

## Subir a cPanel

Subir solamente:

- `assets/`
- `config/`
- `includes/`
- `index.php`
- `privacidad.php`
- `terminos.php`
- `eliminacion-de-cuenta.php`
- `soporte.php`
- `legal.php`
- `.htaccess`

No subir:

- `README.md`
- ZIPs locales
- carpetas temporales
- archivos de la app Flutter
- `.env` o secretos
- `web-guia-app-cpanel-upload/` como carpeta contenedora

El ZIP de subida debe contener directamente `index.php`, `assets/`, `config/` e `includes/`, sin una carpeta `web-guia-app` adentro.

## URLs legales esperadas

- `/privacidad`
- `/terminos`
- `/eliminacion-de-cuenta`
- `/soporte`
- `/legal`

## Placeholders pendientes

Reemplazar en `config/config.php` antes de publicar:

- `SITE_BASE_URL = [DOMINIO_MASCOTIFY]`
- `SUPPORT_EMAIL = [EMAIL_SOPORTE_MASCOTIFY]`
- `APP_WEB_URL = [URL_APP_WEB_MASCOTIFY]`
- `GOOGLE_PLAY_URL = [URL_GOOGLE_PLAY_MASCOTIFY]`
- `APP_STORE_URL = [URL_APP_STORE_MASCOTIFY]`
- `MICROSOFT_STORE_URL = [URL_MICROSOFT_STORE_MASCOTIFY]`

Mientras una URL sea placeholder, su card se muestra como `Disponible proximamente` y el boton no navega.

## Regla fija para Codex

Al finalizar cualquier tarea visual o funcional sobre `web-guia-app`, Codex debe ejecutar:

```bat
web-guia-app\tooling\open_web_after_task.bat
```

Y debe reportar:

- URL abierta.
- Navegador usado.
- Si PHP esta disponible.
- Si la web abrio correctamente.
- Si uso cache busting.
- Si no se abrio Edge.
- Si quedo algun error.

No aceptar como terminado un cambio visual si no se abrio la web o si no se explico claramente el bloqueo.
