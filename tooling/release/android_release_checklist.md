# Android Release Checklist

Checklist concreta para cerrar la salida Android de Mascotify sin mezclarla con
mejoras futuras de producto.

## Estado del repo

Ya resuelto en repo:

- `namespace` y `applicationId` reales: `com.mascotify.app`
- `android:label` de app: `Mascotify`
- iconos de marca aplicados
- `key.properties` excluido de git
- plantilla local disponible en `key.properties.example`
- release signing solo se activa si el archivo y sus datos estan completos

Todavia pendiente:

- keystore real de release
- `key.properties` local real
- decision final de Play App Signing / upload key
- metadata final de Play Console

## Bloqueantes reales para publicar

1. Crear la keystore real de release
2. Guardarla fuera de git
3. Completar `key.properties` local con:
   - `storeFile`
   - `storePassword`
   - `keyAlias`
   - `keyPassword`
4. Verificar que el archivo apuntado por `storeFile` exista realmente
5. Definir Play App Signing:
   - subir con upload key propia
   - o seguir la estrategia final que uses en Play Console

## Pasos fuera del repo

1. Copiar `key.properties.example` como `key.properties`
2. Reemplazar placeholders por credenciales reales
3. Generar o ubicar la keystore final en la ruta que vas a declarar
4. Preparar la ficha de Play Console:
   - nombre final
   - descripcion corta
   - descripcion completa
   - categoria
   - clasificacion etaria
   - politica de privacidad
   - email o canal de soporte
   - screenshots
   - icono destacado si corresponde
5. Revisar cuenta de publicacion y acceso a Play Console

## Validaciones manuales recomendadas antes de subir

1. Confirmar que `key.properties` no quede versionado
2. Confirmar que la keystore no quede dentro de una ruta publica o temporal
3. Revisar que el icono final y el nombre de app sean los correctos
4. Revisar versionado final:
   - `versionName`
   - `versionCode`
5. Hacer una ultima pasada visual del launcher y del arranque en Android

## No bloquea publicacion, pero conviene revisar

- fuente maestra del isotipo en mayor resolucion para futuros exports
- textos finales de store mas pulidos
- politica de soporte/contacto mas completa
