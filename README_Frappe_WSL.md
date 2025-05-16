# Entorno Frappe Docker - Versión Final (sin volumen conflictivo)

## Cambios realizados:
- Se eliminó el volumen `./frappe-bench/sites:/workspace/frappe-bench/sites` para evitar errores de permisos.
- Ahora `bench init` se puede ejecutar correctamente dentro del contenedor sin conflictos.

## Pasos de uso:

1. Ejecutar el entorno:
   ```bash
   ./reset_lab.sh
   ```

2. Dentro del contenedor:
   ```bash
   docker exec -it -u frappe frappe_secure_frappe_1 bash
   cd /workspace
   bench init frappe-bench --skip-assets --frappe-branch version-14
   cd frappe-bench
   bench set-mariadb-host mariadb
   ```

## Resultado:
Se crea correctamente `common_site_config.json` y la estructura esperada sin errores de permisos.