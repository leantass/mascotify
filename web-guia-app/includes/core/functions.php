<?php

declare(strict_types=1);

function e(string $value): string
{
    return htmlspecialchars($value, ENT_QUOTES, 'UTF-8');
}

function app_config(?string $key = null)
{
    global $appConfig;

    if ($key === null) {
        return $appConfig;
    }

    return $appConfig[$key] ?? null;
}

function asset(string $path): string
{
    return SITE_BASE_PATH . 'assets/' . ltrim($path, '/');
}

function page_url(string $path): string
{
    return SITE_BASE_PATH . ltrim($path, '/');
}

function nav_items(): array
{
    $config = app_config('navigation');

    return is_array($config) ? $config : [];
}

function is_current_page(string $key): bool
{
    global $pageKey;

    return $pageKey === $key;
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

function support_mailto(string $subject = 'Consulta sobre Mascotify'): string
{
    return 'mailto:' . SUPPORT_EMAIL . '?subject=' . rawurlencode($subject);
}
