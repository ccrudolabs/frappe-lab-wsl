
#!/bin/bash
# Inicializa Frappe Bench dentro de un contenedor Docker en entorno de laboratorio (WSL o Azure)

set -euo pipefail

echo "🟢 Iniciando Frappe Bench..."

# Cargar variables de entorno
echo "📦 Cargando archivo .env..."
source /workspace/.env

BENCH_PATH="/workspace/frappe-bench"

# Verificar si el bench ya está correctamente instalado
if [ -d "$BENCH_PATH" ] && [ -f "$BENCH_PATH/Procfile" ] && [ -d "$BENCH_PATH/apps" ]; then
    echo "⚠️  El bench ya existe y está completo. Saltando inicialización..."
    cd "$BENCH_PATH"
else
    echo "🛠️  Creando nuevo bench en $BENCH_PATH..."
    cd /workspace

    bench init --skip-redis-config-generation frappe-bench
    cd frappe-bench

    echo "🔧 Configurando servicios de Redis y MariaDB..."
    bench set-mariadb-host mariadb
    bench set-redis-cache-host redis:6379
    bench set-redis-queue-host redis:6379
    bench set-redis-socketio-host redis:6379

    echo "🧹 Limpiando Procfile para entorno de laboratorio..."
    sed -i '/redis/d' Procfile || true
    sed -i '/watch/d' Procfile || true
    sed -i 's/bench serve.*/bench serve --port 9000/' Procfile || true

    echo "🌐 Creando sitio: $SITE_NAME"
    bench new-site "$SITE_NAME" \
        --force \
        --mariadb-root-password "$MYSQL_ROOT_PASSWORD" \
        --admin-password "$FRAPPE_ADMIN_PASS" \
        --mariadb-user-host-login-scope='%'

    bench use "$SITE_NAME"
fi

echo "✅ Inicialización completada. El servidor puede iniciarse con:"
echo "   cd $BENCH_PATH && bench start"
