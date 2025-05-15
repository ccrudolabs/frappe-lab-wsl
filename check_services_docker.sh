#!/bin/bash

echo "🔍 Verificando servicios del laboratorio Frappe Docker (modo interno Docker)"
echo "----------------------------------------"

check_mariadb() {
  echo -n "▶️ MariaDB desde contenedor... "
  docker exec frappe_secure_frappe_1 mysql -h mariadb -u root -pRoedor1243. -e "SELECT VERSION();" >/dev/null 2>&1 && echo "🟢 OK" || echo "🔴 FALLA"
}

check_redis() {
  echo -n "▶️ Redis desde contenedor... "
  docker exec frappe_secure_frappe_1 redis-cli -h redis ping | grep -q PONG && echo "🟢 OK" || echo "🔴 FALLA"
}

check_frappe() {
  echo -n "▶️ Frappe en 127.0.0.1:9000... "
  curl -sSf http://127.0.0.1:9000 >/dev/null && echo "🟢 OK" || echo "🔴 FALLA"
}

check_nginx() {
  echo -n "▶️ NGINX en 127.0.0.1:80... "
  curl -sSf http://127.0.0.1 >/dev/null && echo "🟢 OK" || echo "🔴 FALLA"
}

check_mariadb
check_redis
check_frappe
check_nginx

echo "----------------------------------------"
echo "ℹ️ Validaciones realizadas desde host (WSL) y vía contenedor Docker."
