
# Despliegue de Frappe + NGINX con Docker

## Índice de Contenido

1. Introducción
2. Estructura de Archivos
3. Pasos para Despliegue
4. Verificación de Servicios
5. Acceso y Redirección
6. Configuración de Red en Azure
7. Configuración de HTTPS con Let's Encrypt
8. Buenas Prácticas Aplicadas

## 1. Introducción

Este proyecto configura un entorno completo de Frappe ERP utilizando contenedores Docker para los servicios principales, y un contenedor adicional de NGINX como proxy reverso que puede servir tráfico HTTPS mediante Let's Encrypt.

## 2. Estructura de Archivos

- `docker-compose.yml`: Define servicios para MariaDB, Redis, Frappe y NGINX.
- `nginx.conf`: Redirecciona las peticiones HTTP (puerto 80) hacia el contenedor de Frappe (puerto 9000).

## 3. Pasos para Despliegue

### 3.1 Descargar y subir archivos al servidor

```bash
scp frappe_with_nginx.zip usuario@IP_REMOTA:/ruta/proyecto
```

O en WSL:

```bash
cp /mnt/c/Users/TU_USUARIO/Downloads/frappe_with_nginx.zip ~/proyecto/
cd ~/proyecto
unzip frappe_with_nginx.zip
```

### 3.2 Reemplazar archivos

```bash
cp -f nginx.conf ./nginx.conf
cp -f docker-compose.yml ./docker-compose.yml
```

### 3.3 Ejecutar servicios

```bash
docker-compose down
docker-compose up --build -d
```

## 4. Verificación de Servicios

```bash
docker ps
curl http://localhost
docker logs nginx
```

## 5. Acceso y Redirección

- Navegador: `http://<IP_PUBLICA>`
- Redirección del puerto 80 al 9000 de Frappe se gestiona por `nginx.conf`.

## 6. Configuración de Red en Azure

Asegúrate que el puerto 80 esté abierto en el NSG:

```bash
az network nsg rule create   --resource-group tu-grupo   --nsg-name tu-nsg   --name AllowHTTP   --priority 100   --direction Inbound   --access Allow   --protocol Tcp   --destination-port-ranges 80
```

## 7. Configuración de HTTPS con Let's Encrypt

### 7.1 Requisitos

- Tener dominio registrado (ej: `midominio.com`)
- El dominio debe apuntar a la IP pública de tu VM (via DNS A record)

### 7.2 Usar NGINX con Certbot

Reemplaza el servicio `nginx` en tu `docker-compose.yml` con:

```yaml
  nginx:
    image: nginx:latest
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./certbot/www:/var/www/certbot
      - ./certbot/conf:/etc/letsencrypt
    depends_on:
      - frappe
    networks:
      - frappe-net
```

Agrega un servicio `certbot`:

```yaml
  certbot:
    image: certbot/certbot
    volumes:
      - ./certbot/www:/var/www/certbot
      - ./certbot/conf:/etc/letsencrypt
    command: certonly --webroot --webroot-path=/var/www/certbot --email tu-email@dominio.com --agree-tos --no-eff-email -d midominio.com
```

### 7.3 Configuración en `nginx.conf` para SSL

```nginx
server {
    listen 80;
    server_name midominio.com;

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        return 301 https://$host$request_uri;
    }
}

server {
    listen 443 ssl;
    server_name midominio.com;

    ssl_certificate /etc/letsencrypt/live/midominio.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/midominio.com/privkey.pem;

    location / {
        proxy_pass http://frappe:9000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## 8. Buenas Prácticas Aplicadas

- Separación de servicios en contenedores dedicados.
- Red Docker interna segura.
- Eliminación de configuraciones del host (`chpasswd`, `nginx`, `supervisor`).
- Redirección vía NGINX en contenedor externo.
- Soporte para HTTPS con Let's Encrypt.
