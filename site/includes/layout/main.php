<?php

declare(strict_types=1);

extract($pageData, EXTR_SKIP);
?>
<!doctype html>
<html lang="es-AR">
<head>
  <?php require LAYOUT_PATH . '/head.php'; ?>
</head>
<body
  data-app-web-url="<?= e(APP_WEB_URL); ?>"
  data-app-store-url="<?= e(APP_STORE_URL); ?>"
  data-support-email="<?= e(SUPPORT_EMAIL); ?>"
>
  <?php require LAYOUT_PATH . '/header.php'; ?>
  <main id="contenido">
    <?php require $viewPath; ?>
  </main>
  <?php require LAYOUT_PATH . '/cookie-banner.php'; ?>
  <?php require LAYOUT_PATH . '/footer.php'; ?>
</body>
</html>
