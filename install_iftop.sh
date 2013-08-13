#!/bin/sh
######iftop######
yum -y install wget
wget http://www.ex-parrot.com/pdw/iftop/download/iftop-1.0pre2.tar.gz

#依赖的库
yum -y install flex byacc  libpcap ncurses ncurses-devel libpcap-devel

if which iftop 2>/dev/null;then
    echo "iftop exists"
    rm -rf iftop-1.0pre2.tar.gz
else
    tar zxvf iftop-1.0pre2.tar.gz
    cd iftop-1.0pre2
    ./configure
    make && make install
    cd ../ 
    rm -rf iftop-1.0pre2
    rm -rf iftop-1.0pre2.tar.gz
fi
