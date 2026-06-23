<?php

declare(strict_types=1);

require __DIR__ . '/config/bootstrap.php';

$title = 'Mascotify | Eliminacion de cuenta y datos';
$description = 'Instrucciones preliminares para solicitar eliminacion de cuenta y datos en Mascotify.';
$canonical = canonical_url('/eliminacion-de-cuenta');
$robots = 'index,follow';
$ogTitle = $title;
$ogDescription = $description;
$ogImage = absolute_url('/assets/images/mascotify-logo-real.png');
$ogType = 'article';
$schemaMarkup = [
    build_web_page_schema([
        'title' => $title,
        'description' => $description,
        'url' => $canonical,
    ]),
];

renderPage(
    VIEWS_PATH . '/eliminacion-de-cuenta-content.php',
    compact('title', 'description', 'canonical', 'robots', 'ogTitle', 'ogDescription', 'ogImage', 'ogType', 'schemaMarkup')
);
