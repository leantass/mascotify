<?php

declare(strict_types=1);

?>
<section class="page-hero">
    <div class="container narrow">
        <p class="eyebrow">Centro legal</p>
        <h1>Documentos legales de Mascotify</h1>
        <p>Accede desde aqui a las paginas legales y de soporte necesarias para usuarios, tiendas de apps y revisiones de plataforma.</p>
    </div>
</section>

<section class="section">
    <div class="container">
        <div class="card-grid three">
            <?php
            include_component('legal-card', [
                'label' => 'Privacidad',
                'title' => 'Politica de privacidad',
                'text' => 'Informacion sobre datos tratados, finalidad, conservacion y contacto.',
                'href' => page_url('privacidad.php'),
            ]);
            include_component('legal-card', [
                'label' => 'Condiciones',
                'title' => 'Terminos y condiciones',
                'text' => 'Reglas generales de uso, alcance del servicio y responsabilidades.',
                'href' => page_url('terminos.php'),
            ]);
            include_component('legal-card', [
                'label' => 'Cuenta',
                'title' => 'Eliminacion de cuenta',
                'text' => 'Proceso para solicitar la baja de cuenta y datos asociados.',
                'href' => page_url('eliminacion-de-cuenta.php'),
            ]);
            ?>
        </div>
    </div>
</section>
