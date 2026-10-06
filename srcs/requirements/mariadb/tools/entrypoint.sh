#!/bin/bash

# 1. 确保 mysqld 运行时目录存在并具有正确的权限
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# 2. 检查数据库是否已经初始化过系统表
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null
fi

# 3. 运行 bootstrap 初始化 SQL
tfile=`mktemp`
cat << EOF > $tfile
FLUSH PRIVILEGES;

-- 设置 root 密码及允许远程访问
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

-- 创建业务数据库及普通用户
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF

echo "Applying MariaDB configuration..."
mysqld --user=mysql --bootstrap < $tfile
rm -f $tfile

echo "Starting MariaDB server..."
exec mysqld --user=mysql