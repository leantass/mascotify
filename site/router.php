<?php

declare(strict_types=1);

$requestPath = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH);
$path = is_string($requestPath) ? $requestPath : '/';
$fullPath = __DIR__ . $path;

if ($path !== '/' && is_file($fullPath)) {
    return false;
}

$routes = [
    '/' => __DIR__ . '/index.php',
    '/privacidad' => __DIR__ . '/privacidad.php',
    '/terminos' => __DIR__ . '/terminos.php',
    '/eliminacion-de-cuenta' => __DIR__ . '/eliminacion-de-cuenta.php',
    '/soporte' => __DIR__ . '/soporte.php',
    '/legal' => __DIR__ . '/legal.php',
];

$normalized = rtrim($path, '/');
$normalized = $normalized === '' ? '/' : $normalized;

if (!array_key_exists($normalized, $routes)) {
    http_response_code(404);
    require __DIR__ . '/index.php';
    return true;
}

require $routes[$normalized];
return true;
