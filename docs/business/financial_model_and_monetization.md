# Mascotify - Modelo financiero y monetizacion

## Objetivo

Definir un modelo freemium simple para Mascotify antes de implementar pagos, publicidad o integraciones con tiendas. Este documento es una base de negocio y producto; no representa ingresos garantizados ni pagos reales ya implementados.

## Planes

| Capacidad | Free | Plus US$ 1,99 | Pro US$ 4,99 |
| --- | --- | --- | --- |
| Precio mensual | US$ 0 | US$ 1,99 | US$ 4,99 |
| Cantidad de mascotas | 1 | Hasta 5 | Ilimitadas, con politica de uso razonable |
| Perfil de mascota | Si | Si | Si |
| QR y trazabilidad | Basico | Completo familiar | Completo profesional |
| Clips y comunidad | Demo/local y feed disponible | Feed y acciones sociales | Feed, visibilidad y herramientas profesionales |
| Mensajeria | Basica | Familiar completa | Profesional completa |
| Publicidad | Puede mostrar publicidad | Sin publicidad o minima/no invasiva | Sin publicidad o minima/no invasiva |
| Perfil profesional | No | No | Si |

## Posicionamiento

- **Free**: entrada gratuita util, limitada a 1 mascota. Permite probar el valor central sin friccion.
- **Plus**: plan familiar accesible por US$ 1,99 mensual, con hasta 5 mascotas.
- **Pro**: plan profesional por US$ 4,99 mensual, con mascotas ilimitadas como mensaje comercial, mas visibilidad y herramientas profesionales.

Para Pro, "mascotas ilimitadas" debe comunicarse comercialmente. A nivel tecnico y operativo existe una politica interna de uso razonable y anti-abuso para prevenir spam, automatizacion, fraude, uso excesivo o costos descontrolados.

## Entitlements iniciales

```yaml
free:
  priceMonthlyUsd: 0
  maxPets: 1
  ads: enabled
  professionalProfile: false

plus:
  priceMonthlyUsd: 1.99
  maxPets: 5
  ads: none_or_minimal
  professionalProfile: false

pro:
  priceMonthlyUsd: 4.99
  maxPets: unlimited
  fairUsePolicy: true
  antiAbusePolicy: true
  ads: none_or_minimal
  professionalProfile: true
```

## Monetizacion

Mascotify combina:

- Suscripciones mensuales: Plus y Pro.
- Publicidad principalmente en Free, con experiencia no invasiva.
- Futuras oportunidades B2B para profesionales, clinicas, refugios o servicios relacionados.

No implementar publicidad real, Play Billing, RevenueCat, AdMob, AdSense ni webhooks de pagos hasta tener definicion legal, fiscal y de proveedor.

## Formula principal

```text
MRR suscripciones = usuarios Plus x 1,99 + usuarios Pro x 4,99
```

```text
MRR bruto total = MRR suscripciones + ingresos estimados por Ads
```

Los ingresos por Ads son estimaciones de escenario, no garantias.

## Escenarios financieros

### Escenario conservador

| Concepto | Valor |
| --- | ---: |
| Usuarios Plus | 175 |
| Usuarios Pro | 75 |
| MRR Plus | US$ 348,25 |
| MRR Pro | US$ 374,25 |
| Ingresos por suscripciones | US$ 722,50 |
| Ads estimado | US$ 140 |
| MRR bruto total | US$ 862,50 |

### Escenario medio

| Concepto | Valor |
| --- | ---: |
| Usuarios Plus | 1.300 |
| Usuarios Pro | 700 |
| MRR Plus | US$ 2.587 |
| MRR Pro | US$ 3.493 |
| Ingresos por suscripciones | US$ 6.080 |
| Ads estimado | US$ 1.370 |
| MRR bruto total | US$ 7.450 |

### Escenario fuerte

| Concepto | Valor |
| --- | ---: |
| Usuarios Plus | 5.400 |
| Usuarios Pro | 3.600 |
| MRR Plus | US$ 10.746 |
| MRR Pro | US$ 17.964 |
| Ingresos por suscripciones | US$ 28.710 |
| Ads estimado | US$ 6.850 |
| MRR bruto total | US$ 35.560 |

## Reglas de implementacion futura

- Free no debe superar 1 mascota activa.
- Plus no debe superar 5 mascotas activas.
- Pro se muestra como mascotas ilimitadas, pero debe tener controles internos de uso razonable.
- Ads aplican principalmente a Free.
- Plus y Pro deben priorizar una experiencia sin publicidad o con publicidad minima/no invasiva.
- Cualquier integracion de pagos debe contemplar proveedor, impuestos, moneda, cancelaciones, reintentos, webhooks, conciliacion y auditoria.

## Pendientes antes de monetizacion real

- Elegir proveedor de pagos.
- Definir moneda final por pais.
- Definir politicas legales y fiscales.
- Implementar estados de suscripcion.
- Implementar webhooks.
- Implementar control tecnico de entitlements.
- Definir politicas de publicidad y privacidad.
