#!/bin/bash

# 等待 MariaDB 真正 Ready 后再继续
echo "Waiting for MariaDB at $MYSQL_HOSTNAME:3306..."
until mariadb -h"$MYSQL_HOSTNAME" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SELECT 1;" >/dev/null 2>&1; do
    echo "MariaDB not ready yet, sleeping..."
    sleep 2
done
echo "MariaDB is ready!"

cd /var/www/html

if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Downloading WordPress core files..."
    wp core download --allow-root

    echo "Creating WordPress configuration..."
    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=$MYSQL_HOSTNAME \
        --allow-root
fi

if ! wp core is-installed --allow-root; then
    echo "Installing WordPress..."
    wp core install \
        --url=$DOMAIN_NAME \
        --title="$WP_TITLE" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --allow-root

    echo "Creating additional user..."
    wp user create \
        $WP_USER $WP_EMAIL \
        --role=author \
        --user_pass=$WP_PASSWORD \
        --allow-root
        
    echo "WordPress installation completed!"
fi

# 赋予正确的权限
chown -R www-data:www-data /var/www/html
mkdir -p /run/php

# 前台启动 PHP-FPM
echo "Starting PHP-FPM..."
exec php-fpm8.2 -F