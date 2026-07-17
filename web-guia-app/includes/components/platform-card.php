<?php

declare(strict_types=1);

?>
<article class="platform-card">
    <div>
        <h3><?= e($title ?? ''); ?></h3>
        <p><?= e($text ?? ''); ?></p>
    </div>
    <?php if (!empty($status)): ?>
        <span><?= e($status); ?></span>
    <?php endif; ?>
</article>
