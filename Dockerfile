FROM mlocati/php-extension-installer:latest AS php_extensions

FROM php:8.2-cli

# Copy all required PHP extensions installer helper
COPY --from=php_extensions /usr/bin/install-php-extensions /usr/local/bin/

# Install all extensions Laravel and Svelte/Node projects commonly need
RUN install-php-extensions pdo_pgsql pgsql mbstring bcmath xml gd zip intl

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

# Run composer install with ignore platform reqs just in case
RUN composer install --no-dev --optimize-autoloader

EXPOSE 10000

CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=10000
