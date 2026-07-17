<?php

declare(strict_types=1);

?>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?= e($page['title']); ?></title>
    <meta name="description" content="<?= e($page['description']); ?>">
    <meta name="robots" content="<?= e($page['robots']); ?>">
    <meta name="theme-color" content="<?= e(app_config('site')['theme_color']); ?>">
    <link rel="canonical" href="<?= e($page['canonical']); ?>">
    <meta property="og:locale" content="<?= e(app_config('site')['locale']); ?>">
    <meta property="og:type" content="<?= e($page['ogType']); ?>">
    <meta property="og:title" content="<?= e($page['ogTitle']); ?>">
    <meta property="og:description" content="<?= e($page['ogDescription']); ?>">
    <meta property="og:image" content="<?= e($page['ogImage']); ?>">
    <link rel="icon" href="<?= e(asset('images/mascotify-app-icon.png')); ?>" type="image/png">
    <script>
        (function () {
            try {
                var stored = localStorage.getItem('mascotify_theme');
                var theme = stored || (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
                document.documentElement.setAttribute('data-theme', theme);
            } catch (error) {
                document.documentElement.setAttribute('data-theme', 'light');
            }
        })();
    </script>
    <link rel="preload" href="<?= e(asset('css/styles.css')); ?>" as="style">
    <link rel="stylesheet" href="<?= e(asset('css/styles.css')); ?>">
    <script type="application/ld+json"><?= $page['schemaMarkup']; ?></script>
</head>
