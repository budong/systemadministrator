#!/bin/sh

######一：下载######
wget http://haproxy.1wt.eu/download/1.4/src/haproxy-1.4.24.tar.gz

######二：安装######
#安装文档请参考 haproxy-1.4.24/README
#uname -a           //查看linux内核版本
tar zxvf haproxy-1.4.24.tar.gz
cd haproxy-1.4.24
make TARGET=linux26 PREFIX=/usr/local/haproxy
make install PREFIX=/usr/local/haproxy

更多资料请参考：http://haproxy.1wt.eu/
