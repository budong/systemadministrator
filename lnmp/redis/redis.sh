#!/bin/sh

#https://github.com/nicolasff/phpredis
一：安装
wget --no-check-certificate http://github.com/owlient/phpredis/tarball/master -O phpredis.tar.gz
tar zxvf phpredis.tar.gz
cd owlient-phpredis-90ecd17/
/usr/local/php_fpm/bin/phpize
./configure -with-php-config=/usr/local/php_fpm/bin/php-config
make && make install

二：修改php.ini
vi /usr/local/php_fpm/etc/php.ini
extension = "redis.so"

