# built on centos 6.2
# Get traffic server pre-requisites
yum install gcc-c++ openssl-devel tcl-devel expat-devel pcre-devel make

# Get traffic server
wget http://apache.tradebit.com/pub/trafficserver/trafficserver-3.1.3-unstable.tar.bz2
tar -xf trafficserver-3.1.3-unstable.tar.bz2
cd trafficserver-3.1.3-unstable

# Build traffic server
./configure
make -j 8

# Install traffic server
make install
ln -s /usr/local/bin/trafficserver /etc/init.d/trafficserver
chkconfig --add trafficserver
chkconfig trafficserver on

# Configure traffic server URL map
echo "map http://YOURDOMAIN.COM http://localhost" >> /usr/local/etc/trafficserver/remap.config
echo "reverse_map http://localhost http://YOURDOMAIN.COM" >> /usr/local/etc/trafficserver/remap.config

# Run traffic server
trafficserver restart
