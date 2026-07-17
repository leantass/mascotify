<?php

declare(strict_types=1);

const SITE_NAME = 'Mascotify';
const SITE_DESCRIPTION = 'Mascotify ayuda a cuidar, conectar y proteger mascotas con perfiles, QR seguro, salud, comunidad, clips y matching.';
const SITE_BASE_URL = '[DOMINIO_MASCOTIFY]';
const SITE_BASE_PATH = '';
const SUPPORT_EMAIL = '[EMAIL_SOPORTE_MASCOTIFY]';
const APP_WEB_URL = '[URL_APP_WEB_MASCOTIFY]';
const GOOGLE_PLAY_URL = '[URL_GOOGLE_PLAY_MASCOTIFY]';
const APP_STORE_URL = '[URL_APP_STORE_MASCOTIFY]';
const MICROSOFT_STORE_URL = '[URL_MICROSOFT_STORE_MASCOTIFY]';
const ASSETS_VERSION = '20260717-logo-exact-light-single-2';

return [
    'site' => [
        'name' => SITE_NAME,
        'description' => SITE_DESCRIPTION,
        'base_url' => SITE_BASE_URL,
        'support_email' => SUPPORT_EMAIL,
        'locale' => 'es_AR',
        'theme_color' => '#ff5c8a',
    ],
    'navigation' => [
        ['label' => 'Inicio', 'href' => '/'],
        ['label' => 'Funciones', 'href' => '/#funciones'],
        ['label' => 'Seguridad', 'href' => '/#seguridad'],
        ['label' => 'App', 'href' => '/#usar-mascotify'],
        ['label' => 'Legal', 'href' => '/legal'],
        ['label' => 'Soporte', 'href' => '/soporte'],
    ],
    'platforms' => [
        [
            'badge' => 'WEB',
            'title' => 'Mascotify Web',
            'text' => 'Accede a Mascotify desde el navegador cuando la experiencia web este disponible.',
            'button' => 'Abrir web',
            'url' => APP_WEB_URL,
        ],
        [
            'badge' => 'ANDROID',
            'title' => 'Google Play',
            'text' => 'Descarga Mascotify para Android desde Google Play cuando este publicada.',
            'button' => 'Descargar en Google Play',
            'url' => GOOGLE_PLAY_URL,
        ],
        [
            'badge' => 'IOS',
            'title' => 'App Store',
            'text' => 'Instala Mascotify en iPhone cuando la version iOS este disponible.',
            'button' => 'Descargar en App Store',
            'url' => APP_STORE_URL,
        ],
        [
            'badge' => 'WINDOWS',
            'title' => 'Microsoft Store',
            'text' => 'Usa Mascotify en Windows cuando la version de escritorio este publicada.',
            'button' => 'Descargar para Windows',
            'url' => MICROSOFT_STORE_URL,
        ],
    ],
];
