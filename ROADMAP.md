# Mascotify Roadmap

## Vision del producto
Mascotify busca ser una plataforma donde la identidad digital de cada mascota conviva con:
- seguridad y rastreo mediante QR
- descubrimiento social y matching responsable
- comunicacion entre familias
- contenido experto y comunidad profesional

La idea no es construir una app suelta de fichas ni una red social vacia.
La idea es construir un ecosistema real, claro, premium y util.

---

## Estado actual del producto

### 1. Base general
- App Flutter funcionando
- Navegacion principal estructurada
- Tema visual consistente
- Home convertida en hub del ecosistema

### 2. Identidad de mascota
- Ficha interna de mascota
- Datos de identidad
- Salud / vacunas local-demo
- documentacion
- acciones rapidas

### 2.1 Mascotas / Salud
- ✅ Card Salud mejorada.
- ✅ Card Salud con acceso visible a Salud y vacunas.
- ✅ Libreta sanitaria local/demo.
- ✅ Vacunas aplicadas.
- ✅ Vacunas pendientes.
- ✅ Proxima dosis/refuerzo.
- ✅ Alta, edicion, eliminacion y marcado como aplicada.
- ✅ Historial sanitario integrado con actividad/historial de mascota.
- ✅ Persistencia local aislada por cuenta y mascota.
- ✅ Tests automaticos.
- ✅ Fix para eliminar copy viejo de datos demo.
- ✅ Vacunas sugeridas por especie.
- ✅ Catálogo local de plantillas por tipo de animal.
- ✅ Prevención de sugerencias cruzadas entre especies.
- ✅ Avisos de responsabilidad veterinaria.
- ⏳ Validación veterinaria profesional del catálogo antes de producción.
- ⏳ Configuración regional futura por país/provincia.
- ✅ Motor de calendario orientativo por especie, edad e historial.
- ✅ Recordatorios internos de vacunas.
- ✅ Avisos visibles en Salud.
- ✅ Estado de vacunas próximas, pendientes, vencidas o para revisar.
- ✅ Advertencias por historial incompleto.
- ✅ Advertencias senior.
- ✅ Base local versionada de conocimiento sanitario.
- ✅ Documentación de actualización online futura.
- ⏳ Backend real de conocimiento sanitario pendiente.
- ⏳ Panel admin/veterinario pendiente.
- ⏳ Sincronización online de catálogo pendiente.
- ⏳ Push real con Firebase/FCM/APNs pendiente.
- ⏳ Validación veterinaria profesional antes de producción.
- ⏳ Backend real de salud/vacunas pendiente.
- ⏳ Adjuntos/comprobantes reales pendientes.
- ⏳ Sincronizacion multi-dispositivo pendiente.
- 🔐 No reemplaza indicacion veterinaria.

### 3. QR y rastreo
- Bloque QR dentro de la ficha
- Vista publica mock de escaneo
- Flujo mock de reporte de avistamiento
- Representacion visual de ubicacion aproximada
- Confirmacion de reporte mas cercana al producto real

### 4. Capa social / matching
- Explore como modulo social real
- Perfil publico de mascota
- Expresar interes
- Guardar perfil
- Compartir perfil
- Preferencias de matching dentro de la ficha interna

### 5. Bandeja social y conversaciones
- Bandeja social mock
- Inbox de mensajeria mock
- Conversacion mock entre familias
- Accesos entre interes, bandeja y mensajes

### 6. Profesionales y contenido
- Pantalla de profesionales
- Perfil publico profesional
- Pantalla de detalle de contenido profesional
- Acciones mock de seguir / guardar / compartir
- Contenido recomendado

### 6.1 Monetizacion / Ads
- ✅ Arquitectura base de placements publicitarios.
- ✅ Ad slots placeholder.
- ✅ Separacion por plan Free/Plus/Pro.
- ✅ Pantallas sensibles excluidas.
- ✅ Salud/Vacunas excluida por criterio sanitario.
- ✅ Rewarded ads preparados en modo demo.
- ✅ Sponsors directos preparados como placeholders identificados.
- ✅ Documentacion AdMob/AdSense/Google Ads.
- ⏳ Integracion real AdMob pendiente.
- ⏳ Cuenta AdMob pendiente.
- ⏳ App IDs y Ad Unit IDs pendientes.
- ⏳ app-ads.txt pendiente.
- ⏳ Politica de privacidad/Data Safety pendiente.
- ⏳ UMP/consentimiento pendiente.
- ⏳ Ads reales pendientes de Play Store y revision.
- ⏳ AdSense web pendiente cuando haya web publica.

### 7. Estructura interna preparada a futuro
- Separacion de modelos y mocks
- Datos de social, profesionales y reportes mas ordenados
- Menor acoplamiento de datos con pantallas
- Base mas preparada para persistencia real futura

---

## Proximos bloques recomendados

### Bloque A. Activity feed / notificaciones
Objetivo:
Crear una capa transversal del ecosistema para mostrar actividad reciente:
- intereses recibidos
- mensajes nuevos
- reportes QR
- contenido nuevo
- recordatorios utiles

### Bloque B. Limpieza de copy y tono
Objetivo:
Hacer una pasada integral sobre textos visibles:
- acentos
- tono
- consistencia
- evitar ASCII duro en la version final visible si no hace falta

### Bloque C. Preparacion para backend real
Objetivo:
Definir mejor las entidades y futuras relaciones:
- users
- pets
- public profiles
- interests
- message threads
- reports
- professionals
- saved profiles
- notifications

### Bloque D. Persistencia futura
Objetivo:
Preparar el proyecto para pasar de mock a real sin romper UX:
- repositorios
- capa de datos
- contratos
- estados
- providers o solucion elegida a futuro

### Bloque D.1 Salud / vacunas local-demo
Estado: ✅ Hecho

Objetivo cerrado:
- Card Salud mejorada.
- Libreta sanitaria simple de vacunas.
- Persistencia local por cuenta y mascota.
- Historial sanitario dentro del historial/actividad de mascota.
- Tests automaticos y CI verde.

Pendiente para fase real:
- Backend de salud/vacunas.
- Adjuntos/comprobantes reales.
- Sincronizacion multi-dispositivo.

### Bloque E. Matching mas profundo
Objetivo:
Mejorar la logica y expresividad del matching:
- filtros mas utiles
- estados de compatibilidad
- contexto ideal
- limites
- afinidades sugeridas

### Bloque F. Mensajeria mas solida
Objetivo:
Evolucionar la mensajeria mock a una base mas realista:
- lista de conversaciones mas rica
- estados de mensaje
- respuestas sugeridas
- derivacion desde intereses
- preparacion para persistencia futura

### Bloque G. QR con mas valor
Objetivo:
Profundizar el diferencial del producto:
- historial de escaneos
- timeline de reportes
- estados del QR
- contacto protegido
- mejor simulacion de trazabilidad

### Bloque H. Profesionales como vertical fuerte
Objetivo:
Volver mas potente la comunidad experta:
- seguimiento de profesionales
- contenidos guardados
- recomendaciones personalizadas
- cruces entre contenido y matching

---

## Criterios del producto

### UX
- premium
- clara
- calida
- no administrativa
- no vacia
- no tecnica fria

### Producto
- identidad digital real
- social con sentido
- matching responsable
- seguridad y rastreo utiles
- contenido experto que aporte valor

### Tecnico
- no romper arquitectura por apuro
- evitar duplicacion de logica
- separar mejor datos y pantallas
- preparar el terreno para backend real

---

## Historial de hitos

| Fecha | Hito | Commit/PR | Estado | Observaciones |
| --- | --- | --- | --- | --- |
| 2026-05-22 | Base de monetizacion con espacios publicitarios seguros | feature/monetization-ad-slots-foundation | ✅ Hecho | Se agregaron placements, placeholders, entitlements por plan, exclusion de pantallas sensibles y documentacion para futura integracion AdMob. |
| 2026-05-20 | Motor de calendario sanitario y recordatorios de vacunas | feature/pet-health-reminders-knowledge-base | ✅ Hecho | Se agregó guía local/demo por especie, edad e historial, con recordatorios internos y arquitectura futura de actualización validada. |
| 2026-05-20 | Vacunas sugeridas por especie | feature/species-vaccine-suggestions | ✅ Hecho | Se agregaron plantillas locales orientativas filtradas por especie, sin convertirlas en indicación médica obligatoria. |
| 2026-05-20 | Salud y vacunas visible en detalle de mascota | 13af729 + 88d73f8 | ✅ Hecho | Se agrego libreta sanitaria local/demo y se corrigio copy legacy en MockData para evitar que el usuario vea la card vieja en builds nuevos. |
| 2026-05-20 | Libreta sanitaria simple de vacunas | 13af729 | ✅ Hecho | Implementacion local/demo con persistencia por cuenta/mascota, historial, tests y CI verde. |

---

## Regla de trabajo
- una mejora por vez
- no abrir cinco frentes nuevos juntos
- priorizar consistencia sobre cantidad
- probar por bloques cuando haya suficiente acumulado
