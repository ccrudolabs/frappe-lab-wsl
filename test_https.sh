#!/bin/bash
URL="https://site-test.local"

echo "🔍 Verificando acceso seguro a $URL ..."
curl -I --silent --insecure $URL | grep HTTP