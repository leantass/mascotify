<?php

declare(strict_types=1);

$appEntryCard = array_merge(
    [
        'title' => '',
        'text' => '',
        'badge' => '',
        'buttonLabel' => '',
        'url' => '#',
        'disabled' => false,
        'status' => '',
        'buttonVariant' => 'primary',
        'dataAttribute' => '',
        'cardClass' => '',
        'badgeClass' => '',
    ],
    $appEntryCard ?? []
);

$buttonClass = $appEntryCard['buttonVariant'] === 'secondary' ? 'button-secondary' : 'button-primary';
$href = $appEntryCard['disabled'] || is_placeholder_url((string) $appEntryCard['url']) ? '#' : (string) $appEntryCard['url'];
$dataAttribute = trim((string) $appEntryCard['dataAttribute']);
$attributeMarkup = $dataAttribute !== '' ? ' ' . $dataAttribute : '';
?>
<article class="app-entry-card<?= $appEntryCard['cardClass'] !== '' ? ' ' . e((string) $appEntryCard['cardClass']) : ''; ?>">
  <?php if ($appEntryCard['badge'] !== ''): ?>
  <span class="entry-badge<?= $appEntryCard['badgeClass'] !== '' ? ' ' . e((string) $appEntryCard['badgeClass']) : ''; ?>">
    <?= e((string) $appEntryCard['badge']); ?>
  </span>
  <?php endif; ?>
  <h3><?= e((string) $appEntryCard['title']); ?></h3>
  <p><?= e((string) $appEntryCard['text']); ?></p>
  <?php if ($appEntryCard['status'] !== ''): ?>
  <p class="entry-status"><?= e((string) $appEntryCard['status']); ?></p>
  <?php endif; ?>
  <a
    class="button <?= e($buttonClass); ?> entry-button<?= $appEntryCard['disabled'] ? ' is-disabled' : ''; ?>"
    href="<?= e($href); ?>"
    <?= $appEntryCard['disabled'] ? 'aria-disabled="true"' : ''; ?><?= $attributeMarkup; ?>
  >
    <?= e((string) $appEntryCard['buttonLabel']); ?>
  </a>
</article>
