##
# dev stage
##
FROM php:8.0.2-fpm as dev

# Set application directory
RUN rm -r /var/www/html && \
    mkdir /var/www/app

WORKDIR /var/www/app

# Add some convenience
RUN echo "alias ll='ls -al'" > /etc/profile.d/app.sh

# Use php.ini for development
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"


##
# prod stage
##
FROM dev as prod

# Use php.ini for production
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Add app code
ADD . ./

CMD ["sh", "/var/www/app/start-app.sh"]
