<?php

declare(strict_types=1);

$aboutCards = [
    ['title' => 'Identidad clara', 'text' => 'Perfiles con datos esenciales, rasgos visibles y acceso rapido desde una sola app.', 'icon' => 'ID', 'className' => 'feature-card'],
    ['title' => 'Informacion util', 'text' => 'Salud, vacunas y antecedentes cargados por el usuario para tener contexto a mano.', 'icon' => 'HL', 'className' => 'feature-card'],
    ['title' => 'Comunidad y crecimiento', 'text' => 'Funciones sociales, clips y herramientas futuras para ampliar la experiencia pet.', 'icon' => 'COM', 'className' => 'feature-card'],
];

$functionCards = [
    ['title' => 'Perfil de mascota', 'text' => 'Ficha central con nombre, especie, raza, edad aproximada, tamano y rasgos distintivos.', 'icon' => 'PF', 'className' => 'info-card'],
    ['title' => 'QR seguro', 'text' => 'Identificacion visible para ayudar en extravios sin exponer telefono o email publicamente.', 'icon' => 'QR', 'className' => 'info-card'],
    ['title' => 'Salud y vacunas', 'text' => 'Registro orientativo para facilitar seguimiento, controles y recordatorios futuros.', 'icon' => 'SV', 'className' => 'info-card'],
    ['title' => 'Mascotas perdidas', 'text' => 'Herramientas para compartir informacion relevante y mejorar el circuito de ayuda comunitaria.', 'icon' => 'SOS', 'className' => 'info-card'],
    ['title' => 'Comunidad y clips', 'text' => 'Espacios sociales en evolucion para publicaciones, clips y participacion de la comunidad pet.', 'icon' => 'CL', 'className' => 'info-card'],
    ['title' => 'Matching de mascotas', 'text' => 'Funcionalidad planificada para conexion local mediada por la app y con mayor control de privacidad.', 'icon' => 'MX', 'className' => 'info-card'],
    ['title' => 'Profesionales pet futuro', 'text' => 'Base preparada para integrar especialistas y servicios de terceros en proximas etapas.', 'icon' => 'PR', 'className' => 'info-card', 'linkLabel' => 'Ver base legal', 'linkHref' => '/legal'],
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
  <div class="container hero-grid">
    <div class="hero-copy">
      <p class="eyebrow">Producto en desarrollo para familias, tutores y comunidad pet</p>
      <p class="hero-micro">QR seguro, salud, comunidad y matching para mascotas</p>
      <h1>Mascotify: una marca pensada para cuidar, conectar y proteger a tus mascotas</h1>
      <p class="lead">
        Mascotify reune perfiles de mascotas, QR seguro, salud, comunidad, clips y herramientas
        futuras para mascotas perdidas, matching y servicios pet desde una experiencia clara y confiable.
      </p>
      <div class="hero-actions">
        <a class="button button-primary" data-app-entry-link href="/#usar-mascotify">Ir a la app</a>
        <a class="button button-secondary" href="/#funciones">Conocer funciones</a>
      </div>
      <div class="trust-row" aria-label="Senales de confianza">
        <span class="trust-pill">Perfiles claros</span>
        <span class="trust-pill">Privacidad cuidada</span>
        <span class="trust-pill">Base legal lista para stores</span>
      </div>
      <ul class="hero-points">
        <li>Perfiles organizados para cada mascota.</li>
        <li>Privacidad pensada para no exponer datos sensibles.</li>
        <li>Base legal preparada para futuras publicaciones en stores.</li>
      </ul>
    </div>
    <aside class="hero-visual" aria-label="Vista conceptual de Mascotify">
      <div class="mockup-card">
        <div class="mockup-topbar">
          <span class="mockup-brand">
            <img class="mockup-logo" src="<?= e(asset('images/mascotify-logo-real.png')); ?>" alt="Mascotify" width="869" height="467">
          </span>
          <span class="mockup-chip">Beta privada</span>
        </div>
        <div class="mockup-screen">
          <div class="mockup-hero">
            <p>Perfil activo</p>
            <h2>Milo - QR listo</h2>
            <small>Contacto seguro mediado por la app</small>
          </div>
          <div class="mockup-grid">
            <article class="mockup-stat">
              <strong>Salud</strong>
              <span>Vacunas y recordatorios ordenados.</span>
            </article>
            <article class="mockup-stat">
              <strong>Comunidad</strong>
              <span>Clips y publicaciones con foco pet.</span>
            </article>
            <article class="mockup-stat">
              <strong>Matching</strong>
              <span>Conexiones futuras con mas contexto.</span>
            </article>
            <article class="mockup-stat">
              <strong>Soporte legal</strong>
              <span>URLs listas para publicacion futura.</span>
            </article>
          </div>
        </div>
      </div>
      <div class="floating-tags" aria-label="Funciones destacadas del mockup">
        <span class="floating-tag tag-one">QR seguro</span>
        <span class="floating-tag tag-two">Salud</span>
        <span class="floating-tag tag-three">Clips + Matching</span>
      </div>
    </aside>
  </div>
</section>

<section class="section section-soft">
  <div class="container">
    <?php
    $sectionHeader = [
        'eyebrow' => 'Que es Mascotify',
        'title' => 'Una plataforma pet friendly pensada para acompanar el dia a dia con mejor identidad y mas confianza',
        'description' => 'El objetivo de Mascotify es ayudar a familias y tutores a organizar mejor la informacion de sus mascotas, reforzar la identificacion y abrir espacios de comunidad con una experiencia pulida y confiable.',
    ];
    require COMPONENTS_PATH . '/section-header.php';
    ?>
    <div class="feature-strip">
      <?php foreach ($aboutCards as $featureCard): ?>
      <?php require COMPONENTS_PATH . '/feature-card.php'; ?>
      <?php endforeach; ?>
    </div>
  </div>
</section>

<section id="funciones" class="section section-accent">
  <div class="container">
    <?php
    $sectionHeader = [
        'eyebrow' => 'Funciones principales',
        'title' => 'Lo que Mascotify busca resolver',
        'description' => 'Una landing mas comercial tambien necesita explicar rapido el valor del producto. Estas son las capacidades clave sobre las que se apoya la experiencia.',
    ];
    require COMPONENTS_PATH . '/section-header.php';
    ?>
    <div class="cards-grid">
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
          'description' => 'Elegi como queres entrar: desde la web o desde tu iPhone y Android cuando las apps esten disponibles.',
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

<section id="seguridad" class="section">
  <div class="container safety-layout">
    <?php
    $sectionHeader = [
        'eyebrow' => 'Privacidad y seguridad',
        'title' => 'Disenado para compartir menos y proteger mejor',
        'description' => 'El sitio y la app priorizan un enfoque prudente: usar ubicacion aproximada cuando corresponda, evitar exposicion publica de datos privados y preparar un camino claro para eliminacion de cuenta y datos.',
    ];
    require COMPONENTS_PATH . '/section-header.php';
    ?>
    <div class="checklist-card">
      <ul class="checklist">
        <li>No exponer direccion exacta de usuarios o mascotas.</li>
        <li>No mostrar telefono ni email publicamente como dato abierto.</li>
        <li>Plantear contacto futuro mediado por Mascotify cuando la funcion lo requiera.</li>
        <li>Preparar una via de eliminacion de cuenta y datos desde una URL enlazable.</li>
      </ul>
    </div>
  </div>
</section>

<section id="legal" class="section">
  <div class="container status-grid">
    <article class="status-card">
      <p class="eyebrow">Estado del producto</p>
      <h2>Producto en desarrollo / version beta interna</h2>
      <p>
        Mascotify todavia esta en evolucion. Las funciones, los textos legales y la disponibilidad comercial
        pueden cambiar antes de la publicacion final en stores o web publica definitiva.
      </p>
    </article>
    <article class="legal-card">
      <p class="eyebrow">Bloque legal</p>
      <h2>URLs preparadas para futura publicacion</h2>
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
