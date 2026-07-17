<?php

declare(strict_types=1);

?>
<section class="hero-section" id="inicio">
    <div class="hero-shape shape-one" aria-hidden="true"></div>
    <div class="hero-shape shape-two" aria-hidden="true"></div>
    <div class="container hero-grid">
        <div class="hero-copy reveal is-visible">
            <p class="eyebrow">Mascotify para familias con mascotas</p>
            <h1>Cuidar, conectar y proteger mascotas en una app con alma.</h1>
            <p class="hero-lead">Perfiles, QR seguro, salud, vacunas, mascotas perdidas, clips, comunidad y matching en una experiencia moderna, calida y pensada para el dia a dia.</p>
            <div class="hero-actions">
                <a class="button button-primary" href="<?= e(url('/#usar-mascotify')); ?>">Ir a la app</a>
                <a class="button button-soft" href="<?= e(url('/privacidad')); ?>">Ver privacidad</a>
            </div>
            <div class="hero-chips" aria-label="Funciones destacadas">
                <span data-floating-card>QR seguro</span>
                <span data-floating-card>Salud</span>
                <span data-floating-card>Clips</span>
                <span data-floating-card>Matching</span>
            </div>
        </div>

        <div class="hero-visual reveal is-visible" aria-label="Vista conceptual de la app Mascotify">
            <div class="paw-orbit paw-a" aria-hidden="true">+</div>
            <div class="paw-orbit paw-b" aria-hidden="true">o</div>
            <div class="phone-mockup" data-tilt-card>
                <div class="phone-top">
                    <span></span>
                    <strong>Mascotify</strong>
                    <span></span>
                </div>
                <div class="pet-profile-card">
                    <div class="pet-avatar" aria-hidden="true">
                        <span></span>
                        <span></span>
                    </div>
                    <div>
                        <strong>Luna</strong>
                        <p>Perfil protegido</p>
                    </div>
                </div>
                <div class="phone-grid">
                    <div><strong>QR</strong><span>Seguro</span></div>
                    <div><strong>Vacunas</strong><span>Al dia</span></div>
                    <div><strong>Clips</strong><span>Nuevo</span></div>
                    <div><strong>Match</strong><span>Cerca</span></div>
                </div>
                <div class="qr-card">
                    <div class="qr-visual" aria-hidden="true">
                        <span></span><span></span><span></span><span></span>
                        <span></span><span></span><span></span><span></span>
                        <span></span><span></span><span></span><span></span>
                    </div>
                    <p>Si alguien encuentra a tu mascota, el contacto puede ser mediado y seguro.</p>
                </div>
            </div>
            <div class="floating-note note-one" data-floating-card>
                <strong>Salud y vacunas</strong>
                <span>Recordatorios utiles</span>
            </div>
            <div class="floating-note note-two" data-floating-card>
                <strong>Comunidad</strong>
                <span>Clips y encuentros</span>
            </div>
        </div>
    </div>
</section>

<section class="section feature-section" id="funciones">
    <div class="container">
        <div class="section-heading reveal">
            <p class="eyebrow">Funciones</p>
            <h2>Todo lo importante de tu mascota, ordenado y listo para actuar.</h2>
            <p>Mascotify combina organizacion, proteccion y comunidad sin perder una experiencia simple.</p>
        </div>
        <div class="feature-grid">
            <?php
            include_component('feature-card', [
                'icon' => 'PF',
                'title' => 'Perfil de mascota',
                'text' => 'Datos importantes, notas, foto y detalles utiles para compartir solo cuando haga falta.',
            ]);
            include_component('feature-card', [
                'icon' => 'QR',
                'title' => 'QR seguro',
                'text' => 'Identificacion rapida con contacto mediado, sin exponer direccion exacta ni datos sensibles.',
            ]);
            include_component('feature-card', [
                'icon' => 'SX',
                'title' => 'Salud y vacunas',
                'text' => 'Agenda de cuidados, vacunas y recordatorios como apoyo orientativo al seguimiento veterinario.',
            ]);
            include_component('feature-card', [
                'icon' => 'MP',
                'title' => 'Mascotas perdidas',
                'text' => 'Herramientas pensadas para reaccionar rapido y comunicar datos utiles de forma controlada.',
            ]);
            include_component('feature-card', [
                'icon' => 'CL',
                'title' => 'Comunidad y clips',
                'text' => 'Momentos, novedades y vida diaria de mascotas en un entorno pensado para conectar.',
            ]);
            include_component('feature-card', [
                'icon' => 'MT',
                'title' => 'Matching',
                'text' => 'Descubre conexiones relevantes entre mascotas, familias y experiencias compatibles.',
            ]);
            include_component('feature-card', [
                'icon' => 'PV',
                'title' => 'Privacidad',
                'text' => 'Controles y paginas claras para entender datos, soporte y eliminacion de cuenta.',
            ]);
            ?>
        </div>
    </div>
</section>

<section class="section trust-section" id="seguridad">
    <div class="container trust-grid">
        <div class="section-heading reveal">
            <p class="eyebrow">Seguridad y confianza</p>
            <h2>Proteccion realista para una app pet friendly.</h2>
            <p>Mascotify esta pensada para ayudar sin publicar datos delicados de forma innecesaria ni reemplazar decisiones profesionales.</p>
        </div>
        <div class="trust-panels">
            <?php
            include_component('animated-panel', [
                'kicker' => 'QR seguro',
                'title' => 'Sin direccion exacta publica',
                'text' => 'La identificacion puede ayudar a reencontrar una mascota sin mostrar ubicaciones sensibles.',
            ]);
            include_component('animated-panel', [
                'kicker' => 'Contacto',
                'title' => 'Sin telefono o email publico',
                'text' => 'La experiencia prioriza contacto mediado y datos compartidos con criterio.',
            ]);
            include_component('animated-panel', [
                'kicker' => 'Datos',
                'title' => 'Eliminacion de cuenta',
                'text' => 'Hay una ruta clara para solicitar baja de cuenta y tratamiento de datos asociados.',
            ]);
            include_component('animated-panel', [
                'kicker' => 'Salud',
                'title' => 'Apoyo orientativo',
                'text' => 'Los recordatorios no reemplazan al veterinario ni a servicios de emergencia.',
            ]);
            ?>
        </div>
    </div>
</section>

<section class="section platform-section" id="usar-mascotify">
    <div class="container">
        <div class="section-heading reveal">
            <p class="eyebrow">Usa Mascotify</p>
            <h2>Elige tu plataforma.</h2>
            <p>Los accesos se mantienen como placeholders hasta confirmar las URLs oficiales de publicacion.</p>
        </div>
        <div class="platform-grid">
            <?php foreach (platform_items() as $platform): ?>
                <?php include_component('platform-card', $platform); ?>
            <?php endforeach; ?>
        </div>
    </div>
</section>

<section class="section legal-strip" id="legal-home">
    <div class="container legal-strip-grid">
        <div class="section-heading reveal">
            <p class="eyebrow">Transparencia</p>
            <h2>Documentos claros para usuarios y plataformas.</h2>
        </div>
        <div class="legal-links reveal">
            <a href="<?= e(url('/privacidad')); ?>">Politica de privacidad</a>
            <a href="<?= e(url('/terminos')); ?>">Terminos y condiciones</a>
            <a href="<?= e(url('/eliminacion-de-cuenta')); ?>">Eliminacion de cuenta</a>
            <a href="<?= e(url('/soporte')); ?>">Soporte</a>
        </div>
    </div>
</section>
