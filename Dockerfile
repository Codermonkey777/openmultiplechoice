FROM php:8.2-fpm

# Install system dependencies and PHP extensions for Laravel & Postgres
RUN apt-get update && apt-get install -y \
    git curl libpng-dev libonig-dev libxml2-dev libpq-dev zip unzip \
    && docker-php-ext-install pdo pdo_pgsql pgsql mbstring exts-mbstring bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

COPY . .

# Install dependencies and build assets
RUN composer install --no-dev --optimize-autoloader

EXPOSE 8000

CMD php artisan serve --host=0.0.0.0 --port=8000
