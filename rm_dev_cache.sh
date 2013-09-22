#!/bin/bash
DIR_BASE='/data/html/dev_mumayi/data/tmp/'
DATE=$(date -d '-1 month'  +/%Y/%m/)

for i in `/bin/ls $DIR_BASE`
do
    if [ -d $DIR_BASE$i$DATE ];then
        /bin/rm -rf $DIR_BASE$i$DATE
    fi
done
