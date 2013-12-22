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

删除apk软件
vim rm_apk.sh
#!/bin/sh

#file=$1
while read -r line
do
    #echo $line
    rm -rf $line
done < /root/sbin/soft_bak
#done < $file

vim soft_bak
/data/mumayi/soft/2013/03/14/29/292928/linghuntanceqi_V1.3.0_mumayi_8c2f0.apk
/data/mumayi/soft/2013/03/08/29/290117/zhongguotushuguan_V3.1_mumayi_80a5a.apk

nginxpid=`ps -C nginx --no-header | wc -l`
