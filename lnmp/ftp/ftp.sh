1、找到原来的源码包解压一下
cd /root/src/lnmp-budong-2013/php-5.3.21/ext/ftp
2、调用phpize程序生成编译配置文件
/usr/local/php_fpm/bin/phpize
3. 编译扩展库，分别执行下面的configure和make命令。
./configure --with-php-config=/usr/local/php_fpm/bin/php-config
make && make install

