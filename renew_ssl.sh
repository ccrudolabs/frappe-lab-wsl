#!/bin/bash
docker-compose run --rm certbot renew --webroot --webroot-path=/var/www/certbot
docker-compose kill -s HUP nginx
