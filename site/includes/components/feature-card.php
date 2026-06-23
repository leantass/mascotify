<?php

declare(strict_types=1);

$featureCard = array_merge(
    [
        'title' => '',
        'text' => '',
        'icon' => '',
        'className' => 'feature-card',
        'linkLabel' => '',
        'linkHref' => '',
    ],
    $featureCard ?? []
);
?>
<article class="<?= e($featureCard['className']); ?>">
  <?php if ($featureCard['icon'] !== ''): ?>
  <span class="card-icon" aria-hidden="true"><?= e($featureCard['icon']); ?></span>
  <?php endif; ?>
  <h3><?= e($featureCard['title']); ?></h3>
  <p><?= e($featureCard['text']); ?></p>
  <?php if ($featureCard['linkLabel'] !== '' && $featureCard['linkHref'] !== ''): ?>
  <a class="card-link" href="<?= e($featureCard['linkHref']); ?>"><?= e($featureCard['linkLabel']); ?></a>
  <?php endif; ?>
</article>
