#!/bin/sh
DATE1=$(date "+%Y/%m/%d" -d "-45 minutes")
DATE2=$(date "+%Y/%m/%d" -d "-5 minutes")
MONTH=$(date "+%Y/%m")
HOUR=$(date "+%H")

DIR_SRC=""
DIR_DST=""
FILE_LIST=""
HOUR=$(date "+%H")

if [ ${HOUR} -eq "00" ]; then
        /usr/bin/rsync  -avzP $DIR_SRC $DIR_DST
else
        /usr/bin/rsync -avzP  --files-from=$FILE_LIST $DIR_SRC $DIR_DST
fi

查看一个文件夹做大的文件
ls -S|head -1

统计nginx下载软件的前十
cat apk.a.log | awk '{print $7}' | sort | uniq -c | sort -rn | head -10
