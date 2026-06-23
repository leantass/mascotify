<?php

declare(strict_types=1);

$legalCards = [
    ['title' => 'Politica de privacidad', 'text' => 'Base editable para explicar datos, uso, terceros, seguridad y contacto.', 'href' => '/privacidad'],
    ['title' => 'Terminos y condiciones', 'text' => 'Condiciones preliminares de uso, limites y estado beta del producto.', 'href' => '/terminos'],
    ['title' => 'Eliminacion de cuenta y datos', 'text' => 'Canal web para documentar la solicitud de baja y borrado manual.', 'href' => '/eliminacion-de-cuenta'],
    ['title' => 'Soporte', 'text' => 'Contacto preliminar para privacidad, errores, seguridad y reportes.', 'href' => '/soporte'],
];
?>
<div class="legal-page">
  <section class="legal-hero">
    <div class="container">
      <p class="eyebrow">Legal</p>
      <h1>Indice legal</h1>
      <p class="lead">
        Estas paginas estan preparadas para convertirse en URLs publicas que luego podran cargarse
        en Play Console y App Store cuando el sitio se publique.
      </p>
    </div>
  </section>

  <section class="section">
    <div class="container legal-index-grid">
      <?php foreach ($legalCards as $legalCard): ?>
      <?php require COMPONENTS_PATH . '/legal-card.php'; ?>
      <?php endforeach; ?>
    </div>
  </section>
</div>
