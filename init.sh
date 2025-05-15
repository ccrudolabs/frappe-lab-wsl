#!/bin/bash
# Inicializa Frappe Bench dentro de un contenedor Docker

set -euo pipefail

echo "Iniciando Frappe Bench..."

# Variables de entorno
dev_environment=true

# Validar si bench ya existe
if [ -d "/home/frappe/frappe-bench/apps/frappe" ]; then
    echo "Bench ya existe. Saltando inicialización."
    cd /home/frappe/frappe-bench
else
    echo "Creando nuevo bench..."

    export PATH="${NVM_DIR}/versions/node/v${NODE_VERSION_DEVELOP:-18}/bin/:${PATH}"

    bench init --skip-redis-config-generation frappe-bench
    cd frappe-bench

    echo "Configurando servicios externos..."
    if [ "$dev_environment" = true ]; then
        bench set-mariadb-host mariadb
        bench set-redis-cache-host redis:6379
        bench set-redis-queue-host redis:6379
        bench set-redis-socketio-host redis:6379
    fi

    echo "Modificando Procfile..."
    sed -i '/redis/d' Procfile || true
    sed -i '/watch/d' Procfile || true
    sed -i 's/bench serve.*/bench serve --port 80/' Procfile || true

    echo "Creando nuevo sitio..."
    bench new-site frappe-lms.local         --force         --mariadb-root-password 123         --admin-password admin         --mariadb-user-host-login-scope='%'

    bench use frappe-lms.local
fi

echo "Iniciando servidor Frappe..."
bench start
