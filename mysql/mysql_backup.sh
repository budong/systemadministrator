#!/bin/bash
BackupPath=/disk2/databk
Mysql_bk_dir=$BackupPath/mysql_bk_dir
LogFile=$BackupPath/backuplog
Passwd=budong

source /etc/profile

for i in  $(mysql -p"$Passwd" -e "show databases\G"|grep Database |awk '{print $2}')
do

#########################################################################
# define mysql variables                                                #
#########################################################################
NewFile="$Mysql_bk_dir"/$i$(date +%Y%m%d).tgz 
DumpFile="$Mysql_bk_dir"/$i$(date +%Y%m%d).sql
#OldFile="$Mysql_bk_dir"/$i$(date -v -5d +%Y%m%d).tgz #freebsd
OldFile="$Mysql_bk_dir"/$i$(date +%Y%m%d --date='10 days ago').tgz 


#########################################################################
#   mysql backup proccess                                               #
#########################################################################
echo "-------------------------------------------" >> $LogFile 
echo $(date +"%y-%m-%d %H:%M:%S") >> $LogFile 
echo "--------------------------" >> $LogFile 

#Delete Old File 
if [ -f $OldFile ] 
then 
   rm -f $OldFile >> $LogFile 2>&1 
   echo "[$OldFile]Delete Old File Success!" >> $LogFile 
else 
   echo "[$OldFile]No Old Backup File!" >> $LogFile 
fi 

if [ -f $NewFile ] 
then 
   echo "[$NewFile]The Backup File is exists,Can't Backup!" >> $LogFile 
else 
    cd $Mysql_bk_dir
    /usr/local/mysql/bin/mysqldump  --single-transaction  $i -p"$Passwd"  > $DumpFile 
    tar czf $NewFile $i$(date +%Y%m%d).sql >> $LogFile 2>&1 
    echo "[$NewFile]Backup Success!" >> $LogFile 
    rm -rf $DumpFile 
fi 
done
