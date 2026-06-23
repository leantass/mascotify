<?php

declare(strict_types=1);

require __DIR__ . '/config/bootstrap.php';

$title = 'Mascotify | Indice legal';
$description = 'Indice legal del sitio publico de Mascotify.';
$canonical = canonical_url('/legal');
$robots = 'index,follow';
$ogTitle = $title;
$ogDescription = $description;
$ogImage = absolute_url('/assets/images/mascotify-logo-real.png');
$ogType = 'website';
$schemaMarkup = [
    build_web_page_schema([
        'title' => $title,
        'description' => $description,
        'url' => $canonical,
    ]),
];

renderPage(
    VIEWS_PATH . '/legal-content.php',
    compact('title', 'description', 'canonical', 'robots', 'ogTitle', 'ogDescription', 'ogImage', 'ogType', 'schemaMarkup')
);
