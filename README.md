# Mascotify

Mascotify es una experiencia Flutter multiplataforma orientada a identidad,
matching, mensajeria, QR y vertical profesional para mascotas.

## Estado actual

- Base local real para auth, cuenta, perfil y mascotas
- Separacion entre cuentas demo y cuentas reales
- Mensajeria persistente por cuenta
- QR persistente y trazabilidad por mascota
- Vertical profesional persistente
- Matching persistente por cuenta y por mascota
- Espejo usable en browser/web

## Entrega

El proyecto mantiene una sola base de producto entre mobile y browser.
La preparacion final de release requiere completar identificadores, firma,
assets de marca y metadatos definitivos por plataforma.

## Backend base

La base inicial del backend real esta en:

```text
backend/README.md
```

Por ahora expone healthchecks y no esta conectada a la app Flutter.

## Demo web local

La guia de entrega/demo esta en:

```text
docs/demo/demo_readme.md
```

Roadmap ejecutivo:

```text
docs/demo/mascotify_roadmap_ejecutivo.md
```

Comandos principales desde la raiz del proyecto:

```bat
C:\src\flutter\bin\flutter.bat run -d chrome
tooling\git_flow\check_local.bat
tooling\demo\build_web_demo.bat
tooling\demo\serve_web_demo.bat
tooling\demo\package_web_demo.bat
```

El build web queda en `build\web` y el paquete entregable se genera en
`dist\demo\mascotify-demo-web.zip`.
