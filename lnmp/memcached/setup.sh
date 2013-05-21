tar zxf libmemcached-0.48.tar.gz
cd libmemcached-0.48
./configure --prefix=/usr/local/libmemcached --with-memcached
make
make install
cd ..

tar zxf memcached-1.0.2.tgz
cd memcached-1.0.2
/usr/local/webserver/php/bin/phpize 
./configure --enable-memcached --with-php-config=/usr/local/php_fpm/bin/php-config --with-libmemcached-dir=/usr/local/libmemcached
make
make install

#在php.ini中加入
#extension=memcached.so
#完成

