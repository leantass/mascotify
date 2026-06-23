<?php

declare(strict_types=1);

function page_title(string $title): string
{
    return trim($title) !== '' ? $title : SITE_NAME;
}

function meta_description(string $description): string
{
    return trim($description) !== '' ? $description : SITE_DESCRIPTION;
}

function robots_content(string $robots): string
{
    return trim($robots) !== '' ? $robots : 'index,follow';
}

function og_image_url(?string $image = null): string
{
    $imagePath = $image ?? DEFAULT_OG_IMAGE;

    return absolute_url($imagePath);
}

function schema_to_json(array $schema): string
{
    return (string) json_encode(
        $schema,
        JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT | JSON_THROW_ON_ERROR
    );
}

function build_breadcrumb_schema(array $items): array
{
    $listItems = [];

    foreach ($items as $index => $item) {
        $listItems[] = [
            '@type' => 'ListItem',
            'position' => $index + 1,
            'name' => $item['name'] ?? '',
            'item' => absolute_url($item['url'] ?? '/'),
        ];
    }

    return [
        '@context' => 'https://schema.org',
        '@type' => 'BreadcrumbList',
        'itemListElement' => $listItems,
    ];
}

function build_web_page_schema(array $data): array
{
    return [
        '@context' => 'https://schema.org',
        '@type' => 'WebPage',
        'name' => $data['title'] ?? SITE_NAME,
        'description' => $data['description'] ?? SITE_DESCRIPTION,
        'url' => $data['url'] ?? absolute_url('/'),
        'inLanguage' => str_replace('_', '-', SITE_LOCALE),
        'isPartOf' => [
            '@type' => 'WebSite',
            'name' => SITE_NAME,
            'url' => SITE_BASE_URL,
        ],
    ];
}

function build_faq_schema(array $items): array
{
    $entities = [];

    foreach ($items as $item) {
        $entities[] = [
            '@type' => 'Question',
            'name' => $item['question'] ?? '',
            'acceptedAnswer' => [
                '@type' => 'Answer',
                'text' => $item['answer'] ?? '',
            ],
        ];
    }

    return [
        '@context' => 'https://schema.org',
        '@type' => 'FAQPage',
        'mainEntity' => $entities,
    ];
}
