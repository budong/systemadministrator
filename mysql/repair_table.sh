#!/bin/bash
HOST='localhost'
USER='root'
PASSWORD='password'
DATABASE='yunbbs'

tables=$(mysql -h$HOST -u$USER -p$PASSWORD $DATABASE -A -Bse "show tables")
for table in $tables
do
    check_status=$(mysql -h$HOST -u$USER -p$PASSWORD $DATABASE -A -Bse "check table $table" | awk '{print $4}')
    if [ "$check_status" == "OK" ]
    then
        echo "$table is ok"
    else
        echo $(mysql -h$HOST -u$USER -p$PASSWORD $DATABASE -A -Bse "repair table $table")
    fi
    echo $(mysql -h$HOST -u$USER -p$PASSWORD $DATABASE -A -Bse "optimize table $table")
done
