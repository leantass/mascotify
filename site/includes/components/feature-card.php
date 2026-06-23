<?php

declare(strict_types=1);

$featureCard = array_merge(
    [
        'title' => '',
        'text' => '',
        'icon' => '',
        'eyebrow' => '',
        'className' => 'feature-card',
        'linkLabel' => '',
        'linkHref' => '',
        'meta' => '',
    ],
    $featureCard ?? []
);
?>
<article class="<?= e($featureCard['className']); ?>">
  <?php if ($featureCard['icon'] !== '' || $featureCard['eyebrow'] !== ''): ?>
  <div class="card-top">
    <?php if ($featureCard['icon'] !== ''): ?>
    <span class="card-icon" aria-hidden="true"><?= e($featureCard['icon']); ?></span>
    <?php endif; ?>
    <?php if ($featureCard['eyebrow'] !== ''): ?>
    <span class="card-eyebrow"><?= e($featureCard['eyebrow']); ?></span>
    <?php endif; ?>
  </div>
  <?php endif; ?>
  <h3><?= e($featureCard['title']); ?></h3>
  <p><?= e($featureCard['text']); ?></p>
  <?php if ($featureCard['meta'] !== ''): ?>
  <p class="card-meta"><?= e($featureCard['meta']); ?></p>
  <?php endif; ?>
  <?php if ($featureCard['linkLabel'] !== '' && $featureCard['linkHref'] !== ''): ?>
  <a class="card-link" href="<?= e($featureCard['linkHref']); ?>"><?= e($featureCard['linkLabel']); ?></a>
  <?php endif; ?>
</article>
