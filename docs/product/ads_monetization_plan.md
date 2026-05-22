# Mascotify - Ads Monetization Plan

## Resumen

Mascotify puede monetizar con publicidad, pero la experiencia debe seguir siendo confiable, clara y segura. La publicidad se reserva para zonas de consumo pasivo o descubrimiento, y queda excluida de pantallas sensibles donde la persona resuelve identidad, salud, seguridad, mensajes, privacidad o pagos.

Esta fase no activa anuncios reales. Solo prepara placements, placeholders, reglas por plan, sponsors identificados y rewarded ads en modo demo/local.

## Criterio Por Plan

- Mascotify Free: puede ver placeholders de publicidad y sponsors en superficies permitidas.
- Mascotify Plus: no ve anuncios externos, banners, native ads ni rewarded ads publicitarios.
- Mascotify Pro: no ve anuncios externos, banners, native ads ni rewarded ads publicitarios.

## Formatos Permitidos

- Native ads: Explorar, Clips y listados de profesionales, idealmente cada 5 o 6 elementos reales.
- Banners controlados: Actividad, Explorar y navegacion general de consumo pasivo.
- Rewarded ads: acciones opcionales como subir un clip extra, destacar un clip por 24 horas o probar una funcion Plus temporalmente.
- Sponsors directos: profesional destacado, sponsor de categoria, banner local, clip patrocinado, campana de adopcion patrocinada, cupon exclusivo o beneficio para Plus.
- Interstitials: modelados pero deshabilitados hasta revision de UX y politicas.

## Identificacion Obligatoria

Todo espacio publicitario debe mostrar una etiqueta visible:

- Anuncio
- Patrocinado
- Profesional destacado

La publicidad nunca debe parecer contenido organico sin identificar.

## Pantallas Permitidas

- Explorar.
- Feed de Clips.
- Listados de profesionales.
- Actividad.
- Secciones generales de consumo pasivo.

## Pantallas Prohibidas

No debe haber anuncios en:

- Login.
- Registro.
- Onboarding inicial.
- Perfil de mascota.
- QR de mascota.
- Salud y vacunas.
- Reporte de mascota perdida.
- Mascotas perdidas.
- Reporte de avistaje.
- Historial critico.
- Mensajes.
- Conversaciones.
- Notificaciones importantes.
- Pantallas de emergencia.
- Checkout.
- Pantalla de suscripcion.
- Configuracion de privacidad.

Salud y vacunas se trata como pantalla sensible por criterio sanitario, aunque haya nacido despues de la documentacion financiera.

## Frecuencia Recomendada

- Native ads: cada 5 o 6 elementos reales, o entre bloques naturales cuando el feed todavia es pequeno.
- Banners: maximo un bloque por pantalla, sin tapar contenido ni acciones.
- Rewarded: siempre opcional y posterior a una accion iniciada por el usuario.
- Interstitials: deshabilitados hasta nueva revision.

## AdMob, AdSense Y Google Ads

AdMob sirve para monetizar apps Android/iOS mostrando anuncios dentro de la app. Requiere cuenta AdMob, app creada, unidades de anuncio, SDK, test ads, app-ads.txt y revision/aprobacion.

AdSense sirve para monetizar sitios web publicos. No aplica a la app Flutter mobile y requiere sitio publico revisado.

Google Ads sirve para pagar campanas y conseguir usuarios. No sirve para que Mascotify gane dinero mostrando anuncios dentro de la app.

## Sponsors Directos

Los sponsors directos pueden usarse para profesional destacado, sponsor de categoria, cupon, campana local o clip patrocinado. Siempre deben estar identificados como Patrocinado, Anuncio o Profesional destacado.

## Riesgos

- Perder confianza si aparecen anuncios en salud, QR, mensajes o privacidad.
- Generar confusion si un sponsor parece recomendacion organica.
- Incumplir politicas si se activan anuncios reales sin consentimiento, test mode o revision.
- Afectar UX si se usan interstitials o banners invasivos.

## Por Que No Activar Ads Reales Todavia

La app todavia esta en modo local/demo y no tiene la preparacion completa de AdMob real: cuenta, app IDs, ad units, SDK, consentimiento UMP, Data Safety, app-ads.txt ni revision de politicas. Primero corresponde validar arquitectura, ubicaciones, frecuencia y exclusion de pantallas sensibles.
