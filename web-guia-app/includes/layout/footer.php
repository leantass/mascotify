<?php

declare(strict_types=1);

?>
<footer class="site-footer">
    <div class="footer-glow" aria-hidden="true"></div>
    <div class="container footer-grid">
        <div class="footer-intro">
            <a class="footer-brand" href="<?= e(url('/')); ?>">
                <img src="<?= e(asset('images/mascotify-logo.svg')); ?>" alt="" width="44" height="44">
                <span>Mascotify</span>
            </a>
            <p>Una experiencia calida y moderna para cuidar, conectar y proteger a quienes comparten la vida con mascotas.</p>
        </div>
        <div>
            <h2>Explorar</h2>
            <a href="<?= e(url('/#funciones')); ?>">Funciones</a>
            <a href="<?= e(url('/#seguridad')); ?>">Seguridad</a>
            <a href="<?= e(url('/#usar-mascotify')); ?>">Plataformas</a>
        </div>
        <div>
            <h2>Legal</h2>
            <a href="<?= e(url('/privacidad')); ?>">Politica de privacidad</a>
            <a href="<?= e(url('/terminos')); ?>">Terminos y condiciones</a>
            <a href="<?= e(url('/eliminacion-de-cuenta')); ?>">Eliminacion de cuenta</a>
        </div>
        <div>
            <h2>Soporte</h2>
            <a href="<?= e(url('/soporte')); ?>">Centro de ayuda</a>
            <a href="<?= e(support_mailto()); ?>" <?= is_placeholder_url(SUPPORT_EMAIL) ? 'aria-disabled="true"' : ''; ?>><?= e(SUPPORT_EMAIL); ?></a>
            <a href="<?= e(url('/legal')); ?>">Centro legal</a>
        </div>
    </div>
    <div class="container footer-bottom">
        <span>&copy; <?= date('Y'); ?> Mascotify.</span>
        <span>Base publica preliminar para revision antes de publicacion definitiva.</span>
    </div>
</footer>
