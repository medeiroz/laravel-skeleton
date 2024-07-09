#!/bin/sh

set -e

# Installation of dependencies
composer update
composer dump-autoload --optimize
composer clear-cache
npm update

# Configure permissions
chmod 777 -R storage/
chmod 777 -R bootstrap/cache/

# artisan commands
php artisan optimize:clear
find public -type l -delete
php artisan storage:link
php artisan migrate --seed --force
php artisan ide-helper:generate
php artisan horizon:publish
php artisan log-viewer:publish

# Start supervisord
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
