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
- salud
- documentacion
- acciones rapidas

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

## Regla de trabajo
- una mejora por vez
- no abrir cinco frentes nuevos juntos
- priorizar consistencia sobre cantidad
- probar por bloques cuando haya suficiente acumulado