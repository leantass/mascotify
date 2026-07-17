<?php

declare(strict_types=1);

?>
<footer class="site-footer">
    <div class="container footer-grid">
        <div>
            <a class="footer-brand" href="<?= e(page_url('index.php')); ?>">
                <img src="<?= e(asset('images/mascotify-logo.svg')); ?>" alt="" width="34" height="34">
                <span>Mascotify</span>
            </a>
            <p>Centro oficial de informacion, soporte y documentos legales de la app Mascotify.</p>
        </div>
        <div>
            <h2>App</h2>
            <a href="<?= e(page_url('index.php')); ?>">Guia de uso</a>
            <a href="<?= e(page_url('soporte.php')); ?>">Soporte</a>
            <a href="<?= e(page_url('eliminacion-de-cuenta.php')); ?>">Eliminar cuenta</a>
        </div>
        <div>
            <h2>Legal</h2>
            <a href="<?= e(page_url('privacidad.php')); ?>">Privacidad</a>
            <a href="<?= e(page_url('terminos.php')); ?>">Terminos</a>
            <a href="<?= e(page_url('legal.php')); ?>">Centro legal</a>
        </div>
    </div>
    <div class="container footer-bottom">
        <span>&copy; <?= date('Y'); ?> Mascotify.</span>
        <a href="<?= e(support_mailto()); ?>"><?= e(SUPPORT_EMAIL); ?></a>
    </div>
</footer>
