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
      <div class="footer-layout">
        <div class="footer-brand">
          <p class="footer-heading">Mascotify</p>
          <h2>Una marca pensada para cuidar, conectar y proteger a tus mascotas.</h2>
          <p><?= e(SITE_TAGLINE); ?> con una experiencia clara, moderna y lista para crecer hacia web, app y stores.</p>
          <div class="footer-pill-row" aria-label="Capacidades principales">
            <span class="footer-pill">QR seguro</span>
            <span class="footer-pill">Salud</span>
            <span class="footer-pill">Comunidad</span>
            <span class="footer-pill">Base legal</span>
          </div>
        </div>

        <div class="footer-spotlight">
          <img
            src="<?= e(asset('images/mascotify-logo-real.png')); ?>"
            alt="Mascotify"
            width="869"
            height="467"
            loading="lazy"
          >
          <p class="footer-spotlight__eyebrow">Acceso actual</p>
          <h3>Web lista para enlazar, soporte documentado y stores preparados para sumar URLs reales.</h3>
          <a class="button button-footer" data-app-entry-link href="<?= e((string) ($navCta['href'] ?? '/#usar-mascotify')); ?>">
            <?= e((string) ($navCta['label'] ?? 'Ir a la app')); ?>
          </a>
        </div>

        <div class="footer-columns">
          <div class="footer-column">
            <p class="footer-heading">Producto</p>
            <div class="footer-link-group">
              <?php foreach ($navItems as $item): ?>
              <a href="<?= e((string) ($item['href'] ?? '/')); ?>"><?= e((string) ($item['label'] ?? '')); ?></a>
              <?php endforeach; ?>
              <a data-app-entry-link href="<?= e((string) ($navCta['href'] ?? '/#usar-mascotify')); ?>">
                <?= e((string) ($navCta['label'] ?? 'Ir a la app')); ?>
              </a>
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
        </div>
      </div>

      <div class="footer-bottom">
        <p>Mascotify es un producto en desarrollo. Las funciones pueden cambiar antes de su publicacion final.</p>
        <p>Logo real, paleta propia y arquitectura PHP separada para evolucionar sin perder consistencia.</p>
      </div>
    </div>
  </div>
</footer>
