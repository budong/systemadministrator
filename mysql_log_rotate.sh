#!/bin/sh

#crontab
#02 02 * * * sh /root/sbin/mysql_log_rotate.sh

DIR_BASE="/data/mysql_db"
DIR_LOG="${DIR_BASE}/rotate"
DIR_DATE=$(date +%Y/%m/%d)
LAST_MONTH=`date -d last-month +'%Y/%m/%d'`

#clear error_log and slow_log every month
/bin/mkdir -p ${DIR_LOG}/${DIR_DATE} > /dev/null 2>&1
/bin/mv ${DIR_BASE}/error.log ${DIR_LOG}/${DIR_DATE}/
/bin/touch  ${DIR_BASE}/error.log
/bin/mv ${DIR_BASE}/slow.log ${DIR_LOG}/${DIR_DATE}/
/bin/touch  ${DIR_BASE}/slow.log

rm -rf ${DIR_LOG}/${LAST_MONTH}/
