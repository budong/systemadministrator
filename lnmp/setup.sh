#!/bin/sh
#writed by http://www.s135.com/nginx_php_v6

#解决包的依赖性
yum -y install gcc gcc-c++ autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libX11-devel libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel openldap openldap-devel nss_ldap openldap-clients openldap-servers cmake pcre perl-CPAN


#添加 www 用户
is_www=`grep '^www' /etc/passwd | wc -l`
if [ $is_www -eq 0 ];then 
    useradd www
fi

#add ld.so.conf
is_lib=`grep /usr/local/lib /etc/ld.so.conf|wc -l`
if [ $is_lib -eq 0 ];then 
    echo  "/usr/local/lib">>/etc/ld.so.conf
fi

#解决编码转换问题
#http://www.gnu.org/software/libiconv/
tar zxvf libiconv-1.14.tar.gz
cd libiconv-1.14/
./configure --prefix=/usr/local
make
make install
cd ../

#Mhash为PHP提供了多种哈希算法，如MD5，SHA1，GOST 等
#http://sourceforge.net/projects/mhash/files/?source=navbar
tar zxvf mhash-0.9.9.9.tar.gz
cd mhash-0.9.9.9/
./configure
make
make install
cd ../

#添加加密算法扩展库，支持DES, 3DES, RIJNDAEL, Twofish, IDEA, GOST, CAST-256, ARCFOUR, SERPENT, SAFER+等算法。
#http://mcrypt.hellug.gr/lib/
tar zxvf libmcrypt-2.5.8.tar.gz 
cd libmcrypt-2.5.8/
./configure
make
make install
/sbin/ldconfig
cd libltdl/
./configure --enable-ltdl-install
make
make install
cd ../../

tar zxvf mcrypt-2.6.8.tar.gz
cd mcrypt-2.6.8/
/sbin/ldconfig
./configure
make
make install
cd ../


ln -s /usr/local/lib/libmcrypt.la /usr/lib/libmcrypt.la
ln -s /usr/local/lib/libmcrypt.so /usr/lib/libmcrypt.so
ln -s /usr/local/lib/libmcrypt.so.4 /usr/lib/libmcrypt.so.4
ln -s /usr/local/lib/libmcrypt.so.4.4.8 /usr/lib/libmcrypt.so.4.4.8
ln -s /usr/local/lib/libmhash.a /usr/lib/libmhash.a
ln -s /usr/local/lib/libmhash.la /usr/lib/libmhash.la
ln -s /usr/local/lib/libmhash.so /usr/lib/libmhash.so
ln -s /usr/local/lib/libmhash.so.2 /usr/lib/libmhash.so.2
ln -s /usr/local/lib/libmhash.so.2.0.1 /usr/lib/libmhash.so.2.0.1
ln -s /usr/local/bin/libmcrypt-config /usr/bin/libmcrypt-config


if [ ! -d mysql-5.5.29 ];then
    mkdir -p /usr/local/mysql/
    tar zxvf mysql-5.5.29.tar.gz
    cd mysql-5.5.29/
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
    -DMYSQL_DATADIR=/data/mysql_db \
    -DSYSCONFDIR=/etc \
    -DDEFAULT_CHARSET=utf8 \
    -DDEFAULT_COLLATION=utf8_general_ci \
    -DWITH_EXTRA_CHARSETS:STRING=utf8,gbk \
    -DWITH_MYISAM_STORAGE_ENGINE=1 \
    -DWITH_INNOBASE_STORAGE_ENGINE=1 \
    -DWITH_MEMORY_STORAGE_ENGINE=1 \
    -DWITH_ARCHIVE_STORAGE_ENGINE=1 \
    -DWITH_READLINE=1 \
    -DENABLED_LOCAL_INFILE=1 \
    -DMYSQL_USER=mysql \
    -DENABLE_DTRACE=OFF \
    -DMYSQL_TCP_PORT=3306
    make
    make install
    cp support-files/my-medium.cnf /etc/my.cnf
    cd ..
    echo "/usr/local/mysql/lib">>/etc/ld.so.conf
    ldconfig
fi

#小内存可以加 --disable-fileinfo 编译参数
if [ ! -d php-5.3.21 ];then
cp -frp /usr/lib64/libldap* /usr/lib/
tar zxvf php-5.3.21.tar.gz
cd php-5.3.21/
./configure --prefix=/usr/local/php_fpm --with-config-file-path=/usr/local/php_fpm/etc --with-mysql=/usr/local/mysql \
--with-mysqli=/usr/local/mysql/bin/mysql_config --with-iconv-dir=/usr/local --with-freetype-dir --with-jpeg-dir --with-png-dir \
--with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath  --enable-bcmath \
--enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --with-curlwrappers --enable-mbregex \
--enable-fpm --enable-mbstring --with-mcrypt --with-gd \
--enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets \
--with-ldap --with-ldap-sasl --with-xmlrpc --enable-zip --enable-soap 
make ZEND_EXTRA_LIBS='-liconv'
make install
cp php.ini-production /usr/local/php_fpm/etc/php.ini
echo "php is ok!"
sleep 2
cd ..
fi

tar zxvf memcache-2.2.5.tgz
cd memcache-2.2.5/
/usr/local/php_fpm/bin/phpize
./configure --with-php-config=/usr/local/php_fpm/bin/php-config
make
make install
cd ..

tar jxvf eaccelerator-0.9.6.1.tar.bz2
cd eaccelerator-0.9.6.1/
/usr/local/php_fpm/bin/phpize
./configure --enable-eaccelerator=shared --with-php-config=/usr/local/php_fpm/bin/php-config
make
make install
cd ..

tar zxvf PDO_MYSQL-1.0.2.tgz
cd PDO_MYSQL-1.0.2/
/usr/local/php_fpm/bin/phpize
./configure --with-php-config=/usr/local/php_fpm/bin/php-config --with-pdo-mysql=/usr/local/mysql
make
make install
cd ..

#解决perl兼容问题
yum -y install perl-CPAN

tar zxvf ImageMagick.tar.gz
cd ImageMagick-6.5.1-2/
./configure
make
make install
cd ..

tar zxvf imagick-2.3.0.tgz
cd imagick-2.3.0/
/usr/local/php_fpm/bin/phpize
./configure --with-php-config=/usr/local/php_fpm/bin/php-config
make
make install
cd ..



sed -i 's#; extension_dir = "./"#extension_dir = "/usr/local/php_fpm/lib/php/extensions/no-debug-non-zts-20090626/"\nextension = \
"memcache.so"\nextension = "pdo_mysql.so"\nextension = "imagick.so"\n#' /usr/local/php_fpm/etc/php.ini
sed -i 's#; output_buffering#output_buffering = On#' /usr/local/php_fpm/etc/php.ini
sed -i "s#;always_populate_raw_post_data = On#always_populate_raw_post_data = On#g" /usr/local/php_fpm/etc/php.ini
sed -i "s#;cgi.fix_pathinfo=1#cgi.fix_pathinfo=0#g" /usr/local/php_fpm/etc/php.ini

#nginx pcre
#no need to do this
#yum -y install pcre

tar zxvf pcre-8.32.tar.gz
cd pcre-8.32/
./configure
make && make install
cd ../

tar zxvf nginx-1.2.7.tar.gz
cd nginx-1.2.7/
./configure --user=www --group=www --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module
make && make install
cd ../
