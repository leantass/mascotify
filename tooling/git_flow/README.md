# Tooling Git Flow para Mascotify

Scripts simples para Windows CMD. El flujo recomendado es semi-automatico: reduce comandos repetidos, pero mantiene control humano antes de avanzar, revisar GitHub Actions o mergear a `main`.

No resuelven conflictos solos, no usan `push --force`, no hacen deploy, no tocan CI y no reemplazan la revision visual de la app.

## Flujo recomendado

### A. Crear rama

```bat
tooling\git_flow\start_phase.bat juagotecica7/mascotify-nueva-fase
```

Este script limpia ruido local conocido, verifica que el working tree este limpio, cambia a `main`, hace `git pull origin main`, crea la rama nueva y la publica con upstream.

Frena si la rama ya existe local o remotamente.

### B. Trabajar con Codex

Usa Codex para hacer los cambios de la fase.

No pegues respuestas completas de Codex en CMD. Pega solo comandos concretos.

### C. Guardar fase

```bat
tooling\git_flow\save_phase.bat "Mensaje del commit"
```

Este script no corre desde `main`. Limpia ruido local, ejecuta validaciones locales, commitea si hay cambios y pushea la rama actual.

Si no hay cambios, avisa y sale OK.

### D. Revisar GitHub Actions

Espera a que el CI de GitHub Actions quede verde en la rama.

### E. Probar visualmente

Antes de mergear, revisa la app visualmente cuando corresponda.

### F. Mergear a main

```bat
tooling\git_flow\merge_phase_to_main.bat juagotecica7/mascotify-nueva-fase
```

Este script limpia ruido local, verifica que el working tree este limpio, cambia a `main`, actualiza `main`, mergea la rama indicada, ejecuta validaciones locales en `main` y solo si pasan pushea `main`.

Si hay conflicto, frena y no intenta resolverlo automaticamente.

## Scripts

### clean_generated.bat

Limpia ruido local conocido:

- restaura registrants generados de macOS y Windows
- borra archivos accidentales vacios en la raiz llamados `git`, `dir` o `flutter`
- no borra carpetas con esos nombres
- no toca `.git`

### check_local.bat

Ejecuta:

```bat
C:\src\flutter\bin\flutter.bat analyze
C:\src\flutter\bin\flutter.bat test
C:\src\flutter\bin\flutter.bat build web
```

Si algo falla, frena con error. Si pasa, imprime:

```bat
ANALYZE OK
TESTS OK
BUILD WEB OK
```

### status.bat

Muestra rama actual, `git status`, ultimos 5 commits y version de Flutter si existe `C:\src\flutter\bin\flutter.bat`.

```bat
tooling\git_flow\status.bat
```

### start_phase.bat

Crea una fase nueva desde `main`, con pull previo y push upstream.

```bat
tooling\git_flow\start_phase.bat juagotecica7/mascotify-nueva-fase
```

Frena si el working tree no esta limpio o si la rama ya existe local/remota.

### save_phase.bat

Valida, commitea y pushea la rama actual. No corre desde `main`.

```bat
tooling\git_flow\save_phase.bat "Mensaje del commit"
```

Si no hay cambios o aparece `nothing to commit, working tree clean`, avisa y sale OK.

### merge_phase_to_main.bat

Mergea una rama a `main`, valida en `main` y pushea `main`.

```bat
tooling\git_flow\merge_phase_to_main.bat juagotecica7/mascotify-nueva-fase
```

Si hay conflicto, frena. Hay que resolverlo manualmente.

### auto_phase.bat

Existe, pero no es el flujo principal recomendado por ahora.

Hace el flujo completo desde la rama de trabajo: limpia, valida, commitea si hay cambios, pushea la rama, mergea a `main`, valida y pushea `main`.

```bat
tooling\git_flow\auto_phase.bat juagotecica7/mascotify-nueva-fase "Mensaje del commit"
```

Usalo solo cuando explicitamente quieras automatizar todo ese recorrido.

## Si hay conflicto

El script frena y no intenta resolver nada. Resolve el conflicto manualmente, revisa el estado y corre las validaciones antes de seguir:

```bat
tooling\git_flow\status.bat
tooling\git_flow\check_local.bat
```

## Si fallan tests, analyze o build web

El script frena y no pushea `main`. Arregla el problema, volve a correr `check_local.bat` y recien despues repetis el flujo que corresponda.

## Que NO pegar en CMD

No pegues respuestas completas de Codex en CMD.

Pega solo comandos concretos, por ejemplo:

```bat
tooling\git_flow\status.bat
```

No pegues bloques con explicaciones, markdown, listas o texto largo.
