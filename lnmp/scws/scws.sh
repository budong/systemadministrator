SCWS-1.2.2 安装说明 
一：安装scws
wget http://www.xunsearch.com/scws/down/scws-1.2.2.tar.bz2
tar jxvf scws-1.2.2.tar.bz2 
cd scws-1.2.2
./configure --prefix=/usr/local/scws
make && make install
二: 用 wget 下载并解压词典，或从主页下载然后自行解压再将 *.xdb 放入 /usr/local/scws/etc 目录中
cd /usr/local/scws/etc
wget http://www.xunsearch.com/scws/down/scws-dict-chs-gbk.tar.bz2
wget http://www.xunsearch.com/scws/down/scws-dict-chs-utf8.tar.bz2
tar xvjf scws-dict-chs-gbk.tar.bz2
tar xvjf scws-dict-chs-utf8.tar.bz2
三：安装 php 扩展
cd /root/src/scws-1.2.2/phpext/
/usr/local/php_fpm/bin/phpize
./configure --with-scws=/usr/local/scws -with-php-config=/usr/local/php_fpm/bin/php-config
make && make install
四：修改php.ini
vi /usr/local/php_fpm/etc/php.ini
extension = scws.so
scws.default.charset = gbk
scws.default.fpath = /usr/local/scws/etc

参考文档：
http://www.xunsearch.com/scws/docs.php#instscws
