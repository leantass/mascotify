<?php

declare(strict_types=1);

$featurePanel = array_merge(
    [
        'title' => '',
        'text' => '',
        'icon' => '',
        'tag' => '',
        'className' => '',
        'linkLabel' => '',
        'linkHref' => '',
        'meta' => '',
    ],
    $featurePanel ?? []
);
?>
<article class="feature-panel<?= $featurePanel['className'] !== '' ? ' ' . e((string) $featurePanel['className']) : ''; ?>">
  <div class="feature-panel__top">
    <?php if ($featurePanel['icon'] !== ''): ?>
    <span class="feature-panel__icon" aria-hidden="true"><?= e((string) $featurePanel['icon']); ?></span>
    <?php endif; ?>
    <?php if ($featurePanel['tag'] !== ''): ?>
    <span class="feature-panel__tag"><?= e((string) $featurePanel['tag']); ?></span>
    <?php endif; ?>
  </div>
  <h3><?= e((string) $featurePanel['title']); ?></h3>
  <p><?= e((string) $featurePanel['text']); ?></p>
  <?php if ($featurePanel['meta'] !== ''): ?>
  <p class="feature-panel__meta"><?= e((string) $featurePanel['meta']); ?></p>
  <?php endif; ?>
  <?php if ($featurePanel['linkLabel'] !== '' && $featurePanel['linkHref'] !== ''): ?>
  <a class="feature-panel__link" href="<?= e((string) $featurePanel['linkHref']); ?>"><?= e((string) $featurePanel['linkLabel']); ?></a>
  <?php endif; ?>
</article>
