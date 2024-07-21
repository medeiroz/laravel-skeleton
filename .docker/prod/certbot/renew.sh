docker-compose run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/certbot \
    --email smedeiros.flavio@gmail.com \
    -d skeleton.com \
    -d www.skeleton.com \
    --agree-tos \
    --force-renewal" certbot
