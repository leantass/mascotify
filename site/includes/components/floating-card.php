<?php

declare(strict_types=1);

$floatingCard = array_merge(
    [
        'title' => '',
        'text' => '',
        'badge' => '',
        'className' => '',
    ],
    $floatingCard ?? []
);
?>
<article class="floating-card<?= $floatingCard['className'] !== '' ? ' ' . e((string) $floatingCard['className']) : ''; ?>">
  <?php if ($floatingCard['badge'] !== ''): ?>
  <span class="floating-card__badge"><?= e((string) $floatingCard['badge']); ?></span>
  <?php endif; ?>
  <h3><?= e((string) $floatingCard['title']); ?></h3>
  <p><?= e((string) $floatingCard['text']); ?></p>
</article>
