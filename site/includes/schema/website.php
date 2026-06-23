<?php

declare(strict_types=1);

return [
    '@context' => 'https://schema.org',
    '@type' => 'WebSite',
    'name' => SITE_NAME,
    'url' => SITE_BASE_URL,
    'description' => SITE_DESCRIPTION,
    'inLanguage' => 'es-AR',
    'publisher' => [
        '@type' => 'Organization',
        'name' => SITE_NAME,
    ],
];
