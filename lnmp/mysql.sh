#!/bin/sh

#创建数据存放目录
mkdir -p /data/mysql_db/

#创建用户和用户组与赋予数据存放目录权限
groupadd mysql
useradd -g mysql mysql
chown mysql.mysql -R /data/mysql_db/

#设置mysql目录权限
cd /usr/local/mysql 
chown -R root:mysql .
chown -R mysql:mysql data


#初始化数据库
cd /usr/local/mysql/
scripts/mysql_install_db  --user=mysql  --basedir=/usr/local/mysql --datadir=/data/mysql_db/

#设置mysqld的开机启动:
cd /usr/local/mysql/
cp support-files/mysql.server /etc/init.d/mysql
chmod 755 /etc/init.d/mysql
chkconfig mysql on


###########################参照文章#########################
#点评：本文为大家介绍在CentOS-6.3中安装与配置Mysql-5.5.29的方法，有需要的朋友不妨参考下
#一、安装mysql
#
#安装方式分为：rpm和源码编译安装两种，本文采用mysql源码编译方式，编译器使用Cmake。
#软件需要mysql-5.5.29.tar.gz和cmake-2.8.10.2.tar.gz，请自行下载。
#
#下载地址：
#http://mysql.mirror.kangaroot.net/Downloads/
#http://www.cmake.org/files/v2.8/cmake-2.8.10.2.tar.gz
#
#其中mysql使用最新的稳定版本，即最新试用版的上一个版本，且非rc或者alpha的版本，Cmake直接用的最新版。
#1.上传mysql-5.5.29.tar.gz和cmake-2.8.10.2.tar.gz到/usr/local文件夹下。
#2.CentOS安装g++和ncurses-devel
#
#
#
#
#复制代码代码如下:
#[root@zck local]# yum install gcc-c++
#[root@zck local]# yum install ncurses-devel
#
#
#3.cmake的安装
#
#
#
#
#复制代码代码如下:
#[root@zck]# tar -zxv -f cmake-2.8.10.2.tar.gz // 解压压缩包
#[root@zck local]# cd cmake-2.8.10.2
#[root@zck cmake-2.8.10.2]# ./configure
#[root@zck cmake-2.8.10.2]# make
#[root@zck cmake-2.8.10.2]# make install
#
#
#4.将cmake永久加入系统环境变量
#用vi在文件/etc/profile文件中增加变量，使其永久有效，
#[root@zck local]# vi /etc/profile
#
#在文件末尾追加以下两行代码：
#
#
#
#复制代码代码如下:
#PATH=/usr/local/cmake-2.8.10.2/bin:$PATH
#export PATH
#
#
#执行以下代码使刚才的修改生效：
#[root@zck local]# source /etc/profile
#
#用 export 命令查看PATH值
#[root@zck local]# echo $PATH
#
#5.创建mysql的安装目录及数据库存放目录
#
#
#
#复制代码代码如下:
#[root@zck]# mkdir -p /usr/local/mysql //安装mysql
#[root@zck]# mkdir -p /usr/local/mysql/data //存放数据库
#
#
#6.创建mysql用户及用户组
#
#
#
#复制代码代码如下:
#[root@zck] groupadd mysql
#[root@zck] useradd -r -g mysql mysql
#
#
#7.编译安装mysql
#
#
#
#复制代码代码如下:
#[root@zck local]# tar -zxv -f mysql-5.5.29.tar.gz //解压
#[root@zck local]# cd mysql-5.5.29
#[root@zck mysql-5.5.29]#
#cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
#-DMYSQL_UNIX_ADDR=/usr/local/mysql/mysql.sock \
#-DDEFAULT_CHARSET=utf8 \
#-DDEFAULT_COLLATION=utf8_general_ci \
#-DWITH_MYISAM_STORAGE_ENGINE=1 \
#-DWITH_INNOBASE_STORAGE_ENGINE=1 \
#-DWITH_MEMORY_STORAGE_ENGINE=1 \
#-DWITH_READLINE=1 \
#-DENABLED_LOCAL_INFILE=1 \
#-DMYSQL_DATADIR=/usr/local/mysql/data \
#-DMYSQL_USER=mysql \
#-DMYSQL_TCP_PORT=3306
#[root@zck mysql-5.5.29]# make
#[root@zck mysql-5.5.29]# make install
#
#
#8.检验是否安装成功
#
#
#
#
#复制代码代码如下:
#[root@zck mysql-5.5.29]# cd /usr/local/mysql/
#[root@zck mysql]# ls
#bin COPYING data docs include INSTALL-BINARY lib man mysql-test README scripts share sql-bench support-files
#
#
#有bin等以上文件的话，则说明成功安装mysql。
#
#二、配置mysql
#
#9.设置mysql目录权限
#
#
#
#复制代码代码如下:
#[root@zck mysql]# cd /usr/local/mysql //把当前目录中所有文件的所有者设为root，所属组为mysql
#[root@zck mysql]# chown -R root:mysql .
#[root@zck mysql]# chown -R mysql:mysql data
#
#
#10.将mysql的启动服务添加到系统服务中
#
#
#
#复制代码代码如下:
#[root@zck mysql]# cp support-files/my-medium.cnf /etc/my.cnf
#cp：是否覆盖"/etc/my.cnf"？ y
#
#
#11.创建系统数据库的表
#
#
#
#复制代码代码如下:
#[root@zck mysql]# cd /usr/local/mysql
#[root@zck mysql]# scripts/mysql_install_db --user=mysql
#
#
#12.设置环境变量
#
#
#
#复制代码代码如下:
#[root@zck ~]# vi /root/.bash_profile
#在修改PATH=$PATH:$HOME/bin为：
#PATH=$PATH:$HOME/bin:/usr/local/mysql/bin:/usr/local/mysql/lib
#[root@zck ~]# source /root/.bash_profile //使刚才的修改生效
#
#
#13.手动启动mysql
#
#
#
#复制代码代码如下:
#[root@zck ~]# cd /usr/local/mysql
#[root@zck mysql]# ./bin/mysqld_safe --user=mysql & //启动MySQL，但不能停止
#mysqladmin -u root -p shutdown //此时root还没密码，所以为空值，提示输入密码时，直接回车即可。
#
#
#14.将mysql的启动服务添加到系统服务中
#
#
#
#复制代码代码如下:
#[root@zck mysql]# cp support-files/mysql.server /etc/init.d/mysql
#
#
#15.启动mysql
#
#
#
#复制代码代码如下:
#[root@zck mysql]# service mysql start
#Starting MySQL... ERROR! The server quit without updating PID file (/usr/local/mysql/data/localhost.localdomain.pid).
#
#
#启动失败：
#我这里是权限问题，先改变权限
#[root@zck mysql]# chown -R mysql:mysql /usr/local/mysql
#
#接着启动服务器
#[root@zck mysql]# /etc/init.d/mysql start
#
#16.修改MySQL的root用户的密码以及打开远程连接
#
#
#
#
#复制代码代码如下:
#[root@zck mysql]# mysql -u root mysql
#mysql> use mysql;
#mysql> desc user;
#mysql> GRANT ALL PRIVILEGES ON *.* TO root@"%" IDENTIFIED BY "root"; //为root添加远程连接的能力
#mysql> update user set Password = password('123456') where User='root'; //设置root用户密码
#mysql> select Host,User,Password from user where User='root';
#mysql> flush privileges;
#mysql> exit
#
#
#17.重新登录
#
#
#
#复制代码代码如下:
#[root@zck mysql]# mysql -u root -p
#Enter password:123456
#
#
#若还不能进行远程连接，关闭防火墙
#
#
#
#复制代码代码如下:
#[root@zck]# /etc/rc.d/init.d/iptables stop
#来源： <http://www.jb51.net/os/RedHat/73026.html>
#


#注意问题 my.cnf
#The above link says default-character-set is depreciated and you should
#be   using  character-set-server. It also states default-character-set
#was removed in v5.5.3.
#http://lists.mysql.com/mysql/226319

