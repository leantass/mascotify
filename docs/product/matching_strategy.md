# Mascotify Matching Strategy

## Objetivo

Matching ayuda a elegir una mascota propia y encontrar mascotas compatibles por zona general, especie, raza, edad, energia, sociabilidad y objetivo del vinculo.

La experiencia actual es local/demo. Sirve para validar UX, criterios de compatibilidad y mensajes de privacidad antes de conectar un backend real.

## Criterios

- Misma especie: peso alto.
- Raza igual o compatible: bonus.
- Zona cercana: peso alto, siempre con localidad general.
- Edad compatible: bonus por etapa.
- Tamanio y energia: bonus cuando el ritmo es parecido.
- Sociabilidad: bonus para perfiles aptos para encuentros.
- Objetivo: paseo, juego o compania.

## Privacidad

Matching no debe mostrar telefono, email, direccion exacta, datos del tutor ni datos sensibles. La app solo muestra informacion de la mascota y zona general, como Palermo, Belgrano, Caballito, Lanus, Avellaneda o CABA.

El contacto futuro debe ser mediado por Mascotify mediante solicitud, chat seguro, bloqueo, reporte y moderacion.

## Demo local

La build actual usa mascotas de la fuente local y candidatas demo. El score es deterministico y devuelve motivos cortos para que el usuario entienda por que aparece cada resultado.

## Backend futuro

Produccion necesita:

- Consentimiento explicito para aparecer en Matching.
- Zona aproximada, nunca direccion exacta.
- Preferencias por mascota.
- Indices por especie, zona y objetivo.
- Moderacion, reportes y bloqueos.
- Chat seguro o solicitud mediada.
- Auditoria de privacidad.
- Reglas de bienestar si algun dia se habilita cruza/reproduccion.
- Controles especiales si intervienen menores.

## Regla de producto

Matching debe priorizar compania, juego y paseo. La cruza no queda activada como objetivo principal sin reglas de bienestar, consentimiento y moderacion.
