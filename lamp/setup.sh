#!/bin/bash

######安装apache######
#编译安装apr与apr-util
tar jxf apr-1.4.6.tar.bz2
cd apr-1.4.6
./configure --prefix=/usr/local/apr
make &&  make install
cd ../
tar jxf apr-util-1.5.2.tar.bz2
cd apr-util-1.5.2
./configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr
make && make install
cd ../

yum -y install pcre-devel 
tar zxf httpd-2.4.4.tar.gz
cd httpd-2.4.4
./configure --prefix=/usr/local/apache  --enable-so --enable-rewrite  --enable-rewrite --with-pcre \ 
--with-apr=/usr/local/apr --with-apr-util=/usr/local/apr-util
