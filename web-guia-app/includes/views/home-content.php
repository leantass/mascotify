<?php

declare(strict_types=1);

?>
<section class="hero">
    <div class="container hero-grid">
        <div class="hero-copy">
            <p class="eyebrow">Guia oficial de la app</p>
            <h1>Mascotify</h1>
            <p class="hero-lead">Organiza la informacion importante de tus mascotas, accede a soporte y consulta los documentos legales desde un solo lugar.</p>
            <div class="hero-actions">
                <a class="button primary" href="<?= e(page_url('soporte.php')); ?>">Contactar soporte</a>
                <a class="button secondary" href="<?= e(page_url('legal.php')); ?>">Ver documentos</a>
            </div>
        </div>
        <div class="app-panel" aria-label="Resumen de funciones de Mascotify">
            <div class="panel-top">
                <img src="<?= e(asset('images/mascotify-logo.svg')); ?>" alt="" width="52" height="52">
                <div>
                    <strong>Perfil de Luna</strong>
                    <span>Vacunas, notas y cuidado diario</span>
                </div>
            </div>
            <div class="metric-row">
                <span>Proxima vacuna</span>
                <strong>15 Ago</strong>
            </div>
            <div class="metric-row">
                <span>Contacto veterinario</span>
                <strong>Guardado</strong>
            </div>
            <div class="metric-row">
                <span>Documentos</span>
                <strong>Al dia</strong>
            </div>
        </div>
    </div>
</section>

<section class="section">
    <div class="container">
        <div class="section-heading">
            <p class="eyebrow">Que puedes hacer</p>
            <h2>Una guia simple para usar Mascotify con confianza</h2>
        </div>
        <div class="card-grid three">
            <?php
            include_component('feature-card', [
                'icon' => '01',
                'title' => 'Centralizar datos',
                'text' => 'Guarda informacion basica, notas de cuidado y datos utiles para cada mascota.',
            ]);
            include_component('feature-card', [
                'icon' => '02',
                'title' => 'Revisar documentos',
                'text' => 'Accede rapido a privacidad, terminos, soporte legal y eliminacion de cuenta.',
            ]);
            include_component('feature-card', [
                'icon' => '03',
                'title' => 'Pedir ayuda',
                'text' => 'Encuentra el canal correcto para resolver problemas de acceso, datos o funcionamiento.',
            ]);
            ?>
        </div>
    </div>
</section>

<section class="section soft">
    <div class="container split">
        <div>
            <p class="eyebrow">Disponibilidad</p>
            <h2>Informacion preparada para usuarios y revisiones de plataforma</h2>
            <p>Esta web reune las paginas necesarias para publicar informacion de soporte, privacidad, condiciones de uso y proceso de eliminacion de cuenta.</p>
        </div>
        <div class="stack">
            <?php
            include_component('platform-card', [
                'title' => 'Soporte al usuario',
                'text' => 'Canal de contacto claro para consultas sobre cuenta, datos y uso de la app.',
                'status' => 'Activo',
            ]);
            include_component('platform-card', [
                'title' => 'Paginas legales',
                'text' => 'Documentos accesibles desde URLs publicas y listas para hosting PHP.',
                'status' => 'Listo',
            ]);
            ?>
        </div>
    </div>
</section>
