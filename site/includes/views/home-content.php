<?php

declare(strict_types=1);

$benefits = [
    [
        'kicker' => 'Perfil claro',
        'title' => 'Una identidad visible para cada mascota',
        'text' => 'Nombre, especie, rasgos y contexto reunidos en un solo lugar.',
    ],
    [
        'kicker' => 'Contacto prudente',
        'title' => 'QR seguro y datos menos expuestos',
        'text' => 'La experiencia busca ayudar en extravios sin publicar telefono o email como dato abierto.',
    ],
    [
        'kicker' => 'Base institucional',
        'title' => 'Web, soporte y legales listos para enlazar',
        'text' => 'Una URL preparada para app, stores y futuras publicaciones oficiales.',
    ],
];

$storyPanels = [
    [
        'icon' => 'CU',
        'tag' => 'Cuidar',
        'title' => 'Informacion util para el dia a dia',
        'text' => 'Salud, vacunas, recordatorios y rasgos importantes se ordenan para volver mas facil el seguimiento.',
        'className' => 'story-panel story-panel--care',
    ],
    [
        'icon' => 'PR',
        'tag' => 'Proteger',
        'title' => 'Privacidad con criterio desde la base',
        'text' => 'Ubicacion aproximada, contacto mediado y menos exposicion de datos sensibles cuando mas importa.',
        'className' => 'story-panel story-panel--protect',
    ],
    [
        'icon' => 'CO',
        'tag' => 'Conectar',
        'title' => 'Comunidad y matching con mas contexto',
        'text' => 'Clips, publicaciones y funciones futuras pensadas para crecer sin perder foco pet friendly.',
        'className' => 'story-panel story-panel--connect',
    ],
];

$functionPanels = [
    [
        'icon' => 'PF',
        'tag' => 'Identidad',
        'title' => 'Perfil vivo de cada mascota',
        'text' => 'Ficha central con nombre, especie, raza, edad aproximada, tamano y rasgos distintivos.',
        'meta' => 'La base de Mascotify arranca en una ficha clara y lista para consultar rapido.',
        'className' => 'feature-panel feature-panel--hero',
    ],
    [
        'icon' => 'QR',
        'tag' => 'QR seguro',
        'title' => 'Identificacion visible para actuar mejor',
        'text' => 'Un QR ayuda en extravios sin exponer telefono ni email publicamente.',
        'className' => 'feature-panel feature-panel--teal',
    ],
    [
        'icon' => 'SV',
        'tag' => 'Salud',
        'title' => 'Vacunas y controles con mas orden',
        'text' => 'Registro orientativo para facilitar seguimiento, controles y recordatorios futuros.',
        'className' => 'feature-panel feature-panel--support',
    ],
    [
        'icon' => 'SO',
        'tag' => 'Mascotas perdidas',
        'title' => 'Contexto mas rapido cuando una mascota falta',
        'text' => 'Herramientas pensadas para compartir informacion relevante y mejorar el circuito de ayuda comunitaria.',
        'className' => 'feature-panel feature-panel--wide',
    ],
    [
        'icon' => 'CL',
        'tag' => 'Clips',
        'title' => 'Contenido y comunidad con tono pet',
        'text' => 'Espacios sociales en evolucion para publicaciones, clips y participacion responsable.',
        'className' => 'feature-panel feature-panel--rose',
    ],
    [
        'icon' => 'MX',
        'tag' => 'Matching',
        'title' => 'Conexiones futuras con mas privacidad',
        'text' => 'Base preparada para matching local mediado por la app y con mas control del contexto.',
        'meta' => 'Tambien deja espacio para profesionales pet y servicios de terceros en proximas etapas.',
        'linkLabel' => 'Ver base legal',
        'linkHref' => '/legal',
        'className' => 'feature-panel feature-panel--tall',
    ],
    [
        'icon' => 'PR',
        'tag' => 'Roadmap',
        'title' => 'Mascotify crece sobre una base institucional real',
        'text' => 'Landing, soporte, terminos y eliminacion de cuenta listos para integrarse con stores y con la app.',
        'className' => 'feature-panel feature-panel--ink',
    ],
];

$appEntries = [
    [
        'badge' => 'Web',
        'cardClass' => 'app-entry-card-web',
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
  <div class="container">
    <div class="hero-board">
      <aside class="hero-passport" aria-label="Tarjeta de mascota destacada">
        <span class="hero-passport__kicker">Mascota destacada</span>
        <div class="hero-passport__brand">
          <img src="<?= e(asset('images/mascotify-logo-real.png')); ?>" alt="Mascotify" width="869" height="467">
        </div>
        <div class="hero-passport__card">
          <p class="hero-passport__label">Perfil activo</p>
          <h2>Milo</h2>
          <p>QR listo, rasgos visibles y contacto mediado por la app.</p>
          <div class="hero-passport__chips">
            <span>QR seguro</span>
            <span>Salud</span>
            <span>Comunidad</span>
          </div>
        </div>
      </aside>

      <div class="hero-manifesto">
        <p class="eyebrow">Producto en desarrollo para familias, tutores y comunidad pet</p>
        <h1>Mascotify: una marca pensada para cuidar, conectar y proteger a tus mascotas</h1>
        <p class="lead">
          Mascotify reune perfiles de mascotas, QR seguro, salud, comunidad, clips y herramientas
          futuras para mascotas perdidas, matching y servicios pet desde una experiencia clara y confiable.
        </p>
        <div class="hero-actions">
          <a class="button button-primary" data-app-entry-link href="/#usar-mascotify">Ir a la app</a>
          <a class="button button-secondary" href="/#funciones">Conocer funciones</a>
        </div>
        <div class="hero-rail" aria-label="Claves de Mascotify">
          <article class="hero-rail__item">
            <strong>QR seguro</strong>
            <span>Identificacion visible para ayudar sin exponer datos sensibles.</span>
          </article>
          <article class="hero-rail__item">
            <strong>Base legal lista</strong>
            <span>Soporte, terminos y privacidad enlazables desde una URL institucional.</span>
          </article>
        </div>
      </div>

      <aside class="hero-console" aria-label="Panel de experiencia Mascotify">
        <article class="hero-console__panel">
          <span class="hero-console__tag">Ahora</span>
          <h3>Un mismo ecosistema para identidad, salud y soporte.</h3>
          <ul class="hero-console__list">
            <li>Perfiles claros para cada mascota.</li>
            <li>Salud y vacunas con seguimiento orientativo.</li>
            <li>Comunidad, clips y matching futuro con mas contexto.</li>
          </ul>
        </article>
        <article class="hero-console__panel hero-console__panel--accent">
          <span class="hero-console__tag">Criterio</span>
          <p>Ubicacion aproximada, contacto prudente y una base preparada para crecer hacia web, stores y funciones futuras.</p>
        </article>
      </aside>
    </div>

    <div class="benefit-strip" aria-label="Beneficios rapidos de Mascotify">
      <?php foreach ($benefits as $benefit): ?>
      <article class="benefit-card">
        <span class="benefit-card__kicker"><?= e((string) $benefit['kicker']); ?></span>
        <h2><?= e((string) $benefit['title']); ?></h2>
        <p><?= e((string) $benefit['text']); ?></p>
      </article>
      <?php endforeach; ?>
    </div>
  </div>
</section>

<section class="section story-section">
  <div class="container story-layout">
    <div class="story-copy">
      <?php
      $sectionHeader = [
          'eyebrow' => 'Cuidar, proteger, conectar',
          'title' => 'Un ecosistema visual de cuidado, seguridad y comunidad para mascotas',
          'description' => 'Mascotify no busca ser otra landing generica: propone una presencia institucional para la app con una identidad mas editorial y preparada para crecer.',
      ];
      require COMPONENTS_PATH . '/section-header.php';
      ?>
    </div>
    <div class="story-stack">
      <?php foreach ($storyPanels as $featurePanel): ?>
      <?php require COMPONENTS_PATH . '/feature-panel.php'; ?>
      <?php endforeach; ?>
    </div>
  </div>
</section>

<section id="seguridad" class="section assurance-section">
  <div class="container assurance-shell">
    <div class="assurance-copy">
      <?php
      $sectionHeader = [
          'eyebrow' => 'Privacidad y seguridad',
          'title' => 'Disenado para compartir menos, ordenar mejor y reaccionar con mas contexto',
          'description' => 'El sitio y la app priorizan un enfoque prudente: ubicacion aproximada, menos exposicion publica y una via clara para soporte y eliminacion de cuenta.',
      ];
      require COMPONENTS_PATH . '/section-header.php';
      ?>
      <ul class="assurance-list">
        <li>No exponer direccion exacta de usuarios o mascotas.</li>
        <li>No mostrar telefono ni email publicamente como dato abierto.</li>
        <li>Plantear contacto futuro mediado por Mascotify cuando la funcion lo requiera.</li>
      </ul>
    </div>
    <div class="assurance-grid">
      <article class="assurance-card">
        <span class="assurance-card__label">Cuidado</span>
        <h3>Datos utiles para actuar sin ruido</h3>
        <p>Perfiles, salud y antecedentes visibles sin perder criterio sobre que conviene compartir y que no.</p>
      </article>
      <article class="assurance-card assurance-card--accent">
        <span class="assurance-card__label">Control</span>
        <h3>Soporte y baja documentados</h3>
        <p>La base web ya contempla soporte, privacidad, terminos y eliminacion de cuenta como URLs enlazables.</p>
      </article>
    </div>
  </div>
</section>

<section id="funciones" class="section functions-section">
  <div class="container">
    <?php
    $sectionHeader = [
        'eyebrow' => 'Funciones principales',
        'title' => 'Una composicion editorial para mostrar lo que Mascotify busca resolver',
        'description' => 'La app combina identidad, salud, ayuda comunitaria, contenido y roadmap en una estructura pensada para mascotas, familias y futuros servicios pet.',
    ];
    require COMPONENTS_PATH . '/section-header.php';
    ?>
    <div class="feature-editorial">
      <?php foreach ($functionPanels as $featurePanel): ?>
      <?php require COMPONENTS_PATH . '/feature-panel.php'; ?>
      <?php endforeach; ?>
    </div>
  </div>
</section>

<section id="usar-mascotify" class="section platform-section">
  <div class="container platform-shell">
    <div class="platform-copy">
      <?php
      $sectionHeader = [
          'eyebrow' => 'Acceso a Mascotify',
          'title' => 'Usa Mascotify',
          'description' => 'Elegi como queres entrar: desde la web hoy o desde tu iPhone y Android cuando las apps esten disponibles.',
      ];
      require COMPONENTS_PATH . '/section-header.php';
      ?>
      <p class="platform-copy__note">
        La experiencia publica queda preparada para sumar las URLs reales cuando existan, sin inventar enlaces ni forzar estados de publicacion.
      </p>
    </div>
    <div class="platform-grid">
      <?php foreach ($appEntries as $appEntryCard): ?>
      <?php require COMPONENTS_PATH . '/app-entry-card.php'; ?>
      <?php endforeach; ?>
    </div>
  </div>
</section>

<section id="legal" class="section readiness-section">
  <div class="container readiness-grid">
    <article class="readiness-card">
      <p class="eyebrow">Estado del producto</p>
      <h2>Producto en desarrollo / version beta interna</h2>
      <p>
        Mascotify todavia esta en evolucion. Las funciones, los textos legales y la disponibilidad comercial
        pueden cambiar antes de la publicacion final en stores o web publica definitiva.
      </p>
    </article>
    <article class="readiness-card readiness-card--links">
      <p class="eyebrow">Legal y soporte</p>
      <h2>Una base institucional lista para enlazar desde app y stores</h2>
      <div class="link-list">
        <a href="/privacidad">Politica de privacidad</a>
        <a href="/terminos">Terminos y condiciones</a>
        <a href="/eliminacion-de-cuenta">Eliminacion de cuenta y datos</a>
        <a href="/soporte">Soporte</a>
      </div>
    </article>
    <article class="readiness-card readiness-card--support">
      <p class="eyebrow">Mascotify Web</p>
      <h2>Web, App Store y Play Store conviven en una misma base visual</h2>
      <p>
        La seccion de acceso mantiene sus placeholders y estados actuales mientras el dominio y las apps definitivas siguen en definicion.
      </p>
    </article>
  </div>
</section>
