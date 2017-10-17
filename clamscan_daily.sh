#!/bin/bash
LOGFILE="/var/log/clamav/clamav-$(date +'%Y-%m-%d').log";
EMAIL_MSG="Clamscan log from $HOSTNAME";
EMAIL_FROM="clamav-daily@fairsquare.com";
EMAIL_TO="minu.ajith@fairsquare.com";
DIRTOSCAN="/";

for S in ${DIRTOSCAN}; do
 DIRSIZE=$(du -sh "$S" 2>/dev/null | cut -f1);

 echo "Starting a daily scan of "$S" directory.
 Amount of data to be scanned is "$DIRSIZE".";

 clamscan -ri --exclude-dir=^/sys --exclude-dir=^/dev --exclude-dir=^/proc "$S" >> "$LOGFILE";

 # get the value of "Infected lines"
 MALWARE=$(tail "$LOGFILE"|grep Infected|cut -d" " -f3);

 # if the value is not equal to zero, send an email with the log file attached
 if [ "$MALWARE" -ne "0" ];then
 # using heirloom-mailx below
 echo "$EMAIL_MSG"|mail -a "$LOGFILE" -s "Malware Found" "$EMAIL_TO";
 fi 
done

exit 0
