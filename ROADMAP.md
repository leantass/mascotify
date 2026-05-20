# Mascotify - Roadmap del proyecto

## Estado general

Mascotify es una app Flutter web/mobile/desktop para mascotas, familias, tutores y profesionales del mundo pet.

El proyecto esta avanzado en modo demo/local, con varias funcionalidades implementadas y validaciones internas trabajadas. Todavia no esta listo para publicacion real con usuarios finales, pagos, Ads, Play Store, App Store o web publica productiva. Todo lo que siga mock/local/demo debe mantenerse marcado como tal hasta que exista backend publico, seguridad, moderacion, legal y validacion real.

## Leyenda de estados

- ✅ Hecho
- 🔄 En curso
- ⏳ Pendiente
- 🚫 Bloqueado / no hacer todavia
- 🧪 Requiere validacion
- 📦 Build interno / testers
- 🔐 Requiere cuidado de seguridad

## 1. Base tecnica

| Estado | Area | Detalle | Proximo control |
|---|---|---|---|
| ✅ | Flutter | Flutter app web/mobile/desktop avanzada. | Mantener compatibilidad en CI y pruebas locales. |
| ✅ | Navegacion | Navegacion principal implementada. | Revisar regresiones en mobile y desktop. |
| ✅ | Datos locales | Persistencia local para varias funciones. | No marcar como productivo hasta conectar backend real. |
| ✅ | CI | GitHub Actions funcionando. | Mantener CI verde antes de cada build estable. |
| ✅ | CI Flutter | CI con Flutter analyze, tests y build web. | No debilitar analyze ni tests. |
| ✅ | Backend | Backend Node/TypeScript existente. | Mantener build/test backend verdes. |
| ✅ | Backend | Backend Express + Prisma + PostgreSQL preparado. | Revisar migraciones antes de produccion. |
| ✅ | Backend | Healthchecks backend preparados. | Probar health publico cuando haya deploy. |
| ✅ | Railway | Railway documentado/preparado. | Crear proyecto y cargar variables reales sin exponer secretos. |
| ⏳ | Railway | Deploy publico Railway pendiente. | Deploy controlado con variables seguras. |
| ⏳ | Web | Web publica pendiente. | Requiere backend publico y definicion de hosting. |
| ⏳ | Android | Play Store pendiente. | Requiere AAB firmado, legal y testing interno. |
| ⏳ | iOS | iOS pendiente por requerir Mac/Xcode. | Evaluar cuando haya entorno Apple. |
| ⏳ | Windows | Windows nativo pendiente por requerir Visual Studio C++ tools. | Validar toolchain desktop cuando sea prioridad. |

## 2. Funcionalidades implementadas o trabajadas

### Acceso y cuentas

- ✅ Login visual/local.
- ✅ Registro visual/local.
- ✅ Demo familia.
- ✅ Demo profesional.
- ✅ Logout.
- ✅ Persistencia local de sesion.
- ⏳ Auth real pendiente.
- ⏳ Google auth real pendiente.

### Onboarding

- ✅ Onboarding familia.
- ✅ Onboarding profesional.

### Dashboard / Home

- ✅ Dashboard familia.
- ✅ Accesos rapidos.
- ✅ Navegacion a secciones principales.

### Mascotas

- ✅ Alta de mascota.
- ✅ Edicion de mascota.
- ✅ Eliminacion con confirmacion.
- ✅ Validaciones.
- ✅ Edad maxima hasta 20.
- ✅ Tipo de animal por selector.
- ✅ Razas/tipos dependientes.
- ✅ Ubicacion jerarquica.
- ✅ Perfil/detalle de mascota.
- ✅ Historial por mascota.
- ✅ QR/id persistente por mascota.
- 🧪 Revisar flujo QR demo/local.
- ⏳ QR real con backend publico pendiente.

### Mascotas perdidas

- ✅ Seccion dentro de Mascotas, no en sidebar.
- ✅ Catalogo solidario.
- ✅ Busqueda y filtros.
- ✅ Cards.
- ✅ Detalle.
- ✅ Contacto seguro.
- ✅ Reportes.
- ✅ Validacion anti-cobro.
- ✅ Dato privado de verificacion.
- ✅ Documentacion de seguridad.
- ⏳ Backend real de avistajes pendiente.
- ⏳ Moderacion real pendiente.
- ⏳ Reportes reales persistidos en backend pendiente.

### Actividad / Feed

- ✅ Feed general de actividad.
- ✅ Filtros.
- ✅ Busqueda.
- ✅ Eventos de mascotas, QR, mensajes, notificaciones y perfil.
- ✅ Tests.

### Explorar / Social

- ✅ Vista Explorar.
- ✅ Perfiles/ecosistema.
- ✅ Interes social.
- ✅ Clips dentro de Explorar.
- ✅ Visor tipo Reels/TikTok.
- ✅ Like/guardar/compartir visual.
- ✅ Comentarios con feedback seguro.
- ✅ Fallback local si backend no esta disponible.
- ⏳ Clips reales end-to-end con backend publico y Cloudinary pendiente.

### Mensajeria

- ✅ Inbox local persistente.
- ✅ Conversaciones.
- ✅ Envio de mensajes.
- ✅ Ultimo mensaje actualizado.
- ✅ Aislamiento por cuenta.
- ⏳ Mensajeria real backend pendiente.

### Notificaciones

- ✅ Notificaciones internas.
- ✅ Leidas/no leidas.
- ✅ Marcar una como leida.
- ✅ Marcar todas como leidas.
- ✅ Notificaciones navegables.
- ⏳ Push real con app cerrada pendiente.

### Perfil / Configuracion / Plan

- ✅ Perfil usuario.
- ✅ Preferencias persistentes.
- ✅ Visibilidad publica.
- ✅ Plan local/mock.
- ✅ Contactos / Soporte al cliente.
- ⏳ Soporte real conectado a backend pendiente.
- ⏳ Suscripciones reales pendientes.

### Profesional

- ✅ Dashboard profesional.
- ✅ Workspace/servicios.
- ✅ Activar presencia profesional.
- ✅ Perfil publico profesional.
- ⏳ Flujo profesional real productivo pendiente.

## 3. Backend y servicios externos

### Backend

- ✅ Backend Node/TypeScript.
- ✅ Express.
- ✅ Prisma.
- ✅ PostgreSQL preparado.
- ✅ Healthcheck `/health`.
- ✅ Healthcheck `/api/v1/health`.
- ✅ CORS configurable.
- ✅ Tests backend.
- ⏳ Revisar estado real de migraciones Prisma antes de produccion.
- ⏳ Deploy Railway pendiente.
- ⏳ Validar backend publico pendiente.

### Clips sociales

- ✅ Modelos Prisma de clips preparados.
- ✅ Endpoints de feed, detalle, creacion, edicion, borrado, likes, follows y shares.
- ✅ Auth temporal por `x-user-id`.
- ✅ Feed paginado.
- ✅ Estado de liked/following.
- ⏳ Auth real pendiente.
- ⏳ Moderacion real pendiente.

### Cloudinary

- ✅ Upload preparado.
- ✅ Firma segura desde backend.
- ✅ Flutter puede pedir firma y subir video.
- ⏳ Prueba real end-to-end pendiente.
- 🔐 No exponer API secret en Flutter.

### Railway

- ✅ `backend/railway.json`.
- ✅ Documentacion de deploy.
- ✅ Checklist de variables.
- ⏳ Crear proyecto Railway.
- ⏳ Conectar repo GitHub.
- ⏳ Crear PostgreSQL.
- ⏳ Cargar variables sin exponer secretos.
- ⏳ Deploy.
- ⏳ Probar health publico.

## 4. Monetizacion

Modelo definido actualmente:

- Free: US$ 0 mensual, hasta 1 mascota.
- Plus: US$ 1,99 mensual, hasta 5 mascotas.
- Pro: US$ 4,99 mensual, mascotas ilimitadas con politica de uso razonable.

Checklist:

- ✅ Modelo financiero documentado.
- ✅ Precios actualizados.
- ✅ UI/mock local de planes.
- 🚫 No hay pagos reales todavia.
- 🚫 No hay Play Billing.
- 🚫 No hay RevenueCat.
- 🚫 No hay Stripe real.
- 🚫 No hay Ads reales.
- ⏳ Implementar suscripciones reales.
- ⏳ Definir proveedor de pagos.
- ⏳ Implementar validacion backend de plan.
- ⏳ Implementar politica anti-abuso para Pro.

## 5. Publicidad / Ads

- 🚫 No activar Ads todavia.
- 🚫 No mostrar Ads en pantallas sensibles.
- ⏳ Definir estrategia Ads para Free.
- ⏳ Implementar Ads test.
- ⏳ Validar politicas de Play Store / App Store.

Pantallas donde NO debe haber Ads:

- Login.
- Registro.
- QR.
- Perfil de mascota.
- Reporte de mascota perdida.
- Reporte de avistaje.
- Mensajes.
- Pantallas de emergencia.
- Checkout/suscripcion.
- Mascotas perdidas.

## 6. QR y alertas al dueño

- ✅ QR/id persistente por mascota.
- ✅ QR no cambia al editar.
- ✅ QR no se duplica entre mascotas.
- ✅ Demo/local de trazabilidad trabajada.
- ✅ Concepto de QR fisico para collar/chapita definido.
- ✅ Flujo seguro sin mostrar datos privados del dueño.
- ✅ Google Maps con lat/lng usando URL simple sin API key.
- 🧪 Revisar flujo demo/local.
- ⏳ QR publico real pendiente.
- ⏳ Backend publico requerido.
- ⏳ URL publica requerida.
- ⏳ Evento QR backend -> dueño pendiente.
- ⏳ Push real con Firebase/FCM pendiente.
- 🔐 No mostrar direccion, telefono ni email privado del dueño.

## 7. Builds internas y testers

- ✅ APK debug interno generado anteriormente.
- ✅ ZIP web localhost generado anteriormente.
- ✅ Launcher web local con `INICIAR_MASCOTIFY.bat`.
- ✅ Validacion de localhost trabajada.
- 📦 Mantener carpeta de builds para testers.
- 📦 Mantener copia historica en archive.
- 🧪 Validar ZIP antes de enviar.
- 🧪 Validar APK antes de enviar.
- ⏳ Juntar feedback real de testers.
- ⏳ Clasificar feedback.

No mandar build estable si:

- GitHub Actions esta rojo.
- `flutter analyze` falla.
- `flutter test` falla.
- `flutter build web` falla.
- Backend build/test falla despues de tocar backend.
- APK/ZIP no fueron validados.
- Hay secretos en diff.
- APK/ZIP quedaron commiteados por error.

Se puede mandar build a testers si:

- Validacion local OK.
- GitHub Actions verde.
- APK generado.
- ZIP generado.
- ZIP probado con localhost 200.
- Working tree limpio.
- No se publico nada.
- No se activaron pagos ni Ads.

## 8. Legal, seguridad y publicacion

- ⏳ Politica de privacidad.
- ⏳ Terminos y condiciones.
- ⏳ Reglas de comunidad.
- ⏳ Data Safety Play Store.
- ⏳ Clasificacion de contenido.
- ⏳ Moderacion para contenido generado por usuarios.
- ⏳ Reportes/bloqueos reales.
- ⏳ AAB release firmado.
- ⏳ Testing interno Play Console.
- ⏳ Web publica.
- ⏳ Produccion Android.
- ⏳ Produccion iOS cuando haya Mac/Xcode.

## 9. Roadmap por fases

### Fase 0 - Estabilizacion interna

Estado: 🔄 En curso

Objetivos:

- Cerrar Contactos / Soporte en Configuracion.
- Validar GitHub Actions.
- Generar APK/ZIP estable para testers.
- Evitar nuevas features grandes hasta tener feedback.

Criterio de cierre:

- CI verde.
- APK/ZIP generados.
- Tester build validado.
- Working tree limpio.

### Fase 1 - Feedback de testers

Estado: ⏳ Pendiente

Objetivos:

- Enviar build interna.
- Recibir feedback.
- Clasificar problemas.
- Corregir bugs criticos.
- Mejorar responsive si aparece roto.
- Documentar hallazgos.

Criterio de cierre:

- Bugs criticos corregidos.
- App navegable en mobile.
- No hay pantallas principales rotas.

### Fase 2 - Backend publico y servicios reales

Estado: ⏳ Pendiente

Objetivos:

- Deploy Railway.
- PostgreSQL publico.
- Healthchecks publicos.
- Conectar Flutter con backend publico.
- Probar clips reales con Cloudinary.
- Probar QR real con URL publica.

Criterio de cierre:

- Backend publico funcionando.
- Flutter consume backend publico.
- Clip real sube y aparece en feed.
- QR real abre pagina publica segura.

### Fase 3 - Seguridad, moderacion y legal

Estado: ⏳ Pendiente

Objetivos:

- Politica de privacidad.
- Terminos.
- Reglas de comunidad.
- Moderacion de contenido.
- Reportes/bloqueos reales.
- Seguridad de datos privados.

Criterio de cierre:

- Flujo de reporte real.
- Contenido riesgoso reportable.
- Documentos legales minimos listos.

### Fase 4 - Monetizacion real

Estado: 🚫 No iniciar todavia

Objetivos:

- Definir proveedor de suscripciones.
- Implementar pagos reales.
- Validar entitlements backend.
- Implementar Ads de prueba para Free.
- Evitar Ads en pantallas sensibles.

Criterio de inicio:

- Backend publico estable.
- Legal minimo listo.
- Moderacion basica lista.
- App testeada internamente.

### Fase 5 - Publicacion

Estado: 🚫 No iniciar todavia

Objetivos:

- AAB firmado.
- Play Console.
- Testing interno.
- Data Safety.
- Ficha de tienda.
- Produccion Android.
- Web publica.
- iOS futuro.

Criterio de inicio:

- CI verde.
- Backend productivo.
- Legal listo.
- Moderacion lista.
- Build release firmada.
- Pruebas internas aprobadas.

## 10. Historial de hitos

| Fecha | Hito | Commit/PR | Estado | Observaciones |
|---|---|---|---|---|
| 2026-05 | Actualizacion de precios de planes y limites de mascotas. | `71b1295`, `4217f06` | ✅ | Hitos visibles en `git log`; modelo Free/Plus/Pro documentado y reflejado en UI/mock local. |
| 2026-05 | Mascotas perdidas dentro de Mascotas. | `f4b5839` | ✅ | La seccion se movio fuera del sidebar. |
| 2026-05 | Rediseño de Mascotas perdidas como catalogo seguro. | `6cd0ce4` | ✅ | Catalogo solidario, seguridad y validaciones trabajadas. |
| 2026-05 | QR publico / alertas al dueño. | `e3da7b2`, `221660e`, `2e8380c` | ✅/🧪 | Flujo demo/local y URL publica-aware trabajados; backend publico real sigue pendiente. |
| 2026-05 | Build web localhost endurecido. | `b5d0ad6` | ✅ | Launcher local endurecido para revisiones internas. |
| 2026-05 | Contactos / Soporte al cliente en Configuracion. | `154496f` | ✅ | Flujo local/demo agregado; soporte real backend pendiente. |

## 11. Pendientes criticos antes de produccion

- ⏳ Backend publico Railway.
- ⏳ PostgreSQL productivo.
- ⏳ Migraciones Prisma verificadas.
- ⏳ Cloudinary real probado.
- ⏳ QR publico real probado.
- ⏳ Push real si se necesita alerta con app cerrada.
- ⏳ Auth real.
- ⏳ Moderacion real.
- ⏳ Reportes/bloqueos reales.
- ⏳ Legal.
- ⏳ Suscripciones reales.
- ⏳ Ads test.
- ⏳ Play Store internal testing.
- ⏳ AAB firmado.

## 12. Cosas que NO se deben hacer todavia

- 🚫 No publicar en Play Store todavia.
- 🚫 No activar Ads reales todavia.
- 🚫 No activar pagos reales todavia.
- 🚫 No exponer secretos.
- 🚫 No subir APK debug a Play Store.
- 🚫 No commitear `.env`.
- 🚫 No commitear `key.properties`.
- 🚫 No commitear `.jks`, `.keystore` ni credenciales.
- 🚫 No prometer QR real entre dispositivos sin backend publico.
- 🚫 No prometer push real con app cerrada sin Firebase/FCM/APNs.
- 🚫 No mandar build estable si CI esta rojo.

## 13. Como mantener este roadmap

- Cada feature importante debe actualizar este archivo.
- Cada build interna debe registrar fecha, estado y validacion.
- Cada fase cerrada debe marcarse como ✅.
- Si GitHub Actions falla, no marcar como estable.
- Si algo esta mock/local/demo, no marcar como productivo.
- Antes de publicar, revisar la seccion de pendientes criticos.
