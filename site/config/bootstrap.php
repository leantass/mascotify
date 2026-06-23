<?php

declare(strict_types=1);

define('BASE_PATH', dirname(__DIR__));
define('CONFIG_PATH', BASE_PATH . '/config');
define('INCLUDES_PATH', BASE_PATH . '/includes');
define('VIEWS_PATH', INCLUDES_PATH . '/views');
define('COMPONENTS_PATH', INCLUDES_PATH . '/components');
define('LAYOUT_PATH', INCLUDES_PATH . '/layout');
define('SCHEMA_PATH', INCLUDES_PATH . '/schema');
define('ASSETS_PATH', BASE_PATH . '/assets');
define('STORAGE_PATH', BASE_PATH . '/storage');
define('LOGS_PATH', STORAGE_PATH . '/logs');

require CONFIG_PATH . '/config.php';
require INCLUDES_PATH . '/core/functions.php';
require INCLUDES_PATH . '/core/seo.php';

if (!is_dir(LOGS_PATH)) {
    @mkdir(LOGS_PATH, 0775, true);
}

$errorLogPath = LOGS_PATH . '/php-errors.log';

error_reporting(E_ALL);
ini_set('log_errors', '1');
ini_set('error_log', $errorLogPath);

if (IS_PRODUCTION) {
    ini_set('display_errors', '0');
    ini_set('display_startup_errors', '0');
} else {
    ini_set('display_errors', '1');
    ini_set('display_startup_errors', '1');
}
