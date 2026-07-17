<?php

declare(strict_types=1);

?>
<header class="site-header">
    <div class="container header-shell">
        <a class="brand" href="<?= e(page_url('index.php')); ?>" aria-label="Ir al inicio de Mascotify">
            <img src="<?= e(asset('images/mascotify-logo.svg')); ?>" alt="" width="42" height="42">
            <span>
                <strong>Mascotify</strong>
                <small>Guia oficial</small>
            </span>
        </a>
        <button class="nav-toggle" type="button" aria-expanded="false" aria-controls="primary-navigation">
            <span></span>
            <span></span>
            <span></span>
            <span class="sr-only">Abrir navegacion</span>
        </button>
        <?php include APP_ROOT . '/includes/layout/navigation.php'; ?>
    </div>
</header>
