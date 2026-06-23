<?php

declare(strict_types=1);

$navigation = require LAYOUT_PATH . '/navigation-data.php';
$navItems = $navigation['primary'] ?? [];
$navCta = $navigation['cta'] ?? ['label' => 'Ir a la app', 'href' => '/#usar-mascotify'];
?>
<nav id="primary-nav" class="site-nav" aria-label="Principal">
  <?php foreach ($navItems as $item): ?>
  <?php $isActive = nav_is_active((string) ($item['href'] ?? '/')); ?>
  <a href="<?= e((string) ($item['href'] ?? '/')); ?>"<?= $isActive ? ' class="is-active"' : ''; ?>>
    <?= e((string) ($item['label'] ?? '')); ?>
  </a>
  <?php endforeach; ?>
  <a class="button button-primary nav-app-link" data-app-entry-link href="<?= e((string) ($navCta['href'] ?? '/#usar-mascotify')); ?>">
    <?= e((string) ($navCta['label'] ?? 'Ir a la app')); ?>
  </a>
</nav>
