软件下载地址：
    http://www.keepalived.org/software/
    http://www.linuxvirtualserver.org/software/ipvs.html


原文地址：http://budongzhenren.blog.51cto.com/2288320/893270

Centos下使用LVS+Keepalived构建高可用linux集群
环境：Centos 5.5
 
前端调度器Director使用主备模式，主的宕机了，备的接手任务
前端调度器1：LVS-master 192.168.220.5
前端调度器2：LVS-backup 192.168.220.6
 
 
后端服务器池：web1:192.168.220.11
              web2:192.168.220.12
               
               
              虚拟VIP：192.168.220.220
               
               
              一：在LVS-master和 LVS-backup上面分别安装ipvsadm和keepalived
              A：安装ipvsadm
              1,先要做一个连接文件： ln -s /usr/src/kernels/2.6.18-308.8.1.el5-i686/ /usr/src/linux/
              注意：如果ll /usr/src/kernels/ 目录下没东西，则 yum -y install kernel-devel解决
              有关编译错误可看官方wiki文档：http://kb.linuxvirtualserver.org/wiki/Compiling_ipvsadm_on_different_Linux_distributions#Compiling_Error_Analysis
               
              2，[root@master ~]# ll
              total 332
              -rw------- 1 root root 876 Jun 2 14:26 anaconda-ks.cfg
              -rw-r--r-- 1 root root 18262 Jun 2 14:26 install.log
              -rw-r--r-- 1 root root 3969 Jun 2 14:25 install.log.syslog
              -rw-r--r-- 1 root root 36598 Jun 7 2012 ipvsadm-1.24.tar.gz
              -rw-r--r-- 1 root root 241437 Jun 7 2012 keepalived-1.1.19.tar.gz
              [root@master ~]#tar zxvf ipvsadm-1.24.tar.gz
              [root@master ~]# cd ipvsadm-1.24
              [root@master ipvsadm-1.24]#make;make install
               
               
               

              B:安装keepalived
               
               
              ，[root@master ~]# ll
              total 332
              -rw------- 1 root root 876 Jun 2 14:26 anaconda-ks.cfg
              -rw-r--r-- 1 root root 18262 Jun 2 14:26 install.log
              -rw-r--r-- 1 root root 3969 Jun 2 14:25 install.log.syslog
              -rw-r--r-- 1 root root 36598 Jun 7 2012 ipvsadm-1.24.tar.gz
              -rw-r--r-- 1 root root 241437 Jun 7 2012 keepalived-1.1.19.tar.gz
              [root@master ~]#tar zxvf keepalived-1.1.19.tar.gz
              [root@master ~]# cd keepalived-1.1.19
               
               
               
              [root@master ipvsadm-1.24]#./configure --prefix=/usr/local/keepalived
              [root@master ipvsadm-1.24]#make;make install

              C:LVS-master上的配置脚本为,vim /usr/local/keepalived/etc/keepalived/keepalived.conf
               
               
              ! Configuration File for keepalived
              #全局定义部分
              global_defs {
              notification_email {
              acassen@firewall.loc #设置邮件报警地址，可以设置多个，每行一个
              failover@firewall.loc
              sysadmin@firewall.loc
          }
          notification_email_from
          Alexandre.Cassen@firewall.loc
           
          #设置邮件的发送地址
          smtp_server 127.0.0.1 #设置smtp server地址
          smtp_connect_timeout 30 #设置连接smtp server的超时时间
          router_id LVS_DEVEL #表示运行keepalived服务器的一个标示，发邮件时显示在邮件主题中的信息
      }
      #vrrp实例定义部分
      vrrp_instance VI_1 {
      state MASTER #指定keepalived的角色
      interface eth0 #指定HA检测网络的端口
      virtual_router_id 51 #虚拟路由表示，这个表示是一个数字，同一个vrrp实例使用唯一的标示
      priority 100 #定义优先级，数字越大，优先级越大，在同一个vrrp_instance下，MASTER的优先级必须高于BACKUP
      advert_int 1 #设定MASTER和BACKUP负载均衡器之间的同步检查的时间间隔，单位是秒
      authentication {
       
       
       
      auth_type PASS #设定验证类型，主要有PASS和AH两种
      auth_pass 1111 #设置密码，在同一个vrrp_instance下，MASTER和BACKUP必须使用相同的密码才能正常通信
  }
  virtual_ipaddress { #设置虚拟IP地址，可以为多个虚拟IP地址，每行一个
  192.168.220.220
  }
  }
  #虚拟服务器定义部分
  virtual_server 192.168.220.220 80 { #设置虚拟服务器，需要指定虚拟IP地址和服务器端口，IP与端口之间用空格隔开
  delay_loop 6 #设置运行情况检查时间，单位是秒
  lb_algo rr #设置负载调度算法，这里是rr,即轮询算法
  lb_kind DR #设置LVS 实现负载均衡的调度机制，有NAT 、TUN和DR三个模式 
  persistence_timeout 1 #会话保持时间，单位是秒
  protocol TCP #指定转发协议的类型


  real_server 192.168.220.12 80 { #配置web2
  weight 100 #服务节点的权值
  TCP_CHECK { #realserver的状态检测部分，单位是秒
  connect_timeout 3 #表示三秒无响应超时
  nb_get_retry 3 #表示重试次数
  delay_before_retry 3 #表示重试间隔
  connect_port 80 #连接的端口
  }
  }

  real_server 192.168.220.11 80 { #配置web1
  weight 100
  TCP_CHECK {
  connect_timeout 3
  nb_get_retry 3
  delay_before_retry 3
  connect_port 80
  }
  }

  }

  D:C:LVS-backup上的配置脚本为,vim /usr/local/keepalived/etc/keepalived/keepalived.conf 红色部分为和LVS-master的区别

  ! Configuration File for keepalived

  global_defs {
  notification_email {
  acassen@firewall.loc
  failover@firewall.loc
  sysadmin@firewall.loc
  }
  notification_email_from Alexandre.Cassen@firewall.loc
  smtp_server 192.168.200.1
  smtp_connect_timeout 30
  router_id LVS_DEVEL
  }

  vrrp_instance VI_1 {
  state BACKUP
  interface eth0
  virtual_router_id 51
  priority 80
  advert_int 1
  authentication {
  auth_type PASS
  auth_pass 1111
  }
  virtual_ipaddress {
  192.168.220.220
  }
  }

  virtual_server 192.168.220.220 80 {
  delay_loop 6
  lb_algo rr
  lb_kind DR
  persistence_timeout 1
  protocol TCP


  real_server 192.168.220.12 80 {
  weight 100
  TCP_CHECK {
  connect_timeout 3
  nb_get_retry 3
  delay_before_retry 3
  connect_port 80
  }
  }

  real_server 192.168.220.11 80 {
  weight 100
  TCP_CHECK {
  connect_timeout 3
  nb_get_retry 3
  delay_before_retry 3
  connect_port 80
  }
  }
  }
   
   

  二：在后端服务器池realserver上的设置;
   
  A：
  web1:192.168.220.11
  新建脚本vim /root/lvs-realserver.sh如下：
  #!/bin/bash
  #description :Start Real Server
  VIP=192.168.220.220
  /etc/rc.d/init.d/functions
  case "$1" in
      start)
      echo "Start LVS of Real Server"
      /sbin/ifconfig lo:0 $VIP broadcast $VIP netmask 255.255.255.255 up
      echo "1" > /proc/sys/net/ipv4/conf/lo/arp_ignore
      echo "2" > /proc/sys/net/ipv4/conf/lo/arp_announce
      echo "1" > /proc/sys/net/ipv4/conf/all/arp_ignore
      echo "2" > /proc/sys/net/ipv4/conf/all/arp_announce
      ;;
      stop)
      /sbin/ifconfig lo:0 down
      echo "close LVS Director server"
      echo "0" > /proc/sys/net/ipv4/conf/lo/arp_ignore
      echo "0" > /proc/sys/net/ipv4/conf/lo/arp_announce
      echo "0" > /proc/sys/net/ipv4/conf/all/arp_ignore
      echo "0" > /proc/sys/net/ipv4/conf/all/arp_announce
      ;;
      *)
      echo "Usage: $0 {start|stop}"
      exit 1
  esac
  B:
   
  web2:192.168.220.12
  新建脚本vim /root/lvs-realserver.sh如下：
  #!/bin/bash
  #description :Start Real Server
  VIP=192.168.220.220
  /etc/rc.d/init.d/functions
  case "$1" in
      start)
      echo "Start LVS of Real Server"
      /sbin/ifconfig lo:0 $VIP broadcast $VIP netmask 255.255.255.255 up
      echo "1" > /proc/sys/net/ipv4/conf/lo/arp_ignore
      echo "2" > /proc/sys/net/ipv4/conf/lo/arp_announce
      echo "1" > /proc/sys/net/ipv4/conf/all/arp_ignore
      echo "2" > /proc/sys/net/ipv4/conf/all/arp_announce
      ;;
      stop)
      /sbin/ifconfig lo:0 down
      echo "close LVS Director server"
      echo "0" > /proc/sys/net/ipv4/conf/lo/arp_ignore
      echo "0" > /proc/sys/net/ipv4/conf/lo/arp_announce
      echo "0" > /proc/sys/net/ipv4/conf/all/arp_ignore
      echo "0" > /proc/sys/net/ipv4/conf/all/arp_announce
      ;;
      *)
      echo "Usage: $0 {start|stop}"
      exit 1
  esac
   
   
   
  三：开启服务并测试；
  A:在LVS-master和LVS-backup 上分别 [root@master ]# /usr/local/keepalive/sbin/keepalived -f /usr/local/keepalive/etc/keepalived/keepalived.conf 启动keepalived
   
   
  B:在后端服务器池web1和web2上分别 执行/root/lvs-realserver.sh start
   
   
  C:进行测试，看看效果怎么样，我的测试成功...


原文地址:http://blog.sina.com.cn/s/blog_6c2e6f1f01017w6i.html
######keepalived健康检查 HTTP_GET######
一：
real_server 192.168.2.188 80 {
     weight 1
     HTTP_GET {
       url {
       path /index.html
       digest bfaa334fdd71444e45eca3b7a1679a4a  #http://192.168.2.188/index.html的digest值          }
            connect_timeout 3
            nb_get_retry 3
            delay_before_retry 3
        }
digest值的获取方法：
[root@188-test html]# genhash -s 192.168.2.188 -p 80 -u /index.html
MD5SUM = bfaa334fdd71444e45eca3b7a1679a4a
genhash命令：
[root@188-test html]# genhash
genhash v1.0.0 (18/11, 2002)
Usage:
  genhash -s server-address -p port -u url
  genhash -S -s server-address -p port -u url
  genhash -h
  genhash -r

Commands:
Either long or short options are allowed.
  genhash --use-ssl         -S       Use SSL connection to remote server.
  genhash --server          -s       Use the specified remote server address.
  genhash --port            -p       Use the specified remote server port.
  genhash --url             -u       Use the specified remote server url.
  genhash --use-virtualhost -V       Use the specified virtualhost in GET query.
  genhash --verbose         -v       Use verbose mode output.
  genhash --help            -h       Display this short inlined help screen.
  genhash --release         -r       Display the release number


二：
real_server 192.168.2.188 80 {
      weight 1
      HTTP_GET {
          url {
          path /index.html
          status_code 200      #http://192.168.2.188/index.html的返回状态码
            }
            connect_timeout 3
            nb_get_retry 3
            delay_before_retry 3
        }



