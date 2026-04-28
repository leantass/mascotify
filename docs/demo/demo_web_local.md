# Demo web local

## Que Es

La demo web local es una version compilada de Mascotify que se sirve desde `build\web` con un servidor estatico local. Sirve para mostrar la app en navegador sin correr `flutter run -d chrome` cada vez.

No es un deploy. No publica GitHub Pages, Firebase Hosting ni ningun hosting externo.

## Diferencias Entre Comandos

`flutter run -d chrome`

- Levanta la app en modo desarrollo.
- Es util para programar y depurar.
- Puede tardar menos al iterar cambios, pero depende del entorno Flutter corriendo.

`flutter build web`

- Genera una version web compilada.
- Deja los archivos listos en `build\web`.
- No abre navegador ni sirve la app por si solo.

Servir `build\web`

- Usa los archivos ya generados por `flutter build web`.
- Permite abrir la demo desde una URL local como `http://localhost:8080`.
- Es lo mas parecido a mostrar una build web estatica sin hacer deploy.

## Generar Build Web

Desde la raiz del proyecto `mascotify`:

```bat
C:\src\flutter\bin\flutter.bat build web
```

O usando el script del proyecto:

```bat
tooling\demo\build_web_demo.bat
```

El build queda generado en:

```text
build\web
```

El archivo principal esperado es:

```text
build\web\index.html
```

## Servir La Demo Local

Primero generar el build web. Despues ejecutar:

```bat
tooling\demo\serve_web_demo.bat
```

El script intenta servir la carpeta `build\web` en:

```text
http://localhost:8080
```

## Servir Manualmente Con Python

Si preferis hacerlo manualmente y Python esta disponible:

```bat
python -m http.server 8080 --directory build\web
```

Si el comando `python` no existe, probar:

```bat
py -m http.server 8080 --directory build\web
```

Luego abrir:

```text
http://localhost:8080
```

## Si Falla El Build

1. Ejecutar:

```bat
C:\src\flutter\bin\flutter.bat analyze
C:\src\flutter\bin\flutter.bat test
```

2. Revisar el error mostrado por Flutter.
3. Corregir el problema antes de volver a generar la demo.
4. Para una validacion completa local, ejecutar:

```bat
tooling\git_flow\check_local.bat
```

## Si No Hay Python

El script `serve_web_demo.bat` prueba `python` y luego `py`. Si ninguno existe, no instala nada.

En ese caso, se puede servir `build\web` con cualquier servidor estatico simple disponible en la maquina. Evitar agregar dependencias npm solo para esta demo local.

## Flujo Recomendado Para Demo

```bat
tooling\demo\build_web_demo.bat
tooling\demo\serve_web_demo.bat
```

Despues abrir:

```text
http://localhost:8080
```
