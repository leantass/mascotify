<?php

declare(strict_types=1);

$schema = [
    '@context' => 'https://schema.org',
    '@type' => 'SoftwareApplication',
    'name' => SITE_NAME,
    'applicationCategory' => 'LifestyleApplication',
    'operatingSystem' => 'Web, iOS',
    'description' => SITE_DESCRIPTION,
    'url' => SITE_BASE_URL,
];

if (!is_placeholder_url(APP_WEB_URL)) {
    $schema['applicationSubCategory'] = 'Pet Care';
    $schema['installUrl'] = APP_WEB_URL;
}

if (!is_placeholder_url(APP_STORE_URL)) {
    $schema['downloadUrl'] = APP_STORE_URL;
}

return $schema;
