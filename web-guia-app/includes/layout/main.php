<?php

declare(strict_types=1);

?>
<!doctype html>
<html lang="es">
<?php include APP_ROOT . '/includes/layout/head.php'; ?>
<body>
    <a class="skip-link" href="#contenido">Saltar al contenido</a>
    <?php include APP_ROOT . '/includes/layout/header.php'; ?>
    <main id="contenido" class="site-main">
        <?php renderPage($contentView); ?>
    </main>
    <?php include APP_ROOT . '/includes/layout/footer.php'; ?>
    <script src="<?= e(asset('js/main.js')); ?>" defer></script>
</body>
</html>
