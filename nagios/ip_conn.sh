#if [ $# -ne 2 ]
#then
#  echo "Usage:$0 -w num1 -c num2"
#exit 3
#fi

ip_conns=`netstat -an | grep tcp | grep EST | wc -l`

 if [ $ip_conns -lt $1 ]
   then
   echo "OK -connect counts is $ip_conns"
   exit 0
 fi

 if [ $ip_conns -gt $1 -a $ip_conns -lt $2 ]
   then
   echo "Warning -connect counts is $ip_conns"
   exit 1
 fi

 if [ $ip_conns -gt $2 ]
   then
   echo "Critical  -connect counts is $ip_conns"
   exit 2
 fi
