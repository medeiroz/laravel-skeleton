#!/bin/sh

set -e

# Configure permissions
chmod 777 -R storage/
chmod 777 -R bootstrap/cache/

# artisan commands
php artisan storage:link
php artisan horizon:publish
php artisan log-viewer:publish
# php artisan l5-swagger:generate
php artisan optimize
php artisan event:cache
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Start supervisord
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
