#!/bin/bash
STATUS=`ps -C haproxy --no-header |wc -l`

if [ "$STATUS" -eq "0" ]; then
  /usr/local/haproxy/sbin/haproxy -f /usr/local/haproxy/etc/haproxy.cfg
  STATUS2=`ps -C haproxy --no-header|wc -l`
        if [ "$STATUS2" -eq "0"  ]; then
        kill -9 $(ps -ef | grep keepalived | grep -v grep | awk '{print $2}')
        fi
fi
