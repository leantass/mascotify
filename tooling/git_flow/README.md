# Tooling Git Flow para Mascotify

Scripts simples para Windows CMD. Automatizan el flujo repetitivo de ramas, validacion local, commit, push y merge seguro a `main`.

No resuelven conflictos solos, no usan `push --force`, no tocan CI y no piden permisos raros.

## Scripts

`clean_generated.bat`

Limpia ruido local conocido:
- restaura registrants generados de macOS y Windows
- borra archivos accidentales vacios en la raiz llamados `git`, `dir` o `flutter`
- no borra carpetas con esos nombres
- no toca `.git`

`check_local.bat`

Ejecuta:

```bat
C:\src\flutter\bin\flutter.bat analyze
C:\src\flutter\bin\flutter.bat test
```

Si algo falla, frena con error.

`status.bat`

Muestra rama actual, `git status`, ultimos 5 commits y version de Flutter si existe `C:\src\flutter\bin\flutter.bat`.

`start_phase.bat`

Crea una fase nueva desde `main`, con pull previo y push upstream.

```bat
tooling\git_flow\start_phase.bat juagotecica7/mascotify-notificaciones-internas
```

Frena si el working tree no esta limpio o si la rama ya existe local/remota.

`save_phase.bat`

Valida, commitea y pushea la rama actual. No corre desde `main`.

```bat
tooling\git_flow\save_phase.bat "Agrega notificaciones internas persistentes"
```

Si no hay cambios, avisa y sale OK.

`merge_phase_to_main.bat`

Mergea una rama a `main`, valida en `main` y pushea `main`.

```bat
tooling\git_flow\merge_phase_to_main.bat juagotecica7/mascotify-notificaciones-internas
```

Si hay conflicto, frena. Hay que resolverlo manualmente.

`auto_phase.bat`

Hace el flujo completo desde la rama de trabajo: limpia, valida, commitea si hay cambios, pushea la rama, mergea a `main`, valida y pushea `main`.

```bat
tooling\git_flow\auto_phase.bat juagotecica7/mascotify-notificaciones-internas "Agrega notificaciones internas persistentes"
```

No corre si estas parado en `main`. Tambien frena si la rama actual no coincide con la rama recibida.

## Flujo recomendado

Crear rama:

```bat
tooling\git_flow\start_phase.bat juagotecica7/mascotify-notificaciones-internas
```

Guardar sin mergear:

```bat
tooling\git_flow\save_phase.bat "Agrega notificaciones internas persistentes"
```

Mergear a main:

```bat
tooling\git_flow\merge_phase_to_main.bat juagotecica7/mascotify-notificaciones-internas
```

Flujo automatico completo:

```bat
tooling\git_flow\auto_phase.bat juagotecica7/mascotify-notificaciones-internas "Agrega notificaciones internas persistentes"
```

## Si hay conflicto

El script frena y no intenta resolver nada. Resolve el conflicto manualmente, corre:

```bat
C:\src\flutter\bin\flutter.bat analyze
C:\src\flutter\bin\flutter.bat test
git status
```

Despues segui con el flujo manual que corresponda.

## Si fallan tests o analyze

El script frena y no pushea `main`. Arregla el problema, volve a correr `check_local.bat` y recien despues repetis el flujo.

## Que NO pegar en CMD

No pegues respuestas completas de Codex en CMD.

Pega solo comandos concretos, por ejemplo:

```bat
tooling\git_flow\status.bat
```

No pegues bloques con explicaciones, markdown, listas o texto largo.
