<?php

declare(strict_types=1);

?>
<article class="legal-card reveal">
    <span class="legal-badge"><?= e($label ?? 'Legal'); ?></span>
    <h3><?= e($title ?? ''); ?></h3>
    <p><?= e($text ?? ''); ?></p>
    <?php if (!empty($href)): ?>
        <a class="text-link" href="<?= e($href); ?>"><?= e($cta ?? 'Ver documento'); ?></a>
    <?php endif; ?>
</article>
