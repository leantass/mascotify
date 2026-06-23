<?php

declare(strict_types=1);

$pageTitle = page_title($title ?? SITE_NAME);
$pageDescription = meta_description($description ?? SITE_DESCRIPTION);
$pageCanonical = $canonical ?? canonical_url();
$pageRobots = robots_content($robots ?? 'index,follow');
$pageOgTitle = $ogTitle ?? $pageTitle;
$pageOgDescription = $ogDescription ?? $pageDescription;
$pageOgImage = og_image_url($ogImage ?? DEFAULT_OG_IMAGE);
$pageOgType = $ogType ?? 'website';
$schemas = $schemaMarkup ?? [];

if (!is_array($schemas)) {
    $schemas = [$schemas];
}
?>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="<?= e($pageDescription); ?>">
<meta name="robots" content="<?= e($pageRobots); ?>">
<meta name="theme-color" content="<?= e(PRIMARY_THEME_COLOR); ?>">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="<?= e($pageOgTitle); ?>">
<meta name="twitter:description" content="<?= e($pageOgDescription); ?>">
<meta name="twitter:image" content="<?= e($pageOgImage); ?>">
<meta property="og:locale" content="<?= e(str_replace('_', '-', SITE_LOCALE)); ?>">
<meta property="og:site_name" content="<?= e(SITE_NAME); ?>">
<meta property="og:title" content="<?= e($pageOgTitle); ?>">
<meta property="og:description" content="<?= e($pageOgDescription); ?>">
<meta property="og:image" content="<?= e($pageOgImage); ?>">
<meta property="og:type" content="<?= e($pageOgType); ?>">
<meta property="og:url" content="<?= e($pageCanonical); ?>">
<title><?= e($pageTitle); ?></title>
<link rel="canonical" href="<?= e($pageCanonical); ?>">
<link rel="icon" href="<?= e(asset('favicon/paw-icon.svg')); ?>" type="image/svg+xml">
<link rel="preload" href="<?= e(asset('css/styles.css')); ?>" as="style">
<?= css('css/styles.css'); ?>
<?= js('js/main.js'); ?>
<?php foreach ($schemas as $schema): ?>
<?php if (is_array($schema) && $schema !== []): ?>
<script type="application/ld+json"><?= schema_to_json($schema); ?></script>
<?php endif; ?>
<?php endforeach; ?>
