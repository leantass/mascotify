<?php

declare(strict_types=1);

$trustCard = array_merge(
    [
        'title' => '',
        'text' => '',
        'icon' => '',
        'items' => [],
        'className' => '',
    ],
    $trustCard ?? []
);
?>
<article class="trust-card<?= $trustCard['className'] !== '' ? ' ' . e((string) $trustCard['className']) : ''; ?>">
  <div class="trust-card__head">
    <?php if ($trustCard['icon'] !== ''): ?>
    <span class="trust-card__icon" aria-hidden="true"><?= e((string) $trustCard['icon']); ?></span>
    <?php endif; ?>
    <h3><?= e((string) $trustCard['title']); ?></h3>
  </div>
  <p><?= e((string) $trustCard['text']); ?></p>
  <?php if (!empty($trustCard['items'])): ?>
  <ul class="trust-list">
    <?php foreach ($trustCard['items'] as $item): ?>
    <li><?= e((string) $item); ?></li>
    <?php endforeach; ?>
  </ul>
  <?php endif; ?>
</article>
