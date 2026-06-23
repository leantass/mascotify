<?php

declare(strict_types=1);

$navigation = require LAYOUT_PATH . '/navigation-data.php';
$navItems = $navigation['primary'] ?? [];
$legalItems = $navigation['footerLegal'] ?? [];
$navCta = $navigation['cta'] ?? ['label' => 'Ir a la app', 'href' => '/#usar-mascotify'];
?>
<footer class="site-footer">
  <div class="container">
    <div class="footer-shell">
      <div class="footer-top">
        <div class="footer-brand-block">
          <img
            src="<?= e(asset('images/mascotify-logo-real.png')); ?>"
            alt="Mascotify"
            width="869"
            height="467"
            loading="lazy"
          >
          <p class="footer-brand-block__eyebrow">Mascotify</p>
          <h2><?= e(SITE_TAGLINE); ?></h2>
          <p>Una base publica para cuidar, conectar y proteger a tus mascotas con una experiencia clara y lista para crecer.</p>
          <a class="button button-footer" data-app-entry-link href="<?= e((string) ($navCta['href'] ?? '/#usar-mascotify')); ?>">
            <?= e((string) ($navCta['label'] ?? 'Ir a la app')); ?>
          </a>
        </div>

        <div class="footer-links-shell">
          <div class="footer-column">
            <p class="footer-heading">Producto</p>
            <div class="footer-link-group">
              <?php foreach ($navItems as $item): ?>
              <a href="<?= e((string) ($item['href'] ?? '/')); ?>"><?= e((string) ($item['label'] ?? '')); ?></a>
              <?php endforeach; ?>
            </div>
          </div>

          <div class="footer-column">
            <p class="footer-heading">Legal</p>
            <div class="footer-link-group">
              <?php foreach ($legalItems as $item): ?>
              <a href="<?= e((string) ($item['href'] ?? '/')); ?>"><?= e((string) ($item['label'] ?? '')); ?></a>
              <?php endforeach; ?>
            </div>
          </div>

          <div class="footer-column footer-column--note">
            <p class="footer-heading">Estado actual</p>
            <p>Mascotify es un producto en desarrollo. Las funciones pueden cambiar antes de su publicacion final.</p>
          </div>
        </div>
      </div>

      <div class="footer-bottom">
        <p>Logo real, paleta Mascotify y arquitectura PHP separada para evolucionar sin perder consistencia.</p>
        <p>Links legales, soporte y acceso a la app visibles desde una misma presencia institucional.</p>
      </div>
    </div>
  </div>
</footer>
