# Backend-ready architecture

## Estado actual local

Mascotify funciona hoy como una app local/web-desktop con datos persistidos por cuenta en el dispositivo. La UI consume `AppData` como fachada central. Esa fachada delega en un `MascotifyDataSource`, cuya implementacion activa en la app es `PersistentLocalMascotifyDataSource`.

El fallback `MockMascotifyDataSource` sigue disponible para previews, datos iniciales y casos aislados, pero el bootstrap real en `main.dart` conecta `PersistentLocalMascotifyDataSource` con `SharedPreferences` y `AuthSessionController`.

## Flujo de datos actual

1. `main.dart` crea `SharedPreferences`, `LocalAuthRepository` y `AuthSessionController`.
2. `main.dart` asigna `AppData.source = PersistentLocalMascotifyDataSource(...)`.
3. Las pantallas leen y mutan datos mediante `AppData`.
4. `AppData` delega en `MascotifyDataSource`.
5. `PersistentLocalMascotifyDataSource` persiste snapshots locales por cuenta.

La UI no deberia conocer si el dato viene de mock, persistencia local o backend remoto. Esa decision queda debajo de `AppData`.

## Separacion preparada

- `MascotifyDataSource`: contrato comun para lectura/mutacion de datos de Mascotify.
- `AppData`: fachada usada por la UI y punto estable de migracion.
- `PersistentLocalMascotifyDataSource`: implementacion local activa, basada en `SharedPreferences`.
- `MockMascotifyDataSource`: fallback/demo seed.
- `remote/RemoteMascotifyDataSource`: placeholder abstracto para una futura implementacion remota. No esta activo y no hace red.

## Que se reemplazaria o extenderia para backend real

La migracion no deberia empezar por pantallas. Deberia introducir una implementacion concreta de `MascotifyDataSource` o adaptadores por modulo debajo de esa interfaz.

Opciones futuras:

- Mantener `AppData` como fachada y cambiar la implementacion activa.
- Crear repositorios internos por modulo si el contrato empieza a crecer demasiado.
- Usar REST o GraphQL segun el backend elegido, sin decidirlo desde la app todavia.
- Mantener cache local para offline y sincronizacion gradual.

## Que NO esta implementado todavia

- Backend real.
- Llamadas HTTP.
- Firebase/Auth remota.
- Google Auth real.
- Endpoints activos.
- Sincronizacion local/remota.
- Resolucion de conflictos.
- Cache offline con estrategia formal.

## Estrategia recomendada

La estrategia mas segura es migrar por modulos, manteniendo la app local funcionando mientras cada modulo gana respaldo remoto.

Orden sugerido:

1. Auth real.
2. Usuario/perfil.
3. Mascotas.
4. Mensajes.
5. Notificaciones.
6. Feed/historial.

Para cada modulo:

- Definir IDs estables entre local y remoto.
- Agregar adaptador remoto inactivo o bajo flag interno.
- Migrar tests de contrato antes de cambiar UI.
- Mantener fallback local durante la transicion.
- Validar aislamiento por cuenta.

## Riesgos principales

- Conflictos entre datos locales y remotos si el usuario edita desde mas de un dispositivo.
- Autenticacion y permisos por cuenta/experiencia.
- Sincronizacion parcial de mensajes, notificaciones y feed.
- Offline/local cache y reintentos.
- Migracion de datos locales existentes a IDs remotos.
- Evitar que la UI empiece a depender de detalles de API.

## Regla de trabajo

Hasta que exista backend real, la app debe seguir usando la fuente local activa. Cualquier implementacion remota futura debe entrar debajo de `MascotifyDataSource`, con tests de contrato y sin romper los flujos locales actuales.
