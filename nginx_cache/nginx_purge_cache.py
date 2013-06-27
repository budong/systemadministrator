#!/usr/local/python2.7/bin/python2.7
# -*- coding:utf8 -*-

#Date: 2013-06-26
#Name: budong

'''
说明：
    1.本脚本用于清除nginx缓存文件
    2.查看你的nginx是根据什么作为key来hash的，我的设置是 proxy_cache_key $uri$is_args$args;
    因此nginx会根据$uri$is_args$args作为key进行hash，因此可以模拟nginx对一个key进行再
    hash找到相应的文件路径，删除（具体可随意找个缓存文件 more 一下看看)
    3.缓存设置 proxy_cache_path /data/mumayi/cache levels=1:2 keys_zone=cache_one:6000m inactive=15d max_size=200g;
    根据相应的配置，请做相应修改测试
    4.uri格式请按照同级目录下rm_apk_list.txt中填写
'''
import os
import sys
try:
    from hashlib import md5
except:
    from md5 import md5

reload( sys )
sys.setdefaultencoding('utf-8')

PROJECT_ROOT = os.path.dirname(os.path.abspath(__file__))
URI_FILE = ''.join([PROJECT_ROOT,'/rm_apk_list.txt'])

def nginx_purge(uri):
    m = md5()
    m.update("%s" % uri)
    md5uri=m.hexdigest()
    md5uri_len=len(md5uri)
    dir1=md5uri[md5uri_len-1:]
    dir2=md5uri[md5uri_len-3:md5uri_len-1]
    file_path=("/data/mumayi/cache/%s/%s/%s" % (dir1, dir2, md5uri))
    if os.path.exists(file_path):
        os.remove(file_path)

with open("%s" % URI_FILE,'r') as uri_file:
    for line in uri_file:
        line = line.rstrip()
        nginx_purge(line)

