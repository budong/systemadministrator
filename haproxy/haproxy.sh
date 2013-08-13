cat /var/log/messages | awk '{print $6}' | awk -F ':' '{print $1}' | sort | uniq -c | sort -rn | head -50
cat /var/log/messages | awk '{print $9}' | sort | uniq -c | sort -rn
