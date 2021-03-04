##
# dev stage
##
FROM php:8.0.2-fpm as dev

# Update packages
RUN apt-get update --quiet && \
    apt-get upgrade --quiet --yes && \
    rm -rf /var/lib/apt/lists/*

# Set application directory
RUN rm -r /var/www/html && \
    mkdir /var/www/app

WORKDIR /var/www/app

# Add some convenience
RUN echo "alias ll='ls -al'" > /etc/profile.d/app.sh

# Use php.ini for development
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# Install xdebug
RUN pecl install xdebug-3.0.3 && \
    docker-php-ext-enable xdebug

# Install Composer
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN apt-get update --quiet && \
    apt-get install --quiet --yes wget \
                                  unzip \
                                  libzip4 \
                                  libzip-dev \
                                  git && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-install -j$(nproc) zip && \
    wget https://raw.githubusercontent.com/composer/getcomposer.org/master/web/installer -O - -q | php -- --quiet --install-dir=/usr/local/bin --filename=composer

# Install symfony requirements
RUN apt-get update --quiet && \
    apt-get install --quiet --yes libicu-dev && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-install -j$(nproc) intl && \
    docker-php-ext-install -j$(nproc) opcache

# Install symfony installer
RUN wget https://get.symfony.com/cli/installer -O - | bash && \
    mv /root/.symfony/bin/symfony /usr/local/bin/symfony && \
    rm -rf /root/.symfony

##
# prod stage
##
FROM dev as prod

# Use php.ini for production
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Disable xdebug in production
RUN rm /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Install dependencies
ADD composer.json composer.lock symfony.lock ./
RUN composer install --no-interaction --no-dev --no-scripts --no-plugins

# Add app code
ADD . ./

CMD ["sh", "/var/www/app/start-app.sh"]
