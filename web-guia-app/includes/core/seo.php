<?php

declare(strict_types=1);

function default_page_meta(string $pageKey): array
{
    $path = $pageKey === 'home' ? '' : $pageKey;
    $titles = [
        'home' => 'Mascotify - Cuidar, conectar y proteger mascotas',
        'privacidad' => 'Politica de privacidad - Mascotify',
        'terminos' => 'Terminos y condiciones - Mascotify',
        'eliminacion-de-cuenta' => 'Eliminacion de cuenta - Mascotify',
        'soporte' => 'Soporte - Mascotify',
        'legal' => 'Centro legal - Mascotify',
    ];

    $descriptions = [
        'home' => SITE_DESCRIPTION,
        'privacidad' => 'Consulta la base preliminar de privacidad de Mascotify y como se tratan datos de cuenta, mascotas y soporte.',
        'terminos' => 'Revisa la base preliminar de terminos de uso de Mascotify, responsabilidades y alcance del servicio.',
        'eliminacion-de-cuenta' => 'Conoce como solicitar la eliminacion de una cuenta Mascotify y que datos pueden conservarse por motivos legales.',
        'soporte' => 'Encuentra canales y pautas para contactar al soporte de Mascotify.',
        'legal' => 'Accede a privacidad, terminos, eliminacion de cuenta y soporte legal de Mascotify.',
    ];

    return [
        'title' => $titles[$pageKey] ?? $titles['home'],
        'description' => $descriptions[$pageKey] ?? SITE_DESCRIPTION,
        'canonical' => canonical_url($path),
        'robots' => 'index,follow',
        'ogTitle' => $titles[$pageKey] ?? $titles['home'],
        'ogDescription' => $descriptions[$pageKey] ?? SITE_DESCRIPTION,
        'ogImage' => canonical_url('assets/images/og-mascotify.svg'),
        'ogType' => 'website',
        'schemaMarkup' => schema_markup($pageKey, $titles[$pageKey] ?? SITE_NAME, $descriptions[$pageKey] ?? SITE_DESCRIPTION),
    ];
}

function schema_markup(string $pageKey, string $title, string $description): string
{
    $schema = [
        '@context' => 'https://schema.org',
        '@type' => $pageKey === 'home' ? 'SoftwareApplication' : 'WebPage',
        'name' => $title,
        'description' => $description,
        'url' => canonical_url($pageKey === 'home' ? '' : $pageKey),
        'publisher' => [
            '@type' => 'Organization',
            'name' => SITE_NAME,
        ],
    ];

    if ($pageKey === 'home') {
        $schema['applicationCategory'] = 'LifestyleApplication';
        $schema['operatingSystem'] = 'Web, Android, iOS, Windows';
    }

    return json_encode($schema, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
}
