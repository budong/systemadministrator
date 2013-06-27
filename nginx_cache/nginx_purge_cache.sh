#!/bin/bash

#Date: 2013-06-27
#Auther: budong

#######################################################
#说明：
#    1.本脚本用于清除nginx缓存文件
#    2.查看你的nginx是根据什么作为key来hash的，我的设置是 proxy_cache_key $uri$is_args$args;
#    因此nginx会根据$uri$is_args$args作为key进行hash，因此可以模拟nginx对一个key进行再
#    hash找到相应的文件路径，删除（具体可随意找个缓存文件 more 一下看看)
#    3.缓存设置 proxy_cache_path /data/mumayi/cache levels=1:2 keys_zone=cache_one:6000m inactive=15d max_size=200g;
#    根据相应的配置，请做相应修改测试
#    4.uri格式请按照同级目录下rm_apk_list.txt中填写
#####################################################

while read -r line
do
    md5uri=`echo -n $line | md5sum | awk '{ print $1 }'`
    filepath=`echo "$md5uri" | awk '{print "/data/mumayi/cache/"substr($0,length($0),1)"/"substr($0,length($0)-2,2)"/"$0}'`
    rm -rf $filepath
done < /root/sbin/rm_apk_list.txt
