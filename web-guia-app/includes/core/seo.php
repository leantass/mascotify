<?php

declare(strict_types=1);

function get_page_meta(string $pageKey, array $config): array
{
    $site = $config['site'] ?? [];
    $page = $config['pages'][$pageKey] ?? $config['pages']['home'];

    return [
        'title' => $page['title'] ?? $site['name'],
        'description' => $page['description'] ?? ($site['description'] ?? ''),
        'canonical' => page_url($page['canonical'] ?? 'index.php'),
        'og_image' => asset('images/og-mascotify.svg'),
        'locale' => $site['locale'] ?? 'es_AR',
        'theme_color' => $site['theme_color'] ?? '#123c3a',
    ];
}

function organization_schema(array $config): string
{
    $site = $config['site'];
    $schema = [
        '@context' => 'https://schema.org',
        '@type' => 'Organization',
        'name' => $site['name'],
        'url' => page_url('index.php'),
        'email' => $site['support_email'],
    ];

    return json_encode($schema, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
}
