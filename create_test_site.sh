#!/bin/bash

SITE_NAME="site-test.local"
ADMIN_PASSWORD="Roedor1243."
MYSQL_ROOT_PASSWORD="Roedor1243."
LOGFILE="$HOME/create_site.log"

echo "📄 Registrando log en $LOGFILE"
exec > >(tee -a "$LOGFILE") 2>&1

echo "🔍 Verificando si el sitio '$SITE_NAME' ya existe..."
if [ -d "sites/$SITE_NAME" ]; then
  echo "✅ El sitio '$SITE_NAME' ya existe. No se necesita crear de nuevo."
  exit 0
fi

echo "🚀 Creando nuevo sitio: $SITE_NAME"

bench new-site "$SITE_NAME"   --mariadb-root-password "$MYSQL_ROOT_PASSWORD"   --admin-password "$ADMIN_PASSWORD"   --no-input

if [ $? -eq 0 ]; then
  echo "✅ Sitio '$SITE_NAME' creado correctamente con contraseña de administrador predefinida."
else
  echo "❌ Error al crear el sitio '$SITE_NAME'. Revisá el log."
  exit 1
fi

# Opcional: instalar Frappe explícitamente
bench --site "$SITE_NAME" install-app frappe

# Activar scheduler
bench --site "$SITE_NAME" set-config enable_scheduler 1
echo "✅ Scheduler activado para $SITE_NAME"