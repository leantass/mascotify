<?php

declare(strict_types=1);
?>
<a class="skip-link" href="#contenido">Saltar al contenido</a>
<header class="site-header">
  <div class="container nav-shell">
    <a class="brand" href="/" aria-label="Mascotify inicio">
      <img
        src="<?= e(asset('images/mascotify-logo-real.png')); ?>"
        alt="Mascotify"
        width="869"
        height="467"
        fetchpriority="high"
      >
    </a>
    <button class="nav-toggle" type="button" aria-expanded="false" aria-controls="primary-nav" aria-label="Abrir menu">
      <span></span>
      <span></span>
      <span></span>
      <span class="sr-only">Abrir menu</span>
    </button>
    <?php require LAYOUT_PATH . '/navigation.php'; ?>
  </div>
</header>
