# Demo Content Strategy

## Objetivo

Mascotify usa contenido demo/local para que Explorar y Clips no se sientan vacios durante pruebas, demos internas y primeras sesiones sin usuarios reales activos.

El objetivo es mostrar una experiencia viva sin simular una comunidad real inexistente.

## Demo, seeded y usuarios reales

- Contenido demo: datos locales incluidos en la app para pruebas y onboarding.
- Contenido seeded: datos iniciales marcados internamente para poblar una experiencia controlada.
- Usuarios reales: cuentas creadas por personas o negocios reales, con contenido propio y permisos reales.

Las cuentas demo no deben mezclarse semanticamente con usuarios reales. En Flutter quedan marcadas con `isDemoAccount: true`; los clips quedan marcados con `isDemoContent: true` y `sourceLabel: Contenido inicial`.

## Regla de transparencia

Mascotify no debe presentar estas cuentas como usuarios reales opacos. La UI puede mostrarlas como "Demo", "Contenido inicial", "Contenido destacado" o "Perfiles sugeridos", pero nunca como actividad real no verificada.

## Assets y licencias

No se descargan videos de internet ni se usan videos de terceros sin licencia. Los clips iniciales usan metadata local, placeholders visuales seguros y `demoVideoKey` para futura sustitucion por assets propios o licenciados.

## Como desactivar contenido demo

El contenido demo se sirve desde `ClipsMockData.clips` mediante `AppData.exploreClips` y como fallback de `SocialClipsRepository` cuando el backend no responde o no devuelve clips.

Para desactivarlo en un entorno futuro:

1. Cambiar el proveedor de fallback de `SocialClipsRepository`.
2. Evitar que `AppData.exploreClips` use `ClipsMockData.clips`.
3. Mantener el estado vacio de Clips para cuando no existan clips reales.

## Migracion a produccion

Antes de usar contenido en produccion, elegir una politica explicita:

- convertirlo en contenido oficial/curado por Mascotify;
- reemplazarlo por sponsors o creadores con permisos firmados;
- migrarlo a un seed backend con flags `isDemoAccount` e `isDemoContent`;
- eliminarlo cuando haya suficiente contenido real.

No ejecutar seeds demo contra produccion sin una revision manual de producto, legal y datos.

## Cuentas demo incluidas

1. Milo y su Banda (`milo_banda`)
2. Lola Gatuna (`lola_gatuna`)
3. Huellitas Urbanas (`huellitas_urbanas`)
4. Conejo Nube (`conejo_nube`)
5. Refugio Patitas Demo (`refugio_patitas_demo`)
6. Bigotes & Ronroneos (`bigotes_ronroneos`)
7. Rocky Entrena (`rocky_entrena`)
8. Bruno Senior (`bruno_senior`)
9. Mini Mundo Pet (`mini_mundo_pet`)
10. Aqua Mascotify (`aqua_mascotify`)
11. Plumas en Casa (`plumas_en_casa`)
12. Vet Tips Demo (`vet_tips_demo`)

## Clips demo incluidos

Hay 36 clips demo iniciales, con 2 a 4 clips por cuenta. Cubren perros, gatos, conejo, aves, peces, pequenos mamiferos y refugio multi-especie.

Las categorias cubiertas incluyen juegos, paseo, entrenamiento, cuidado, salud general, adopcion, ternura, consejos, alimentacion, higiene, descanso, rescates, profesionales, bloopers y social.

## Salud general

Los clips de salud son informativos y generales. No diagnostican, no indican tratamientos y refuerzan la consulta veterinaria cuando corresponde.

## Backend / seed futuro

El backend ya tiene modelos `User` y `Clip`, pero en esta fase no se agrega seed real ni migracion Prisma. Queda pendiente definir un seed backend separado, reversible y bloqueado para produccion si se decide productivizar contenido inicial.
