<?php

declare(strict_types=1);

require __DIR__ . '/config/bootstrap.php';

$title = 'Mascotify | Soporte';
$description = 'Canales de soporte preliminares de Mascotify.';
$canonical = canonical_url('/soporte');
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
    VIEWS_PATH . '/soporte-content.php',
    compact('title', 'description', 'canonical', 'robots', 'ogTitle', 'ogDescription', 'ogImage', 'ogType', 'schemaMarkup')
);
