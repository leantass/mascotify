<?php

declare(strict_types=1);

?>
<nav id="primary-navigation" class="primary-nav" aria-label="Navegacion principal">
    <?php foreach (nav_items() as $key => $item): ?>
        <a
            href="<?= e(page_url($item['path'])); ?>"
            class="<?= is_current_page($key) ? 'is-active' : ''; ?>"
            <?= is_current_page($key) ? 'aria-current="page"' : ''; ?>
        >
            <?= e($item['label']); ?>
        </a>
    <?php endforeach; ?>
</nav>
