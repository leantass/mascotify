<?php

declare(strict_types=1);

?>
<section class="page-hero">
    <div class="container narrow">
        <p class="eyebrow">Cuenta</p>
        <h1>Eliminacion de cuenta</h1>
        <p>Desde esta pagina puedes conocer como solicitar la eliminacion de tu cuenta de Mascotify y que ocurre con los datos asociados.</p>
    </div>
</section>

<section class="section">
    <div class="container narrow content-flow">
        <h2>Como solicitarla</h2>
        <p>Envia un correo a <a href="<?= e(support_mailto('Solicitud de eliminacion de cuenta')); ?>"><?= e(SUPPORT_EMAIL); ?></a> con el asunto "Solicitud de eliminacion de cuenta" e incluye el correo asociado a tu cuenta.</p>

        <h2>Proceso</h2>
        <p>El equipo de soporte verificara la solicitud y confirmara la eliminacion o los pasos adicionales necesarios para proteger la cuenta.</p>

        <h2>Datos eliminados</h2>
        <p>Se eliminaran los datos de cuenta y la informacion de mascotas vinculada, salvo registros que deban conservarse temporalmente por seguridad, cumplimiento legal o resolucion de incidencias.</p>

        <div class="notice">
            <strong>Tiempo estimado</strong>
            <p>Las solicitudes se revisan lo antes posible. Si falta informacion para verificar la titularidad, soporte respondera al correo informado.</p>
        </div>
    </div>
</section>
