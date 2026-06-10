# Online Clips Feed Strategy

## Objetivo
Preparar Clips para mostrar contenido fresco de mascotas todos los dias cuando Mascotify este publicada, sin depender de uploads iniciales de usuarios y sin presentar videos demo como experiencia principal.

La app Flutter debe consumir un feed online curado desde el backend de Mascotify. Los clips locales quedan como fallback offline o demo.

## Politica de contenido
Mascotify no debe scrapear TikTok, Instagram, YouTube ni otras redes. Tampoco debe descargar, rehostear ni ocultar contenido de terceros sin permiso.

Fuentes permitidas:
- uploads reales de usuarios de Mascotify
- videos curados con autorizacion explicita
- bancos con licencia/API permitida, por ejemplo Pexels o Pixabay, integrados desde backend
- sponsors o creadores con acuerdo
- clips locales demo solo como fallback

Cada clip externo debe conservar fuente, licencia y atribucion cuando aplique.

## Tipos de contenido
- `userUpload`: contenido subido por usuarios reales de Mascotify.
- `curatedOnline`: contenido curado con permiso o acuerdo.
- `licensedStock`: contenido de proveedores autorizados como Pexels/Pixabay.
- `seededDemo`: contenido local incluido para demo/fallback.
- `sponsor`: contenido de marcas o creadores con acuerdo comercial.

Los clips externos no deben mostrarse como si fueran usuarios reales de Mascotify. La UI debe mostrar proveedor o etiqueta de origen: `Fuente: Pexels`, `Contenido curado`, `Mascotify recomendado`, etc.

## Daily Refresh
El refresh diario debe vivir en backend:
1. Un job diario consulta fuentes autorizadas.
2. El backend usa API keys guardadas en servidor, nunca en Flutter.
3. Se buscan videos con queries como `dog bloopers`, `funny dogs`, `pets funny`, `cats funny`, `dog training`, `pet care`, `adoption pets`.
4. Se filtra por duracion corta, calidad, formato vertical si existe, licencia valida, seguridad y moderacion.
5. Se guarda metadata, fuente, licencia, attribution y estado.
6. Se publica solo contenido aprobado o permitido por reglas.

Estados sugeridos:
- `detected`
- `approved`
- `rejected`
- `published`
- `expired`

## Moderacion
Antes de publicar en produccion, el backend debe filtrar:
- contenido ofensivo o sensible
- personas identificables cuando no convenga
- marcas o musica con derechos no autorizados
- videos sin licencia clara
- duplicados o contenido expirado

## Offline y Fallback
Si no hay conexion, no hay backend o el feed online falla:
- mostrar loader de huella mientras se intenta cargar
- informar de forma sutil: `Sin conexion. Te mostramos clips guardados.`
- usar clips locales como fallback

El fallback local no debe ser la experiencia principal en produccion cuando `onlineClipsEnabled` y `onlineClipsUseBackend` esten activos.

## Riesgos
- Copyright por rehostear contenido sin permiso.
- Falta de atribucion requerida por proveedor.
- API keys expuestas si se consulta Pexels/Pixabay desde Flutter.
- Confusion de usuarios si contenido externo se presenta como contenido de usuarios reales.

Mitigacion: backend propio, contrato de metadata, atribucion visible, moderacion y feature flags.

## Roadmap
- Activar endpoint online real.
- Integrar proveedor autorizado en backend.
- Crear job diario.
- Agregar cache y expiracion.
- Definir reglas legales de atribucion por proveedor.
- Incorporar uploads reales de usuarios.
- Sumar panel de curaduria/moderacion.
