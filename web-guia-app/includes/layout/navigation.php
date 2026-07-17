<?php

declare(strict_types=1);

?>
<nav id="primary-navigation" class="primary-nav" aria-label="Navegacion principal">
    <?php foreach (nav_items() as $item): ?>
        <a href="<?= e(url($item['href'])); ?>"><?= e($item['label']); ?></a>
    <?php endforeach; ?>
</nav>
