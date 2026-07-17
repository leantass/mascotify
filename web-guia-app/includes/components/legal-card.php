<?php

declare(strict_types=1);

?>
<article class="legal-card">
    <p class="eyebrow"><?= e($label ?? 'Documento'); ?></p>
    <h3><?= e($title ?? ''); ?></h3>
    <p><?= e($text ?? ''); ?></p>
    <?php if (!empty($href)): ?>
        <a class="text-link" href="<?= e($href); ?>"><?= e($cta ?? 'Ver documento'); ?></a>
    <?php endif; ?>
</article>
