 # Use the official PHP image from the Docker Hub
FROM php:8.2-cli

# Set the working directory inside the container
WORKDIR /var/www/html

# Install required dependencies for Slim and PHP extensions (e.g., PDO for database interaction)
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libpq-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_pgsql

# Install Composer (dependency manager for PHP)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the application code into the container
COPY . .

# Install PHP dependencies via Composer
RUN composer install --no-dev --optimize-autoloader

# Expose the port that PHP's built-in server will run on (default 8080)
EXPOSE 8080

# Start the PHP built-in web server and point it to the public directory
CMD ["php", "-S", "0.0.0.0:8080", "-t", "public"]
