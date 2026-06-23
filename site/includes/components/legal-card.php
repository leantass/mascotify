<?php

declare(strict_types=1);

$legalCard = array_merge(
    [
        'title' => '',
        'text' => '',
        'href' => '/legal',
    ],
    $legalCard ?? []
);
?>
<a class="legal-index-card" href="<?= e((string) $legalCard['href']); ?>">
  <h2><?= e((string) $legalCard['title']); ?></h2>
  <p><?= e((string) $legalCard['text']); ?></p>
</a>
