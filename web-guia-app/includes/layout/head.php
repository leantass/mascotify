<?php

declare(strict_types=1);

?>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?= e($pageMeta['title']); ?></title>
    <meta name="description" content="<?= e($pageMeta['description']); ?>">
    <meta name="theme-color" content="<?= e($pageMeta['theme_color']); ?>">
    <link rel="canonical" href="<?= e($pageMeta['canonical']); ?>">
    <meta property="og:locale" content="<?= e($pageMeta['locale']); ?>">
    <meta property="og:type" content="website">
    <meta property="og:title" content="<?= e($pageMeta['title']); ?>">
    <meta property="og:description" content="<?= e($pageMeta['description']); ?>">
    <meta property="og:image" content="<?= e($pageMeta['og_image']); ?>">
    <link rel="icon" href="<?= e(asset('images/mascotify-logo.svg')); ?>" type="image/svg+xml">
    <link rel="stylesheet" href="<?= e(asset('css/styles.css')); ?>">
    <script type="application/ld+json"><?= organization_schema($appConfig); ?></script>
</head>
