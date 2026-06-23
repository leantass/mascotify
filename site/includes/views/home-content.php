<?php

declare(strict_types=1);

$heroCards = [
    [
        'badge' => 'QR seguro',
        'title' => 'Identificacion lista para actuar',
        'text' => 'Un QR visible ayuda en extravios sin exponer telefono o email publicamente.',
        'className' => 'floating-card--qr',
    ],
    [
        'badge' => 'Salud',
        'title' => 'Vacunas y controles a mano',
        'text' => 'La informacion importante vive ordenada dentro de un perfil facil de consultar.',
        'className' => 'floating-card--health',
    ],
    [
        'badge' => 'Comunidad',
        'title' => 'Clips, ayuda y contexto pet',
        'text' => 'Mascotify prepara una capa social enfocada en cuidado, comunidad y crecimiento.',
        'className' => 'floating-card--community',
    ],
];

$trustCards = [
    [
        'icon' => 'PR',
        'title' => 'Privacidad cuidada desde el diseno',
        'text' => 'La experiencia prioriza compartir menos, ordenar mejor y dejar claros los limites de exposicion.',
        'items' => [
            'Ubicacion aproximada en lugar de direccion exacta.',
            'Contacto futuro mediado por Mascotify cuando la funcion lo requiera.',
            'Base legal enlazable para stores y dentro de la app.',
        ],
    ],
    [
        'icon' => 'DT',
        'title' => 'Datos utiles, no ruido',
        'text' => 'Perfiles claros, salud orientativa, QR seguro y pasos concretos para soporte o eliminacion de cuenta.',
        'items' => [
            'Perfiles de mascotas con informacion visible y ordenada.',
            'Salud y vacunas con foco practico para el dia a dia.',
            'Canal documentado para soporte y baja manual de cuenta/datos.',
        ],
    ],
    [
        'icon' => 'CM',
        'title' => 'Comunidad pet con mas contexto',
        'text' => 'Clips, publicaciones y matching futuro pensados para crecer sobre una base mas responsable.',
        'items' => [
            'Funciones sociales en evolucion, no expuestas como promesa vacia.',
            'Mayor contexto antes de cualquier contacto entre personas.',
            'Preparado para sumar servicios pet en futuras etapas.',
        ],
    ],
];

$functionCards = [
    [
        'title' => 'Perfil vivo de cada mascota',
        'text' => 'Nombre, especie, raza, edad aproximada, rasgos y datos esenciales en una ficha clara y lista para consultar rapido.',
        'icon' => 'PF',
        'eyebrow' => 'Identidad',
        'meta' => 'Base central de la experiencia.',
        'className' => 'feature-card feature-card--large feature-card--teal',
    ],
    [
        'title' => 'QR seguro para actuar mejor',
        'text' => 'Identificacion visible pensada para ayudar en extravios sin publicar datos personales de forma abierta.',
        'icon' => 'QR',
        'eyebrow' => 'Seguridad',
        'className' => 'feature-card feature-card--compact',
    ],
    [
        'title' => 'Salud y vacunas con orden',
        'text' => 'Registro orientativo para seguir vacunas, controles y recordatorios futuros con mas contexto.',
        'icon' => 'SV',
        'eyebrow' => 'Salud',
        'className' => 'feature-card feature-card--compact feature-card--support',
    ],
    [
        'title' => 'Mascotas perdidas y ayuda comunitaria',
        'text' => 'Herramientas pensadas para circular informacion importante de forma prudente y con mejor soporte visual.',
        'icon' => 'SOS',
        'eyebrow' => 'Ayuda',
        'className' => 'feature-card feature-card--wide',
    ],
    [
        'title' => 'Comunidad y clips con foco pet',
        'text' => 'Espacios sociales en evolucion para publicaciones, clips y participacion de la comunidad sin perder tono de marca.',
        'icon' => 'CL',
        'eyebrow' => 'Contenido',
        'className' => 'feature-card feature-card--compact feature-card--accent',
    ],
    [
        'title' => 'Matching y profesionales pet futuros',
        'text' => 'Base preparada para conexiones futuras y servicios especializados con mas privacidad y criterio.',
        'icon' => 'MX',
        'eyebrow' => 'Roadmap',
        'meta' => 'Incluye soporte para crecimiento comercial y legal.',
        'className' => 'feature-card feature-card--tall',
        'linkLabel' => 'Ver base legal',
        'linkHref' => '/legal',
    ],
];

$appEntries = [
    [
        'badge' => 'Web',
        'title' => 'Mascotify Web',
        'text' => 'Entra desde el navegador para probar Mascotify sin instalar nada.',
        'status' => is_placeholder_url(APP_WEB_URL) ? 'Estado actual: URL pendiente.' : 'Disponible ahora.',
        'buttonLabel' => 'Abrir Mascotify Web',
        'url' => APP_WEB_URL,
        'disabled' => is_placeholder_url(APP_WEB_URL),
        'buttonVariant' => 'primary',
        'dataAttribute' => 'data-web-app-link',
    ],
    [
        'badge' => 'App Store',
        'badgeClass' => 'entry-badge-store',
        'cardClass' => 'app-entry-card-store',
        'title' => 'App Store',
        'text' => 'Descarga Mascotify para iPhone cuando este disponible en App Store.',
        'status' => is_placeholder_url(APP_STORE_URL) ? 'Disponible proximamente.' : 'Disponible ahora.',
        'buttonLabel' => 'Descargar en App Store',
        'url' => APP_STORE_URL,
        'disabled' => is_placeholder_url(APP_STORE_URL),
        'buttonVariant' => 'secondary',
        'dataAttribute' => 'data-app-store-link',
    ],
    [
        'badge' => 'Android',
        'badgeClass' => 'entry-badge-android',
        'cardClass' => 'app-entry-card-android',
        'title' => 'Play Store',
        'text' => 'Descarga Mascotify para Android cuando este disponible en Google Play.',
        'status' => is_placeholder_url(PLAY_STORE_URL) ? 'Disponible proximamente.' : 'Disponible ahora.',
        'buttonLabel' => 'Descargar en Play Store',
        'url' => PLAY_STORE_URL,
        'disabled' => is_placeholder_url(PLAY_STORE_URL),
        'buttonVariant' => 'secondary',
        'dataAttribute' => 'data-play-store-link',
    ],
];
?>
<section id="inicio" class="hero">
  <div class="container hero-layout">
    <div class="hero-copy">
      <p class="eyebrow">Producto en desarrollo para familias, tutores y comunidad pet</p>
      <div class="hero-badge-row" aria-label="Highlights de Mascotify">
        <span class="hero-badge">QR seguro</span>
        <span class="hero-badge">Salud</span>
        <span class="hero-badge">Clips</span>
        <span class="hero-badge">Matching futuro</span>
      </div>
      <h1>La presencia digital de tu mascota, pensada para cuidar mejor y conectar con criterio.</h1>
      <p class="lead">
        Mascotify reune perfiles de mascotas, QR seguro, salud, comunidad, clips y herramientas
        futuras para mascotas perdidas, matching y servicios pet desde una experiencia clara, moderna y confiable.
      </p>
      <div class="hero-actions">
        <a class="button button-primary" data-app-entry-link href="/#usar-mascotify">Ir a la app</a>
        <a class="button button-secondary" href="/#funciones">Conocer funciones</a>
      </div>
      <div class="hero-kpis" aria-label="Senales de producto">
        <article class="hero-kpi">
          <strong>Privacidad cuidada</strong>
          <span>Datos sensibles menos expuestos y contacto mas prudente.</span>
        </article>
        <article class="hero-kpi">
          <strong>Base lista para stores</strong>
          <span>Landing, soporte, terminos y eliminacion preparados para enlazar.</span>
        </article>
      </div>
    </div>

    <aside class="hero-stage" aria-label="Vista conceptual de Mascotify">
      <div class="hero-stage__halo hero-stage__halo--teal"></div>
      <div class="hero-stage__halo hero-stage__halo--rose"></div>
      <div class="device-shell">
        <div class="device-shell__top">
          <span class="mockup-brand">
            <img class="mockup-logo" src="<?= e(asset('images/mascotify-logo-real.png')); ?>" alt="Mascotify" width="869" height="467">
          </span>
          <span class="device-status">Beta privada</span>
        </div>
        <div class="device-profile">
          <p>Perfil activo</p>
          <h2>Milo · QR listo</h2>
          <small>Contacto seguro mediado por la app</small>
        </div>
        <div class="device-grid">
          <article class="device-stat">
            <strong>Salud</strong>
            <span>Vacunas y controles mas faciles de ordenar.</span>
          </article>
          <article class="device-stat">
            <strong>Perdidas</strong>
            <span>Contexto rapido cuando importa actuar.</span>
          </article>
          <article class="device-stat">
            <strong>Comunidad</strong>
            <span>Clips y publicaciones con tono pet.</span>
          </article>
          <article class="device-stat">
            <strong>Legal</strong>
            <span>URLs listas para app y stores.</span>
          </article>
        </div>
      </div>
      <div class="floating-cards" aria-label="Capacidades clave de Mascotify">
        <?php foreach ($heroCards as $floatingCard): ?>
        <?php require COMPONENTS_PATH . '/floating-card.php'; ?>
        <?php endforeach; ?>
      </div>
    </aside>
  </div>
</section>

<section id="seguridad" class="section trust-section">
  <div class="container">
    <?php
    $sectionHeader = [
        'eyebrow' => 'Privacidad y seguridad',
        'title' => 'Una base mas confiable para identificar, cuidar y crecer sin exponer de mas',
        'description' => 'Mascotify apunta a combinar identidad clara, salud orientativa, comunidad y soporte legal desde una experiencia que transmite prudencia y orden.',
    ];
    require COMPONENTS_PATH . '/section-header.php';
    ?>
    <div class="trust-grid">
      <?php foreach ($trustCards as $trustCard): ?>
      <?php require COMPONENTS_PATH . '/trust-card.php'; ?>
      <?php endforeach; ?>
    </div>
  </div>
</section>

<section id="funciones" class="section section-accent">
  <div class="container">
    <?php
    $sectionHeader = [
        'eyebrow' => 'Funciones principales',
        'title' => 'Una composicion de funciones pensada para la vida real de cada mascota',
        'description' => 'No se trata solo de una ficha bonita: Mascotify organiza identidad, salud, ayuda comunitaria, contenido y roadmap sobre una misma base de producto.',
    ];
    require COMPONENTS_PATH . '/section-header.php';
    ?>
    <div class="editorial-grid">
      <?php foreach ($functionCards as $featureCard): ?>
      <?php require COMPONENTS_PATH . '/feature-card.php'; ?>
      <?php endforeach; ?>
    </div>
  </div>
</section>

<section id="usar-mascotify" class="section app-entry-section">
  <div class="container">
    <div class="app-entry-shell">
      <?php
      $sectionHeader = [
          'eyebrow' => 'Acceso a Mascotify',
          'title' => 'Usa Mascotify',
          'description' => 'Elegi como queres entrar: desde la web hoy o desde tu iPhone y Android cuando las apps esten disponibles.',
          'className' => 'app-entry-heading',
      ];
      require COMPONENTS_PATH . '/section-header.php';
      ?>
      <div class="app-entry-grid">
        <?php foreach ($appEntries as $appEntryCard): ?>
        <?php require COMPONENTS_PATH . '/app-entry-card.php'; ?>
        <?php endforeach; ?>
      </div>
    </div>
  </div>
</section>

<section id="legal" class="section">
  <div class="container status-grid">
    <article class="status-card">
      <p class="eyebrow">Estado del producto</p>
      <h2>Una marca en construccion, con base real para salir al mundo</h2>
      <p>
        Mascotify todavia esta en evolucion. Las funciones, los textos legales y la disponibilidad comercial
        pueden cambiar antes de la publicacion final en stores o web publica definitiva.
      </p>
      <ul class="checklist">
        <li>Version beta interna con foco en producto y presentacion.</li>
        <li>Roadmap abierto para comunidad, matching y profesionales pet.</li>
        <li>Preparado para sumar URLs publicas finales cuando existan.</li>
      </ul>
    </article>
    <article class="legal-card">
      <p class="eyebrow">Legal y soporte</p>
      <h2>Soporte, terminos y privacidad visibles desde una sola base institucional</h2>
      <p>
        La landing publica, la politica de privacidad, los terminos, soporte y eliminacion de cuenta
        ya tienen una base lista para integrarse con stores y con la app.
      </p>
      <div class="link-list">
        <a href="/privacidad">Politica de privacidad</a>
        <a href="/terminos">Terminos y condiciones</a>
        <a href="/eliminacion-de-cuenta">Eliminacion de cuenta y datos</a>
        <a href="/soporte">Soporte</a>
      </div>
    </article>
  </div>
</section>
