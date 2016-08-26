#!/bin/sh

now=`date "+%Y-%m-%d %H:%M:%S.%N"`
pid=`ps aux | grep supervisord | grep -v grep | awk '{print $2}'`

if [ "$pid" = "" ]
then
    echo $now
    echo 'supervisord is stopped'
    /usr/bin/python /usr/bin/supervisord -c /etc/supervisord.conf &
else
    echo $now
    echo 'supervisord is running'
fi 
