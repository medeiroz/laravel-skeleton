FROM php:8.3-fpm

MAINTAINER Flavio Medeiros <smedeiros.flavio@gmail.com>

ARG NODE_VERSION=22

# Install Ubuntu Linux dependencies
RUN apt update && apt-get -y install curl git zip unzip libzip-dev cron $PHPIZE_DEPS \
    libcurl4-openssl-dev pkg-config libssl-dev supervisor

# Install PHP extensions
RUN docker-php-ext-install opcache pcntl pdo_mysql zip sockets
RUN pecl update-channels && \
    pecl install ds igbinary && \
    docker-php-ext-enable ds igbinary

RUN pecl install -D 'enable-redis-igbinary="yes"' redis && \
    docker-php-ext-enable redis

RUN apt-get update && apt-get install -y \
		libfreetype-dev \
		libjpeg62-turbo-dev \
		libpng-dev \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install -j1 gd

# Copy settings
COPY .docker/prod/php/php.ini /usr/local/etc/php/conf.d/php.ini
COPY .docker/prod/php/opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY .docker/prod/php/php-fpm.conf /usr/local/etc/php/conf.d/php-fpm.conf
COPY .docker/prod/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Configure the cron job
RUN echo "* * * * * cd /app && /usr/local/bin/php artisan schedule:run >> /dev/null 2>&1" > /etc/cron.d/laravel-scheduler \
    && chmod 0644 /etc/cron.d/laravel-scheduler \
    && crontab /etc/cron.d/laravel-scheduler

# Install Composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Install Node
RUN curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm

# Copy project
COPY --chown=www-data:www-data . /app

WORKDIR /app

ARG COMPOSER_ALLOW_SUPERUSER=1

# Determine entrypoint
COPY .docker/prod/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 9000
EXPOSE 3000
EXPOSE 3001
EXPOSE 5173

ENTRYPOINT sh /entrypoint.sh
