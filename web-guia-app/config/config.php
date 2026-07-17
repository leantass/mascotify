<?php

declare(strict_types=1);

const SITE_NAME = 'Mascotify';
const SITE_TAGLINE = 'Guia oficial de app, soporte y documentos legales';
const SITE_DESCRIPTION = 'Centro web de Mascotify para conocer la app, revisar politicas legales, solicitar soporte y consultar como eliminar una cuenta.';
const SITE_BASE_PATH = '';
const SUPPORT_EMAIL = 'soporte@mascotify.app';

return [
    'site' => [
        'name' => SITE_NAME,
        'tagline' => SITE_TAGLINE,
        'description' => SITE_DESCRIPTION,
        'support_email' => SUPPORT_EMAIL,
        'locale' => 'es_AR',
        'theme_color' => '#123c3a',
    ],
    'navigation' => [
        'home' => ['label' => 'Inicio', 'path' => 'index.php'],
        'privacidad' => ['label' => 'Privacidad', 'path' => 'privacidad.php'],
        'terminos' => ['label' => 'Terminos', 'path' => 'terminos.php'],
        'eliminacion' => ['label' => 'Eliminar cuenta', 'path' => 'eliminacion-de-cuenta.php'],
        'soporte' => ['label' => 'Soporte', 'path' => 'soporte.php'],
        'legal' => ['label' => 'Legal', 'path' => 'legal.php'],
    ],
    'pages' => [
        'home' => [
            'title' => 'Mascotify - Guia oficial de la app',
            'description' => 'Conoce Mascotify, la app para organizar el cuidado de tus mascotas, centralizar informacion importante y acceder a soporte.',
            'canonical' => 'index.php',
        ],
        'privacidad' => [
            'title' => 'Politica de privacidad - Mascotify',
            'description' => 'Consulta como Mascotify trata los datos necesarios para operar la app, dar soporte y proteger la informacion de usuarios y mascotas.',
            'canonical' => 'privacidad.php',
        ],
        'terminos' => [
            'title' => 'Terminos y condiciones - Mascotify',
            'description' => 'Revisa las condiciones generales de uso de Mascotify y las responsabilidades de usuarios y titulares del servicio.',
            'canonical' => 'terminos.php',
        ],
        'eliminacion' => [
            'title' => 'Eliminacion de cuenta - Mascotify',
            'description' => 'Instrucciones para solicitar la eliminacion de una cuenta de Mascotify y entender que informacion puede conservarse por motivos legales.',
            'canonical' => 'eliminacion-de-cuenta.php',
        ],
        'soporte' => [
            'title' => 'Soporte - Mascotify',
            'description' => 'Canales de contacto y guia para recibir ayuda con tu cuenta, mascotas, recordatorios o funcionamiento de Mascotify.',
            'canonical' => 'soporte.php',
        ],
        'legal' => [
            'title' => 'Centro legal - Mascotify',
            'description' => 'Acceso rapido a politicas, terminos, privacidad, eliminacion de cuenta y datos de contacto legal de Mascotify.',
            'canonical' => 'legal.php',
        ],
    ],
];
