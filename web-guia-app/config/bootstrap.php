<?php

declare(strict_types=1);

define('APP_ROOT', dirname(__DIR__));

$appConfig = require APP_ROOT . '/config/config.php';

require APP_ROOT . '/includes/core/functions.php';
require APP_ROOT . '/includes/core/seo.php';

$pageKey = $pageKey ?? 'home';
$pageMeta = get_page_meta($pageKey, $appConfig);
$contentView = $contentView ?? 'home-content.php';
