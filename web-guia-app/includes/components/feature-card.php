<?php

declare(strict_types=1);

?>
<article class="feature-card reveal" data-tilt-card>
    <div class="feature-card-top">
        <span class="feature-icon" aria-hidden="true"><?= e($icon ?? ''); ?></span>
        <span class="feature-arrow" aria-hidden="true"></span>
    </div>
    <h3><?= e($title ?? ''); ?></h3>
    <p><?= e($text ?? ''); ?></p>
</article>
