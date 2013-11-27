#!/bin/sh
#http://www.coreseek.cn/products-install/install_on_bsd_linux/
tar zxvf coreseek-3.2.13.tar.gz
cd coreseek-3.2.13/mmseg-3.2.13
./bootstrap
./configure --prefix=/usr/local/mmseg
make && make install
cd ../
cd csft-3.2.13/
export LIBS="-liconv"
./configure --prefix=/usr/local/coreseek --with-mysql --with-mmseg --with-mmseg-includes=/usr/local/mmseg/include/mmseg --with-mmseg-libs=/usr/local/mmseg/lib
make && make install
