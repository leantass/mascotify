# Demo Content Strategy

## Objetivo

Mascotify usa una comunidad demo/seeded para que Explorar y Clips no arranquen vacios en modo local, tester o demo. El objetivo es mostrar usos reales del producto: QR, paseos, salud general, convivencia, adopcion, higiene y cuidado de especies menos comunes.

La estrategia no busca fingir usuarios reales. Busca mostrar contenido inicial claro, util y seguro.

## Marcado interno

- Cuentas: `isDemoAccount: true`, `source: seeded_demo`, `seededAt`.
- Clips: `isDemoContent: true`, `isStarterContent: true`, `availableForAllUsers: true`, `source: seeded_demo`, `sourceLabel: Comunidad inicial`.
- Mascotas demo: `source: seeded_demo` y asociacion por `ownerDemoAccountId`.

En UI pueden presentarse como comunidad inicial, contenido destacado, creadores recomendados, historias Mascotify o perfiles de ejemplo en modo demo.

## Criterio de realismo

Cada cuenta tiene nombre natural, username creible, bio humana, ubicacion general, tipo de cuenta, metricas moderadas y tono propio. Cada cuenta tiene una o mas mascotas asociadas, o un rol demo claro con mascotas ficticias en sus clips.

Las mascotas demo incluyen especie, tipo/raza, edad o etapa, personalidad, rutina, notas de cuidado y notas sanitarias generales. No incluyen diagnosticos delicados ni tratamientos.

Los clips tienen captions escritos como personas, con longitudes variadas y utilidad concreta para tutores nuevos.

## Diferencias

- Demo: contenido local para pruebas y demos.
- Seeded: contenido inicial cargado de forma controlada y marcado internamente.
- Contenido oficial/curado: contenido revisado para produccion, con permisos y politica editorial.
- Usuarios reales: cuentas creadas por personas o negocios reales con contenido propio.

## Reglas eticas

No se usan identidades reales, fotos de terceros, ubicaciones exactas, telefonos, mails ni matriculas. No se inventan profesionales reales ni verificaciones reales. Tips Mascotify se presenta como contenido educativo general, no como veterinario real.

## Videos oficiales Mascotify

Clips arranca con videos oficiales propios de Mascotify como starter content. Son MP4 verticales generados localmente para el producto, sin videos de internet, sin personas reales, sin logos de terceros y sin contenido con copyright externo.

Estos videos explican funciones reales: QR seguro, salud y vacunas, mascotas perdidas, comunidad pet, clips de usuarios, perfil de mascota, recordatorios, profesionales, adopcion responsable y privacidad. Se muestran como `Mascotify oficial` / `Contenido oficial`, no como uploads de usuarios reales.

Los bloopers reales y clips reales de mascotas quedan para uploads futuros de usuarios, con backend, Cloudinary o proveedor equivalente, permisos, moderacion y trazabilidad. No se importan desde internet sin permiso.

Los clips de comunidad demo siguen existiendo como contenido secundario para variedad local y pruebas. Los videos oficiales pueden reemplazarse por campanas reales futuras, siempre con material propio o autorizado.

## Assets y licencias

No se descargan videos de internet. No se commitean videos pesados. Los clips demo usan videos locales generados para Mascotify dentro de `assets/videos/clips/`, marcados como contenido demo/seeded y sin personas, identidades reales ni material de terceros.

Los videos actuales son assets MP4 livianos reutilizados por especie o categoria. Cada clip declara `videoSourceType: asset`, `videoAssetPath`, `durationSeconds` y mantiene `demoVideoKey` para reemplazo futuro por assets propios o licenciados. Los clips starter son globales para cualquier usuario logueado y no dependen de una cuenta real, upload real ni backend productivo.

Si un asset no carga, el viewer muestra un fallback visual seguro y no deja una pantalla negra. El visor principal usa scroll vertical estilo TikTok/Reels, reproduce muted el clip visible de forma automatica y pausa clips fuera de pantalla.

Para agregar nuevos videos demo:

1. Crear o incorporar solo material propio/licenciado.
2. Mantener cada archivo preferentemente por debajo de 1 MB.
3. Guardarlo en `assets/videos/clips/`.
4. Declararlo mediante `videoAssetPath` o la regla de asignacion en `ClipsMockData`.
5. Mantener `isDemoContent: true` y `source: seeded_demo` mientras no sea contenido real de usuarios.
6. Mantener `isStarterContent: true` y `availableForAllUsers: true` si el clip forma parte del feed inicial global.

Para produccion, estos assets deben reemplazarse por videos reales con permiso explicito, contenido oficial curado o uploads reales con backend y moderacion.

## Como desactivar contenido demo

El contenido demo entra por `ClipsMockData.clips`, `AppData.exploreClips` y el fallback de `SocialClipsRepository`.

Para desactivarlo:

1. Cambiar el proveedor de fallback de `SocialClipsRepository`.
2. Evitar que `AppData.exploreClips` use `ClipsMockData.clips`.
3. Mantener el estado vacio de Clips cuando no haya clips reales.
4. Ocultar o migrar cuentas con `source: seeded_demo`.

## Migracion a produccion

Antes de produccion, decidir si este contenido se elimina, se convierte en contenido oficial Mascotify, se reemplaza por creadores con permisos firmados o se migra a un seed backend bloqueado para ambientes no productivos.

No ejecutar seed demo contra produccion sin revision manual de producto, legal, salud y datos.

## Cuentas demo incluidas

Hay 15 cuentas ficticias:

1. Camila y Milo (`cami_milo`)
2. Nico y Lola (`nico_lola_gatuna`)
3. Sofi Patitas (`sofi_patitas`)
4. Bruno Senior (`bruno_senior`)
5. Conejo Nube (`conejo_nube`)
6. Mini Mundo Pet (`mini_mundo_pet`)
7. Plumas en Casa (`plumas_en_casa`)
8. Aqua Mascotify (`aqua_mascotify`)
9. Tortu Diario (`tortu_diario`)
10. Huellitas Urbanas (`huellitas_urbanas`)
11. Rocky Aprende (`rocky_aprende`)
12. Refugio Patitas Demo (`refugio_patitas_demo`)
13. Tips Mascotify (`vet_tips_mascotify`)
14. Pelu Pet Demo (`pelu_pet_demo`)
15. Aventuras de Nina (`aventuras_nina`)

## Clips y categorias

Hay 45 clips demo utiles, con 2 a 4 clips por cuenta. Cubren perros, gatos, conejo, ave, pez, cobayo, hamster, tortuga/reptil y refugio multi-especie. Todos tienen una fuente reproducible local o fallback visual seguro.

Categorias cubiertas: juego, paseo, salud general, vacunas, QR, adopcion, higiene, entrenamiento, enriquecimiento, convivencia, alimentacion, descanso, pequenos animales, acuario, aves, reptiles, prevencion, rescates, profesionales, bloopers y social.

## Seguridad sanitaria y comunitaria

Los clips de salud y vacunas son generales. No diagnostican, no indican tratamientos, no ordenan medicar y refuerzan la consulta veterinaria o especializada. Los clips de adopcion evitan urgencias manipuladoras y enfatizan responsabilidad, tiempo, espacio y seguimiento.

## Backend / seed futuro

El backend tiene modelos `User` y `Clip`, pero esta fase no agrega seed real ni migracion Prisma. Queda pendiente definir un seed backend separado, reversible, auditable y bloqueado para produccion si se productiviza.
