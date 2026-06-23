<?php

declare(strict_types=1);

function e(?string $value): string
{
    return htmlspecialchars((string) $value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

function asset(string $path): string
{
    $normalized = ltrim($path, '/');

    return '/assets/' . $normalized . '?v=' . rawurlencode(ASSETS_VERSION);
}

function css(string $path): string
{
    return '<link rel="stylesheet" href="' . e(asset($path)) . '">';
}

function js(string $path, bool $defer = true): string
{
    $deferAttribute = $defer ? ' defer' : '';

    return '<script src="' . e(asset($path)) . '"' . $deferAttribute . '></script>';
}

function absolute_url(string $path = ''): string
{
    if ($path === '') {
        return SITE_BASE_URL;
    }

    if (is_external_url($path) || is_placeholder_url($path)) {
        return $path;
    }

    return rtrim(SITE_BASE_URL, '/') . '/' . ltrim($path, '/');
}

function canonical_url(string $path = ''): string
{
    $normalized = $path === '' ? current_request_path() : normalize_path($path);

    if ($normalized === '/') {
        return absolute_url('/');
    }

    return absolute_url(rtrim($normalized, '/'));
}

function is_external_url(string $url): bool
{
    return (bool) preg_match('/^https?:\/\//i', $url);
}

function is_placeholder_url(string $url): bool
{
    return (bool) preg_match('/^\[[A-Z0-9_]+\]$/', trim($url));
}

function nav_is_active(string $path): bool
{
    $target = normalize_path($path);
    if (str_contains($path, '#')) {
        return false;
    }

    $targetBase = explode('#', $target, 2)[0] ?: '/';
    $current = current_request_path();

    if ($targetBase === '/') {
        return $current === '/';
    }

    return $current === rtrim($targetBase, '/');
}

function renderPage(string $viewPath, array $data = []): void
{
    if (!is_file($viewPath)) {
        throw new RuntimeException('View not found: ' . $viewPath);
    }

    $layoutPath = LAYOUT_PATH . '/main.php';

    if (!is_file($layoutPath)) {
        throw new RuntimeException('Layout not found: ' . $layoutPath);
    }

    $pageData = $data;

    require $layoutPath;
}

function current_request_path(): string
{
    $requestUri = $_SERVER['REQUEST_URI'] ?? '/';
    $path = parse_url($requestUri, PHP_URL_PATH);

    return normalize_path(is_string($path) ? $path : '/');
}

function normalize_path(string $path): string
{
    $trimmed = trim($path);

    if ($trimmed === '' || $trimmed === 'index.php') {
        return '/';
    }

    $trimmed = '/' . ltrim($trimmed, '/');
    $trimmed = preg_replace('#/+#', '/', $trimmed) ?? '/';

    if ($trimmed !== '/' && str_ends_with($trimmed, '.php')) {
        $trimmed = substr($trimmed, 0, -4);
    }

    if ($trimmed !== '/' && str_ends_with($trimmed, '/')) {
        $trimmed = rtrim($trimmed, '/');
    }

    return $trimmed === '' ? '/' : $trimmed;
}
