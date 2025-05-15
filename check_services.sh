#!/bin/bash

echo "🔍 Verificando servicios del laboratorio Frappe Docker"

check_service() {
    local name=$1
    local host=$2
    local port=$3
    echo -n "▶️ $name en $host:$port... "
    (echo > /dev/tcp/$host/$port) >/dev/null 2>&1 && echo "🟢 OK" || echo "🔴 FALLA"
}

echo "----------------------------------------"
check_service "MariaDB" "127.0.0.1" "3306"
check_service "Redis" "127.0.0.1" "6379"
check_service "Frappe (directo)" "127.0.0.1" "9000"
check_service "NGINX (proxy)" "127.0.0.1" "80"
echo "----------------------------------------"

echo "ℹ️ También podés verificar acceso desde navegador:"
echo "   👉 http://localhost"
echo "   👉 http://frappe.local (si configuraste /etc/hosts)"
