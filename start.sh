#!/usr/bin/env bash
set -e

echo "Running composer install..."
composer install --no-dev --working-dir=/var/www/html --optimize-autoloader --no-interaction

echo "Setting up storage directories..."
mkdir -p /var/www/html/storage/framework/{sessions,views,cache}
mkdir -p /var/www/html/storage/logs

echo "Setting permissions..."
chown -R nginx:nginx /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

echo "Waiting for database to be ready..."
sleep 5

echo "Publishing Livewire assets..."
php artisan livewire:publish --assets

echo "Running migrations..."
php artisan migrate --force

echo "Clearing all caches..."
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear

echo "Optimizing application..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "Starting services..."
exec /start.sh
