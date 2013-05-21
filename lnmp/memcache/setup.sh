#!/bin/sh
tar zxf libevent-1.4.13-stable.tar.gz
cd libevent-1.4.13-stable
./configure
make && make install
cd ..

tar zxf memcached-1.4.5.tar.gz
cd  memcached-1.4.5
./configure --prefix=/usr/local/memcached
make && make install
cd ..

echo "/usr/local/lib" >> /etc/ld.so.conf
ldconfig
/usr/local/memcached/bin/memcached -d -m 20 -u root -l 127.0.0.1 -p 11211
