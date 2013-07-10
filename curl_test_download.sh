#!/bin/sh

success_count=0
failure_count=0
total_count=0
code=200

date_time=`date  +%Y-%m-%d`

for  ip in `cat /tmp/ip_list.txt`;do 
    for uri in `cat /tmp/url_list.txt`;do
        total_count=`expr $total_count + 1`
        b=`curl -I $uri -s -x $ip:80 | head -1 | gawk '{print$2}'`
        if [[ $b -ne $code ]];then
            time=`date +%Y-%m-%d:%H:%M`
            echo $time -- $ip -- $uri  >> /tmp/failure_$date_time.log
            curl -I $uri -s -x $ip:80 >> /tmp/failure_$date_time.log
            failure_count=`expr $failure_count + 1`
        else
            time=`date +%Y-%m-%d:%H:%M`
            echo $time -- $ip --  $uri  >> /tmp/success_$date_time.log
            curl -I $uri -s -x $ip:80 >> /tmp/success_$date_time.log
            success_count=`expr $success_count + 1`
        fi  
    done
done
echo "总测试次数" $total_count >>  /tmp/info_$date_time.log
echo "成功的次数" $success_count  >>  /tmp/info_$date_time.log
echo "失败的次数" $failure_count >>  /tmp/info_$date_time.log
