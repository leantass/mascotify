<?php

declare(strict_types=1);

$sectionHeader = array_merge(
    [
        'eyebrow' => '',
        'title' => '',
        'description' => '',
        'className' => '',
    ],
    $sectionHeader ?? []
);
?>
<div class="section-heading<?= $sectionHeader['className'] !== '' ? ' ' . e($sectionHeader['className']) : ''; ?>">
  <?php if ($sectionHeader['eyebrow'] !== ''): ?>
  <p class="eyebrow"><?= e($sectionHeader['eyebrow']); ?></p>
  <?php endif; ?>
  <h2><?= e($sectionHeader['title']); ?></h2>
  <?php if ($sectionHeader['description'] !== ''): ?>
  <p><?= e($sectionHeader['description']); ?></p>
  <?php endif; ?>
</div>
