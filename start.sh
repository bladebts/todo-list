#!/usr/bin/env bash
set -e

echo "Running composer install..."
composer install --no-dev --working-dir=/var/www/html --optimize-autoloader --no-interaction

echo "Creating database if not exists..."
touch /var/www/html/database/database.sqlite

echo "Setting permissions..."
chown -R nginx:nginx /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/database
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache
chmod 664 /var/www/html/database/database.sqlite

echo "Running migrations..."
php artisan migrate --force

echo "Caching config..."
php artisan config:cache

echo "Caching routes..."
php artisan route:cache

echo "Caching views..."
php artisan view:cache

echo "Starting services..."
exec /start.sh
