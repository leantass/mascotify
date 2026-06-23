<?php

declare(strict_types=1);

return [
    '@context' => 'https://schema.org',
    '@type' => 'Organization',
    'name' => SITE_NAME,
    'url' => SITE_BASE_URL,
    'description' => SITE_DESCRIPTION,
    'email' => SUPPORT_EMAIL,
    'logo' => absolute_url('/assets/images/mascotify-logo-real.png'),
];
