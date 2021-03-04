#!/bin/sh

###
# Production Entrypoint. Allows to execute startup tasks.
##

# Perform startup tasks
composer install

# Start PHP Fast Process Manager
php-fpm
