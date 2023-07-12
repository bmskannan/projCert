FROM php:8.1-apache


# Enable rewrite mode
RUN a2enmod rewrite

# Install necessary packages
RUN apt-get update && \
    apt-get install \
    libzip-dev \
    wget \
    git \
    unzip \
    -y --no-install-recommends

# Install PHP Extensions
RUN docker-php-ext-install zip pdo_mysql

RUN mkdir /app

WORKDIR /app

RUN git clone https://github.com/bmskannan/projCert.git

WORKDIR /app/projCert

# Copy virtual host into container
RUN cp 000-default.conf /etc/apache2/sites-available/000-default.conf

WORKDIR /app/projCert/website

RUN cp -r * /var/www

# Change the owner of the container document root
RUN chown -R www-data:www-data /var/www

# Start Apache in foreground
CMD ["apache2-foreground"]
