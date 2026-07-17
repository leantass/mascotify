<?php

declare(strict_types=1);

$href = (string)($url ?? '');
$disabled = is_placeholder_url($href);

?>
<article class="platform-card reveal" data-tilt-card>
    <span class="platform-badge"><?= e($badge ?? 'APP'); ?></span>
    <h3><?= e($title ?? ''); ?></h3>
    <p><?= e($text ?? ''); ?></p>
    <div class="platform-action">
        <?php if ($disabled): ?>
            <span class="status-pill">Disponible proximamente</span>
            <a class="button platform-button disabled" href="#" aria-disabled="true" data-disabled-link><?= e($button ?? 'Proximamente'); ?></a>
        <?php else: ?>
            <span class="status-pill ready">Disponible</span>
            <a class="button platform-button" href="<?= e($href); ?>" target="_blank" rel="noopener"><?= e($button ?? 'Abrir'); ?></a>
        <?php endif; ?>
    </div>
</article>
