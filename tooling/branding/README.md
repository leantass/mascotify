# Branding Mobile/Web

Esta carpeta deja preparada la base para reemplazar el branding visual default
de Flutter sin inventar assets finales que todavia no existen en el repo.

## Que falta para cerrar este frente

Todavia hace falta un asset maestro real de marca:

- un PNG cuadrado
- idealmente de `1024x1024` o mas
- fondo transparente si la marca lo necesita
- composicion centrada y pensada para app icon

Sugerencia de ubicacion:

- `tooling/branding/source/mascotify-app-icon.png`

## Que resuelve el script

El script `generate_brand_assets.ps1` genera y reemplaza:

- Android launcher icons:
  - `android/app/src/main/res/mipmap-*/ic_launcher.png`
- iOS AppIcon set:
  - `ios/Runner/Assets.xcassets/AppIcon.appiconset/*.png`
- Web icons:
  - `web/favicon.png`
  - `web/icons/Icon-192.png`
  - `web/icons/Icon-512.png`
  - `web/icons/Icon-maskable-192.png`
  - `web/icons/Icon-maskable-512.png`

## Uso

Ejemplo:

```powershell
powershell -ExecutionPolicy Bypass -File tooling/branding/generate_brand_assets.ps1 `
  -SourcePng tooling/branding/source/mascotify-app-icon.png
```

## Pendientes que siguen siendo manuales

- validar visualmente el icono final en launcher, home screen y browser
- reemplazar los maskable icons si la marca necesita una composicion dedicada
- revisar screenshots/listings de stores cuando exista el asset definitivo

## Nota

En esta fase no se agrego ningun asset binario nuevo porque el repo todavia no
trae material final de marca. La base queda lista para aplicar ese material en
cuanto este disponible.
