<?php

declare(strict_types=1);

?>
<article class="feature-card reveal" data-tilt-card>
    <span class="feature-icon" aria-hidden="true"><?= e($icon ?? ''); ?></span>
    <h3><?= e($title ?? ''); ?></h3>
    <p><?= e($text ?? ''); ?></p>
</article>
