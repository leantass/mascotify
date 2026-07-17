<?php

declare(strict_types=1);

function e(string $value): string
{
    return htmlspecialchars($value, ENT_QUOTES, 'UTF-8');
}

function text_starts_with(string $value, string $prefix): bool
{
    return substr($value, 0, strlen($prefix)) === $prefix;
}

function text_contains(string $value, string $needle): bool
{
    return $needle === '' || strpos($value, $needle) !== false;
}

function app_config(?string $key = null)
{
    global $appConfig;

    if ($key === null) {
        return $appConfig;
    }

    return $appConfig[$key] ?? null;
}

function is_placeholder_url(string $url): bool
{
    $trimmed = trim($url);

    return $trimmed === '' || text_starts_with($trimmed, '[') || text_contains($trimmed, 'URL_') || text_contains($trimmed, 'DOMINIO_') || text_contains($trimmed, 'EMAIL_');
}

function url(string $path = ''): string
{
    $path = trim($path);

    if ($path === '' || $path === '/') {
        return SITE_BASE_PATH === '' ? '/' : rtrim(SITE_BASE_PATH, '/') . '/';
    }

    if (text_starts_with($path, 'http://') || text_starts_with($path, 'https://') || text_starts_with($path, 'mailto:') || text_starts_with($path, '#')) {
        return $path;
    }

    return rtrim(SITE_BASE_PATH, '/') . '/' . ltrim($path, '/');
}

function page_url(string $path): string
{
    return url($path);
}

function asset(string $path): string
{
    return url('assets/' . ltrim($path, '/')) . '?v=' . rawurlencode(ASSETS_VERSION);
}

function canonical_url(string $path = ''): string
{
    if (is_placeholder_url(SITE_BASE_URL)) {
        return url($path);
    }

    return rtrim(SITE_BASE_URL, '/') . url($path);
}

function route_page_key(): string
{
    $path = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH) ?: '/';
    $path = trim($path, '/');

    switch ($path) {
        case '':
        case 'index.php':
            return 'home';
        case 'privacidad':
        case 'privacidad.php':
            return 'privacidad';
        case 'terminos':
        case 'terminos.php':
            return 'terminos';
        case 'eliminacion-de-cuenta':
        case 'eliminacion-de-cuenta.php':
            return 'eliminacion-de-cuenta';
        case 'soporte':
        case 'soporte.php':
            return 'soporte';
        case 'legal':
        case 'legal.php':
            return 'legal';
        default:
            return 'home';
    }
}

function nav_items(): array
{
    $items = app_config('navigation');

    return is_array($items) ? $items : [];
}

function platform_items(): array
{
    $items = app_config('platforms');

    return is_array($items) ? $items : [];
}

function include_component(string $component, array $data = []): void
{
    $file = APP_ROOT . '/includes/components/' . $component . '.php';

    if (!is_file($file)) {
        return;
    }

    extract($data, EXTR_SKIP);
    include $file;
}

function renderPage(string $view): void
{
    $file = APP_ROOT . '/includes/views/' . ltrim($view, '/');

    if (!is_file($file)) {
        http_response_code(404);
        $file = APP_ROOT . '/includes/views/home-content.php';
    }

    include $file;
}

function support_mailto(string $subject = 'Consulta sobre Mascotify'): string
{
    if (is_placeholder_url(SUPPORT_EMAIL)) {
        return '#';
    }

    return 'mailto:' . SUPPORT_EMAIL . '?subject=' . rawurlencode($subject);
}
