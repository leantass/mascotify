<?php

declare(strict_types=1);

require __DIR__ . '/config/bootstrap.php';

$title = 'Mascotify | Cuida, conecta y protege a tus mascotas';
$description = 'Mascotify reune perfiles de mascotas, QR seguro, salud, comunidad, clips y futuras funciones de matching.';
$canonical = canonical_url('/');
$robots = 'index,follow';
$ogTitle = $title;
$ogDescription = $description;
$ogImage = absolute_url('/assets/images/mascotify-logo-real.png');
$ogType = 'website';
$schemaMarkup = [
    require SCHEMA_PATH . '/organization.php',
    require SCHEMA_PATH . '/website.php',
    require SCHEMA_PATH . '/software-application.php',
];

renderPage(
    VIEWS_PATH . '/home-content.php',
    compact('title', 'description', 'canonical', 'robots', 'ogTitle', 'ogDescription', 'ogImage', 'ogType', 'schemaMarkup')
);
