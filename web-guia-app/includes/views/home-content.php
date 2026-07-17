<?php

declare(strict_types=1);

?>
<section class="hero-section" id="inicio">
    <div class="hero-background" aria-hidden="true">
        <span class="hero-blob hero-blob-a"></span>
        <span class="hero-blob hero-blob-b"></span>
        <span class="hero-line"></span>
    </div>

    <div class="container hero-shell">
        <div class="hero-copy reveal is-visible">
            <div class="hero-pill">
                <span></span>
                Mascotify para mascotas cuidadas, conectadas y protegidas
            </div>
            <h1>La app para cuidar cada historia con tu mascota.</h1>
            <p class="hero-lead">Perfiles, QR seguro, salud, clips, comunidad y matching en una experiencia visual, simple y confiable para familias pet friendly.</p>
            <div class="hero-actions">
                <a class="button button-primary" href="<?= e(url('/#usar-mascotify')); ?>">Ir a la app</a>
                <a class="button button-soft" href="<?= e(url('/#funciones')); ?>">Explorar funciones</a>
            </div>
        </div>

        <div class="hero-product reveal is-visible" data-parallax-card>
            <div class="hero-device-wrap">
                <div class="floating-chip chip-left" data-floating-card>QR seguro</div>
                <div class="floating-chip chip-right" data-floating-card>Matching</div>
                <div class="phone-mockup hero-phone" data-tilt-card>
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
                            <p>Perfil activo y protegido</p>
                        </div>
                    </div>
                    <div class="hero-health-card">
                        <span>Salud</span>
                        <strong>Vacunas al dia</strong>
                        <div class="progress-track"><i></i></div>
                    </div>
                    <div class="phone-grid">
                        <div><strong>QR</strong><span>Seguro</span></div>
                        <div><strong>Clips</strong><span>Nuevo</span></div>
                        <div><strong>Match</strong><span>Cerca</span></div>
                        <div><strong>Alertas</strong><span>Listas</span></div>
                    </div>
                </div>
                <div class="hero-card hero-card-a" data-floating-card>
                    <span>Contacto protegido</span>
                    <strong>Sin exponer datos sensibles</strong>
                </div>
                <div class="hero-card hero-card-b" data-floating-card>
                    <span>Comunidad</span>
                    <strong>Clips y encuentros</strong>
                </div>
            </div>
        </div>

        <div class="hero-metrics reveal is-visible">
            <div><strong>QR</strong><span>identificacion segura</span></div>
            <div><strong>Salud</strong><span>seguimiento orientativo</span></div>
            <div><strong>Clips</strong><span>momentos y comunidad</span></div>
            <div><strong>Match</strong><span>conexiones pet friendly</span></div>
        </div>
    </div>
</section>

<section class="section feature-section" id="funciones">
    <div class="container section-split">
        <div class="section-heading reveal">
            <p class="eyebrow">Funciones</p>
            <h2>Un panel moderno para todo lo que importa.</h2>
            <p>La experiencia se organiza en bloques claros, con acciones visibles y tarjetas que ayudan a entender Mascotify de un vistazo.</p>
        </div>
        <div class="section-note reveal">
            <strong>Hecha para el dia a dia</strong>
            <span>Perfiles, recordatorios, QR y comunidad trabajando juntos.</span>
        </div>
    </div>
    <div class="container">
        <div class="feature-grid">
            <?php
            include_component('feature-card', [
                'icon' => '01',
                'title' => 'Perfil de mascota',
                'text' => 'Datos importantes, foto, notas y detalles utiles para cada mascota.',
            ]);
            include_component('feature-card', [
                'icon' => '02',
                'title' => 'QR seguro',
                'text' => 'Identificacion rapida con contacto mediado y sin direccion exacta publica.',
            ]);
            include_component('feature-card', [
                'icon' => '03',
                'title' => 'Salud y vacunas',
                'text' => 'Recordatorios y seguimiento orientativo para acompanarte entre visitas veterinarias.',
            ]);
            include_component('feature-card', [
                'icon' => '04',
                'title' => 'Mascotas perdidas',
                'text' => 'Herramientas pensadas para reaccionar rapido con informacion controlada.',
            ]);
            include_component('feature-card', [
                'icon' => '05',
                'title' => 'Comunidad y clips',
                'text' => 'Momentos, novedades y vida diaria de mascotas con una capa social cuidada.',
            ]);
            include_component('feature-card', [
                'icon' => '06',
                'title' => 'Matching',
                'text' => 'Conexiones relevantes entre mascotas, familias y experiencias compatibles.',
            ]);
            ?>
        </div>
    </div>
</section>

<section class="section trust-section" id="seguridad">
    <div class="container trust-shell">
        <div class="trust-visual reveal">
            <div class="trust-card-large" data-tilt-card>
                <span class="platform-badge">SEGURIDAD</span>
                <h2>Proteccion con mirada pet friendly.</h2>
                <p>La app esta pensada para ayudar sin publicar datos sensibles ni reemplazar criterios profesionales.</p>
                <div class="qr-card premium-qr">
                    <div class="qr-visual" aria-hidden="true">
                        <span></span><span></span><span></span><span></span>
                        <span></span><span></span><span></span><span></span>
                        <span></span><span></span><span></span><span></span>
                    </div>
                    <p>QR visual para reencontrar mascotas con contacto mediado.</p>
                </div>
            </div>
        </div>
        <div class="trust-panels">
            <?php
            include_component('animated-panel', [
                'kicker' => 'Privacidad',
                'title' => 'Sin direccion exacta publica',
                'text' => 'La identificacion puede ayudar sin mostrar ubicaciones sensibles.',
            ]);
            include_component('animated-panel', [
                'kicker' => 'Contacto',
                'title' => 'Sin telefono o email publico',
                'text' => 'El contacto futuro puede ser mediado y controlado.',
            ]);
            include_component('animated-panel', [
                'kicker' => 'Datos',
                'title' => 'Eliminacion de cuenta',
                'text' => 'Ruta clara para baja y tratamiento de datos asociados.',
            ]);
            include_component('animated-panel', [
                'kicker' => 'Salud',
                'title' => 'No reemplaza veterinario',
                'text' => 'Los recordatorios son apoyo orientativo, no urgencias ni diagnostico.',
            ]);
            ?>
        </div>
    </div>
</section>

<section class="section platform-section" id="usar-mascotify">
    <div class="container platform-shell">
        <div class="section-heading reveal">
            <p class="eyebrow">Usa Mascotify</p>
            <h2>Elige donde abrir tu experiencia.</h2>
            <p>Las URLs quedan bloqueadas como proximamente hasta confirmar los enlaces oficiales de publicacion.</p>
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
            <p class="eyebrow">Legal y soporte</p>
            <h2>Transparencia visible, sin salir de la experiencia.</h2>
        </div>
        <div class="legal-links reveal">
            <a href="<?= e(url('/privacidad')); ?>">Politica de privacidad</a>
            <a href="<?= e(url('/terminos')); ?>">Terminos y condiciones</a>
            <a href="<?= e(url('/eliminacion-de-cuenta')); ?>">Eliminacion de cuenta</a>
            <a href="<?= e(url('/soporte')); ?>">Soporte</a>
        </div>
    </div>
</section>
