#!/bin/bash

echo "🔍 Verificando estado de los contenedores del entorno Frappe..."

EXPECTED_CONTAINERS=("frappe_secure_frappe_1" "frappe_secure_mariadb_1" "frappe_secure_redis_1" "frappe_secure_nginx_1")

ALL_RUNNING=true

for container in "${EXPECTED_CONTAINERS[@]}"; do
  status=$(docker ps --filter "name=$container" --format "{{.Status}}")
  if [ -z "$status" ]; then
    echo "❌ Contenedor no encontrado o no está corriendo: $container"
    ALL_RUNNING=false
  else
    echo "✅ $container -> $status"
  fi
done

if [ "$ALL_RUNNING" = false ]; then
  echo ""
  echo "⚠️  Uno o más contenedores no están activos. Sugerencia:"
  echo "➡️  Ejecutá: docker-compose up -d"
else
  echo ""
  echo "✅ Todos los contenedores están activos."
fi