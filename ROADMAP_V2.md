\# Mascotify Roadmap V2



\## Estado de partida



La fase 1 quedó cerrada con una base mock sólida y coherente del producto.



Actualmente Mascotify ya cuenta con:



\- Home hub del ecosistema

\- Cuentas, roles y onboarding mock

\- Matching más expresivo

\- QR y trazabilidad mock

\- Mensajería mock más sólida

\- Vertical profesional más fuerte

\- Activity feed y notificaciones

\- Base estructural preparada para backend futuro

\- QA integral de cierre de fase 1



Esto significa que el producto ya no está en etapa de concepto visual aislado.

Ahora existe una base clara para pasar a una fase 2 más realista y persistente.



\---



\## Objetivo de la fase 2



Llevar Mascotify desde un ecosistema mock bien armado hacia un producto con más comportamiento real, persistencia y preparación concreta para operación futura.



La fase 2 no busca rehacer lo construido.

Busca consolidarlo y empezar a volver reales las capas más importantes.



\---



\## Prioridades de fase 2



\### 2.1 Auth real y sesión



Objetivo:

Construir una autenticación real y persistente sobre la base de cuentas y roles ya definida.



Alcance esperado:

\- registro real

\- login real

\- sesión persistida

\- logout

\- elección y recuperación del perfil activo

\- continuidad entre familia y profesional si aplica



Notas:

No debería romper la estructura de cuenta base + perfil por tipo de uso que ya se definió en fase 1.



\---



\### 2.2 Persistencia base



Objetivo:

Persistir la base mínima del producto para dejar de depender de mocks estáticos.



Alcance esperado:

\- cuenta

\- perfil activo

\- mascotas

\- preferencias esenciales

\- estado general del usuario

\- base mínima para QR, matching y social



Notas:

La idea no es persistir todo al mismo tiempo, sino armar primero una columna vertebral confiable.



\---



\### 2.3 Vertical profesional más real



Objetivo:

Empezar a transformar la vertical profesional en una capa de servicios y presencia real.



Alcance esperado:

\- categorías reales

\- ficha profesional más operativa

\- servicios ofrecidos

\- CTAs más concretos

\- posibilidad de contacto o consulta futura

\- mejor lectura entre contenido, confianza y servicio



Notas:

Todavía no implica agenda completa ni marketplace final, pero sí una base mucho más creíble.



\---



\### 2.4 Mensajería persistente



Objetivo:

Dejar atrás la mensajería puramente mock y pasar a una capa persistida.



Alcance esperado:

\- threads guardados

\- mensajes persistidos

\- estados básicos

\- derivación desde intereses

\- continuidad entre bandeja social y conversación



Notas:

La mensajería ya está conceptualmente fuerte.

Ahora toca hacerla durable.



\---



\### 2.5 QR y trazabilidad más real



Objetivo:

Convertir la capa QR en una funcionalidad con historial y eventos persistidos.



Alcance esperado:

\- eventos QR persistidos

\- historial real

\- reportes asociados

\- timeline de actividad

\- contacto protegido con mejor base operativa



Notas:

No implica geolocalización real compleja en la primera iteración, pero sí consistencia de eventos.



\---



\### 2.6 Matching más inteligente



Objetivo:

Profundizar la lógica de matching a partir de datos reales y señales más ricas.



Alcance esperado:

\- filtros más útiles

\- criterios mejor estructurados

\- señales personalizadas

\- explicaciones de afinidad más finas

\- mejor lectura entre contexto, ritmo y compatibilidad



Notas:

No hace falta un algoritmo sofisticado en la primera iteración, pero sí una capa más real y menos fija.



\---



\## Orden recomendado de ejecución



\### Etapa A

Auth real y sesión



\### Etapa B

Persistencia base



\### Etapa C

Mensajería persistente + base social persistida



\### Etapa D

QR con eventos persistidos



\### Etapa E

Vertical profesional más operativa



\### Etapa F

Matching más inteligente



\---



\## Criterios para fase 2



\### Producto

\- no perder claridad

\- no romper el tono del ecosistema

\- mantener foco en utilidad real

\- no meter complejidad visible innecesaria



\### UX

\- seguir siendo premium

\- seguir siendo cálida

\- no convertirse en panel administrativo

\- priorizar acciones con sentido



\### Técnico

\- seguir evitando sobreingeniería

\- consolidar la base antes de abrir demasiados frentes

\- desacoplar donde aporte valor real

\- preparar persistencia sin reventar lo ya hecho



\---



\## Regla de trabajo de fase 2



\- una etapa importante por vez

\- no mezclar backend real con cinco features grandes juntas

\- cerrar una base antes de abrir otra

\- mantener validaciones frecuentes

\- seguir usando roadmap + issues + project para no perder foco

