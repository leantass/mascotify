<?php

declare(strict_types=1);

?>
<header class="site-header" data-site-header>
    <div class="container header-shell">
        <a class="brand" href="<?= e(url('/')); ?>" aria-label="Ir al inicio de Mascotify">
            <img src="<?= e(asset('images/mascotify-header-logo.png')); ?>" alt="" width="54" height="54">
            <span>
                <strong>Mascotify</strong>
                <small>Cuidar. Conectar. Proteger.</small>
            </span>
        </a>

        <?php include APP_ROOT . '/includes/layout/navigation.php'; ?>

        <div class="header-actions">
            <button class="theme-toggle" type="button" data-theme-toggle aria-label="Cambiar tema" aria-pressed="false">
                <span class="theme-toggle-icon" aria-hidden="true"></span>
                <span data-theme-label>Claro</span>
            </button>
            <a class="header-cta" href="<?= e(url('/#usar-mascotify')); ?>">Ir a la app</a>
        </div>
        <button class="nav-toggle" type="button" aria-expanded="false" aria-controls="primary-navigation">
            <span></span>
            <span></span>
            <span></span>
            <span class="sr-only">Abrir navegacion</span>
        </button>
    </div>
</header>
