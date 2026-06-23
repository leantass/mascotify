<?php

declare(strict_types=1);
?>
<div class="legal-page">
  <section class="legal-hero">
    <div class="container">
      <p class="eyebrow">Cuenta y datos</p>
      <h1>Eliminacion de cuenta y datos</h1>
      <p class="lead">
        Esta pagina deja documentado el canal web que podra usarse para tiendas y para solicitudes manuales
        mientras no exista backend dedicado para esta gestion.
      </p>
    </div>
  </section>

  <section class="section">
    <div class="container split-grid">
      <article class="panel">
        <h2>Como solicitar la eliminacion</h2>
        <p>
          Hasta contar con un backend especifico, la eliminacion de cuenta y datos se procesa de forma manual
          a traves del email de soporte: <strong>[COMPLETAR EMAIL DE SOPORTE]</strong>.
        </p>
        <ol class="ordered-list">
          <li>Preparar la solicitud usando el formulario visual de esta pagina.</li>
          <li>Revisar el correo generado automaticamente.</li>
          <li>Enviar el email al contacto definitivo cuando este completado.</li>
        </ol>
      </article>

      <article class="panel">
        <h2>Que datos se eliminaran</h2>
        <ul>
          <li>Cuenta del usuario.</li>
          <li>Mascotas y perfiles asociados.</li>
          <li>Contenido relacionado con la cuenta.</li>
          <li>Datos de salud o vacunas cargados por el usuario.</li>
          <li>Clips o publicaciones, si existieran.</li>
        </ul>
      </article>

      <article class="panel">
        <h2>Que datos podrian conservarse temporalmente</h2>
        <ul>
          <li>Registros tecnicos minimos para integridad operativa.</li>
          <li>Datos necesarios para seguridad y prevencion de abuso.</li>
          <li>Informacion exigida por obligaciones legales aplicables.</li>
          <li>Backups por tiempo limitado hasta su rotacion normal.</li>
        </ul>
      </article>

      <article class="panel form-panel">
        <h2>Preparar solicitud</h2>
        <form class="deletion-form" data-deletion-form>
          <label for="nombre">Nombre</label>
          <input id="nombre" name="nombre" type="text" placeholder="Tu nombre">

          <label for="email">Email de cuenta</label>
          <input id="email" name="email" type="email" placeholder="tu-email@ejemplo.com">

          <label for="motivo">Motivo opcional</label>
          <textarea id="motivo" name="motivo" rows="5" placeholder="Podes indicar el motivo si queres."></textarea>

          <label class="checkbox">
            <input id="confirmacion" name="confirmacion" type="checkbox">
            <span>Confirmo que solicito la eliminacion de mi cuenta y datos asociados.</span>
          </label>

          <button class="button button-primary" type="submit">Preparar solicitud</button>
          <p class="helper-text">
            El boton no envia datos a un backend. Solo abre tu cliente de correo con un borrador prellenado.
          </p>
        </form>
      </article>
    </div>
  </section>
</div>
