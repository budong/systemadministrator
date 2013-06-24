文档地址：http://subversion.apache.org/

一：下载subversion
wget http://subversion.tigris.org/downloads/subversion-1.6.1.tar.gz
wget http://subversion.tigris.org/downloads/subversion-deps-1.6.1.tar.gz
二：安装subversion
tar zxvf subversion-1.6.1.tar.gz
tar zxvf subversion-deps-1.6.1.tar.gz
cd subversion-1.6.1
./configure --prefix=/usr/local/svn
make && make install
三：将svn的bin加入到环境变量中去
vim /etc/profile
PATH=$PATH:/usr/local/svn/bin
四：建立仓库，配置svn
A:
mkdir -p /data/svn
svnadmin create /data/svn/repos
cd /data/svn/repos/conf/
B:
svnserve.conf
[general]
anon-access = none
auth-access = write
password-db = passwd
realm = repos
[sasl]

authz
[aliases]
[groups]
repos=budong
[/]
@repos = rw
* = r 

passwd 
[users]
budong = budong
五：设置开机启动svn
vim /etc/rc.local
svnserve -d -r /data/svn/
六：客户端的访问
svn checkout svn://ip/repos

五：svn钩子（仓库的代码直接同步到网站根目录）
cat /data/svndata/php/hooks/post-commit

#!/bin/sh
SVN=/usr/bin/svn
WEB=/data/html
export LANG=en_US.UTF-8
$SVN update $WEB --username budong --password 16yOeEb0

