#!/usr/bin/env bash

function human_readable_time () {

########################################################################
#                                                                      #
#       Function to produce human readable time                        #
#                                                                      #
########################################################################

        usage="$0 seconds 'variable'"
        if [ -z $1 ] || [ -z $2 ] ; then
                cecho $usage $red
                exit 1
        fi
        days=$(echo "scale=0 ; $1 / 86400" | bc -l)
        remainder=$(echo "scale=0 ; $1 % 86400" | bc -l)
        hours=$(echo "scale=0 ; $remainder / 3600" | bc -l)
        remainder=$(echo "scale=0 ; $remainder % 3600" | bc -l)
        minutes=$(echo "scale=0 ; $remainder / 60" | bc -l)
        seconds=$(echo "scale=0 ; $remainder % 60" | bc -l)
        export $2="$days days $hours hrs $minutes min $seconds sec"
}


function slave_status () {
	local variable=`mysql -e "show slave status\G" | grep $1 | awk '{ print $2 }'`
        export "$2"=$variable
}

slave_status Seconds_Behind_Master seconds_behind_master

# echo -e $seconds_behind_master

if [ "$seconds_behind_master" = 'NULL' ] || [ "$seconds_behind_master" = '' ] ; then
	echo "Unknown Offset - perhaps slave is stopped or not configured"
	exit 1
fi

human_readable_time $seconds_behind_master seconds_behind_masterHR

echo $seconds_behind_masterHR
