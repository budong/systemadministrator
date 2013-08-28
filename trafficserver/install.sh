# built on centos 6.2
# Get traffic server pre-requisites
yum install gcc-c++ openssl-devel tcl-devel expat-devel pcre-devel make

# Get traffic server
wget http://mirror.bit.edu.cn/apache/trafficserver/trafficserver-3.2.5.tar.bz2
tar -jxvf trafficserver-3.2.5.tar.bz2
cd trafficserver-3.2.5

# Build traffic server
./configure  --prefix=/usr/local/trafficserver --with-user=www --with-group=www

# Install traffic server
make && make install

# Configure traffic server URL map
echo "map http://YOURDOMAIN.COM http://localhost" >> /usr/local/etc/trafficserver/remap.config
echo "reverse_map http://localhost http://YOURDOMAIN.COM" >> /usr/local/etc/trafficserver/remap.config

# Run traffic server
trafficserver restart
