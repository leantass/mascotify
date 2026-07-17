<?php

declare(strict_types=1);

?>
<section class="page-hero">
    <div class="container narrow reveal is-visible">
        <p class="eyebrow">Soporte</p>
        <h1>Centro de ayuda Mascotify</h1>
        <p>Canales y recomendaciones para resolver consultas sobre cuenta, seguridad, datos y funcionamiento.</p>
    </div>
</section>

<section class="section support-page">
    <div class="container support-grid">
        <div class="content-flow reveal">
            <div class="notice"><strong>Aviso</strong><p>Este texto es una base preliminar y debe ser revisado antes de publicacion definitiva.</p></div>
            <h2>Como pedir ayuda</h2>
            <p>Describe el problema, indica el correo asociado a tu cuenta, dispositivo, version de la app si la conoces y agrega capturas si ayudan a entender el caso.</p>
            <a class="button button-primary <?= is_placeholder_url(SUPPORT_EMAIL) ? 'disabled' : ''; ?>" href="<?= e(support_mailto()); ?>" <?= is_placeholder_url(SUPPORT_EMAIL) ? 'aria-disabled="true" data-disabled-link' : ''; ?>>Contactar soporte</a>
        </div>
        <div class="support-cards">
            <?php
            include_component('animated-panel', ['kicker' => 'Cuenta', 'title' => 'Acceso y perfil', 'text' => 'Consultas de inicio de sesion, datos personales y configuracion.']);
            include_component('animated-panel', ['kicker' => 'Mascotas', 'title' => 'Perfiles y QR', 'text' => 'Ayuda con datos de mascotas, QR seguro y visibilidad.']);
            include_component('animated-panel', ['kicker' => 'Legal', 'title' => 'Privacidad y baja', 'text' => 'Orientacion sobre privacidad, terminos y eliminacion de cuenta.']);
            ?>
        </div>
    </div>
</section>
