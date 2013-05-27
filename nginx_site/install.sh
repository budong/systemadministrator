1.安装编译工具GCC等
yum -y install gcc gcc-c++ autoconf automake
2.安装依赖库
yum -y install zlib zlib-devel openssl openssl-devel pcre pcre-devel
3.安装nginx
tar zxvf nginx-1.2.7.tar.gz
cd nginx-1.2.7/
./configure --user=www --group=www --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module
make && make install
cd ../ 
