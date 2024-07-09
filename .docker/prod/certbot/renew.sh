docker-compose run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/certbot \
    --email smedeiros.flavio@gmail.com \
    -d laravel-skeleton.com \
    -d www.laravel-skeleton.com \
    --agree-tos \
    --force-renewal" certbot
