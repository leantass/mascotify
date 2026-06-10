# Codex operational workflow

## Al terminar una tarea de UI o funcionalidad visible

Codex debe ejecutar las validaciones locales que correspondan al cambio antes de abrir la app. Para cambios Flutter visibles, la base esperada es:

```bat
tooling\git_flow\check_local.bat
```

Si las validaciones pasan, Codex debe ejecutar:

```bat
tooling\demo\open_app_after_task.bat
```

Ese comando genera el build web, prepara el paquete funcional localhost y abre Mascotify automaticamente en el navegador. Codex debe informar la URL abierta y aclarar si la app quedo abierta o si hubo un error.

No se deben commitear builds, ZIPs, APKs ni artefactos generados por la demo. Si Flutter deja cambios locales descartables en archivos generados de plugins, Codex puede restaurarlos antes del estado final.
