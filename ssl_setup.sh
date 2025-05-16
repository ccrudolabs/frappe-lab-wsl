#!/bin/bash

DOMAIN="site-test.local"
EMAIL="admin@site-test.local"

echo "🔐 Instalando Certbot para NGINX..."
sudo apt update
sudo apt install -y certbot python3-certbot-nginx

echo "🌐 Obteniendo certificados SSL para $DOMAIN ..."
sudo certbot --nginx -d $DOMAIN --non-interactive --agree-tos -m $EMAIL

echo "✅ Certificados instalados correctamente. Reiniciando nginx..."
sudo systemctl reload nginx