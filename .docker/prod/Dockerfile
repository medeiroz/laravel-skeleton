FROM medeiroz/php:8.3-fpm

MAINTAINER Flavio Medeiros <smedeiros.flavio@gmail.com>

ARG NODE_VERSION=22

# Install Node and NPM
RUN apt update \
    && curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm

# Copy settings
COPY .docker/prod/php/php.ini /usr/local/etc/php/conf.d/php.ini
COPY .docker/prod/php/opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY .docker/prod/php/php-fpm.conf /usr/local/etc/php/conf.d/php-fpm.conf
COPY .docker/prod/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Configure the cron job
RUN echo "* * * * * cd /app && /usr/local/bin/php artisan schedule:run >> /dev/null 2>&1" > /etc/cron.d/laravel-scheduler \
    && chmod 0644 /etc/cron.d/laravel-scheduler \
    && crontab /etc/cron.d/laravel-scheduler

# Copy project
COPY --chown=www-data:www-data . /app

WORKDIR /app

ARG COMPOSER_ALLOW_SUPERUSER=1

# install dependencies
RUN composer install --optimize-autoloader --no-dev --no-interaction
RUN npm ci

# Determine entrypoint
COPY .docker/prod/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 9000
EXPOSE 3000
EXPOSE 3001
EXPOSE 5173

ENTRYPOINT sh /entrypoint.sh
