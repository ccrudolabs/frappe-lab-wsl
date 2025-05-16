#!/bin/bash

echo "🚀 Iniciando configuración automatizada del entorno Frappe Bench..."

WORKDIR="/home/frappe/dev"
BENCH_DIR="$WORKDIR/frappe-bench"

# Verificación robusta del usuario actual
if [ "$(id -un)" != "frappe" ]; then
  echo "❌ Este script debe ejecutarse dentro del contenedor como el usuario 'frappe'."
  echo "   Usá: docker exec -it -u frappe frappe_secure_frappe_1 bash"
  exit 1
fi

# Paso 1: Eliminar intento anterior si existe
if [ -d "$BENCH_DIR" ]; then
  echo "⚠️  Eliminando bench anterior en: $BENCH_DIR"
  rm -rf "$BENCH_DIR"
fi

# Paso 2: Verificar conectividad con GitHub
echo "🌐 Verificando acceso a GitHub..."
if ! git ls-remote https://github.com/frappe/frappe.git &> /dev/null; then
  echo "❌ No se puede acceder a https://github.com/frappe/frappe.git"
  echo "   Verificá tu red o DNS dentro del contenedor."
  exit 1
fi

# Paso 3: Inicializar bench
echo "🧱 Inicializando bench en $BENCH_DIR ..."
cd "$WORKDIR"
bench init frappe-bench --skip-assets --frappe-branch version-14
if [ $? -ne 0 ]; then
  echo "❌ Error durante 'bench init'. Abortando."
  exit 1
fi

# Paso 4: Configurar host de MariaDB
cd "$BENCH_DIR"
bench set-mariadb-host mariadb
if [ $? -ne 0 ]; then
  echo "❌ No se pudo establecer el host de MariaDB."
  exit 1
fi

# Paso 5: Validar resultado
if [ -f "sites/common_site_config.json" ]; then
  echo "✅ Bench creado y configurado exitosamente."
else
  echo "⚠️  Bench creado pero falta 'common_site_config.json'. Revisá manualmente."
fi