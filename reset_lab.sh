#!/bin/bash

echo "🧼 Deteniendo contenedores y eliminando volúmenes existentes..."
docker-compose down -v --remove-orphans

echo "🧹 Eliminando bench anterior si existe..."
rm -rf frappe-bench

echo "🚀 Levantando contenedores..."
docker-compose up -d

echo "📝 Crear manualmente el bench dentro del contenedor:"
echo "  docker exec -it -u frappe frappe_secure_frappe_1 bash"
echo "  cd /workspace"
echo "  bench init frappe-bench --skip-assets --frappe-branch version-14"
echo "  cd frappe-bench"
echo "  bench set-mariadb-host mariadb"
echo ""
echo "✅ Entorno limpio y listo para inicializar correctamente."