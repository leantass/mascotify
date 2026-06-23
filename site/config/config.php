<?php

declare(strict_types=1);

define('APP_ENV', getenv('APP_ENV') ?: 'development');
define('IS_PRODUCTION', APP_ENV === 'production');

define('SITE_NAME', 'Mascotify');
define('SITE_TAGLINE', 'Cuida, conecta y protege a tus mascotas');
define(
    'SITE_DESCRIPTION',
    'Mascotify reune perfiles de mascotas, QR seguro, salud, comunidad, clips y futuras funciones de matching.'
);
define('SITE_DOMAIN', '[DOMINIO_MASCOTIFY]');
define('SITE_BASE_URL', 'https://[DOMINIO_MASCOTIFY]');
define('SITE_LOCALE', 'es_AR');
define('SITE_AUTHOR', 'Mascotify');
define('SUPPORT_EMAIL', '[EMAIL_SOPORTE_MASCOTIFY]');
define('APP_WEB_URL', '[URL_APP_WEB_MASCOTIFY]');
define('APP_STORE_URL', '[URL_APP_STORE_MASCOTIFY]');
define('ASSETS_VERSION', '20260623-php');
define('DEFAULT_OG_IMAGE', '/assets/images/mascotify-logo-real.png');
define('PRIMARY_THEME_COLOR', '#66CCCC');
