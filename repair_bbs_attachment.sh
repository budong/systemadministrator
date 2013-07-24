#!/bin/sh

HOSTNAME="localhost"
PORT="3306"
USERNAME="root"
PASSWORD="budong"
DBNAME="bbs_budong"

for i in `seq 1 14`;do
/usr/local/mysql/bin/mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD} ${DBNAME} <<EOF
    update pre_forum_post_$i as A,( SELECT pid  FROM pre_forum_post_$i \
WHERE (message LIKE '%[/img]%' or   message LIKE '%[attach]%' or message LIKE '%[attachimg]%') and attachment=0 ) \
as B   set A.attachment=1  where  A.pid = B.pid;
EOF
done
