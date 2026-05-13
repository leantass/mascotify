# Mascotify - iOS release checklist

## Requisitos

- [ ] Mac con Xcode compatible.
- [ ] Flutter iOS toolchain operativo.
- [ ] Apple Developer Program activo.
- [ ] App Store Connect configurado.
- [ ] Certificados y provisioning profiles.
- [ ] Dispositivo iOS o simuladores para QA.

## Proyecto

- [ ] Confirmar bundle id: `com.mascotify.app`.
- [ ] Confirmar display name: `Mascotify`.
- [ ] Confirmar deployment target iOS: `13.0`.
- [ ] Confirmar iconos finales.
- [ ] Confirmar launch screen.
- [ ] Revisar version y build number.

## Build y distribucion

- [ ] Ejecutar `flutter analyze` y `flutter test` antes de abrir Xcode.
- [ ] Compilar iOS en Mac.
- [ ] Firmar con cuenta Apple.
- [ ] Probar en simulador.
- [ ] Probar en dispositivo real.
- [ ] Crear archive.
- [ ] Subir a TestFlight.
- [ ] Validar beta interna.
- [ ] Completar ficha App Store.
- [ ] Enviar a revision solo cuando TestFlight este validado.

## No hacer desde Windows

- [ ] No intentar compilar iOS.
- [ ] No simular signing iOS.
- [ ] No commitear certificados ni provisioning profiles.

