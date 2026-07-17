<?php

declare(strict_types=1);

define('APP_ROOT', dirname(__DIR__));

$appConfig = require APP_ROOT . '/config/config.php';

require APP_ROOT . '/includes/core/functions.php';
require APP_ROOT . '/includes/core/seo.php';

$pageKey = $pageKey ?? route_page_key();
$page = array_merge(default_page_meta($pageKey), $page ?? []);
$contentView = $contentView ?? $pageKey . '-content.php';
