<?php

declare(strict_types=1);

?>
<section class="page-hero">
    <div class="container narrow reveal is-visible">
        <p class="eyebrow">Centro legal</p>
        <h1>Documentos legales de Mascotify</h1>
        <p>Accesos publicos para usuarios, tiendas de apps y revision de plataforma.</p>
    </div>
</section>

<section class="section legal-page">
    <div class="container">
        <div class="notice legal-notice reveal"><strong>Aviso</strong><p>Este texto es una base preliminar y debe ser revisado antes de publicacion definitiva.</p></div>
        <div class="legal-card-grid">
            <?php
            include_component('legal-card', [
                'label' => 'Privacidad',
                'title' => 'Politica de privacidad',
                'text' => 'Datos tratados, finalidades, conservacion, QR seguro y contacto.',
                'href' => url('/privacidad'),
            ]);
            include_component('legal-card', [
                'label' => 'Condiciones',
                'title' => 'Terminos y condiciones',
                'text' => 'Uso permitido, alcance del servicio, contenido y cambios.',
                'href' => url('/terminos'),
            ]);
            include_component('legal-card', [
                'label' => 'Cuenta',
                'title' => 'Eliminacion de cuenta',
                'text' => 'Solicitud de baja, verificacion y datos asociados.',
                'href' => url('/eliminacion-de-cuenta'),
            ]);
            include_component('legal-card', [
                'label' => 'Ayuda',
                'title' => 'Soporte',
                'text' => 'Canales para resolver problemas de cuenta, app, datos y seguridad.',
                'href' => url('/soporte'),
            ]);
            ?>
        </div>
    </div>
</section>
