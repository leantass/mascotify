<?php

declare(strict_types=1);

?>
<section class="page-hero">
    <div class="container narrow">
        <p class="eyebrow">Ayuda</p>
        <h1>Soporte de Mascotify</h1>
        <p>Estamos para ayudarte con acceso, cuenta, datos de mascotas, funcionamiento de la app y consultas legales.</p>
    </div>
</section>

<section class="section">
    <div class="container split">
        <div class="content-flow">
            <h2>Contacto</h2>
            <p>Para recibir ayuda, envia un correo a <a href="<?= e(support_mailto()); ?>"><?= e(SUPPORT_EMAIL); ?></a> con una descripcion clara del problema.</p>
            <p>Incluye el correo de tu cuenta, modelo de dispositivo, version de la app si la conoces y capturas cuando ayuden a entender el caso.</p>
            <a class="button primary" href="<?= e(support_mailto()); ?>">Enviar consulta</a>
        </div>
        <div class="support-list" aria-label="Temas de soporte">
            <div><strong>Acceso</strong><span>Inicio de sesion, correo y recuperacion.</span></div>
            <div><strong>Datos</strong><span>Perfiles, mascotas y contenido guardado.</span></div>
            <div><strong>Legal</strong><span>Privacidad, terminos y eliminacion.</span></div>
        </div>
    </div>
</section>
