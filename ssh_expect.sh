#!/usr/bin/expect -f  
#http://blog.51yip.com/linux/1462.html
set ip "yourip"  
set password "yourpassword"
set timeout 10  
spawn ssh -p 2222 root@$ip  
expect {  
"*yes/no" { send "yes\r"; exp_continue}  
"*password:" { send "$password\r" }  
}  
interact  
