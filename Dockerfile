FROM php:8.2-cli

# Set working directory
WORKDIR /var/www

# Install system dependencies
RUN apt-get update && apt-get install -y \    unzip \    git \    curl \    libzip-dev \    zip \    && docker-php-ext-install zip pdo pdo_mysql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy existing application directory contents
COPY . /var/www

# Install PHP dependencies
RUN composer install

# Copy .env.example if .env does not exist
RUN cp .env.example .env || true

# Generate application key
RUN php artisan key:generate || true

# Expose port 8080
EXPOSE 8080

# Start the PHP built-in server
CMD ["php", "-S", "0.0.0.0:8080", "-t", "public"]
