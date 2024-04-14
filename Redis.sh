#!/bin/bash
DATE=$(date +%F)
LOGDIR=/tmp
SCRIPT_NAME=$0
LOGFILE=$LOGDIR/$0_$DATE.Log
USERID=$( id -u )
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"
# Checking here whether user has ROOT access or NOT
if [ $USERID -ne 0 ];
    then 
        echo -e "$R ERROR:: please run the script with root access $N"
        exist 1
fi

VALIDATE() {
   if [ $1 -ne 0 ];
      then 
         echo -e "$2...$R FAILURE $N"
         exit 1
    else
         echo -e "$2...$G SUCCESS $N"
   fi 
}

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOGFILE

VALIDATE $? "install redis repo"

yum module enable redis:remi-6.2 -y &>>$LOGFILE

VALIDATE $? "enable redis:remi-6.2"

yum install redis -y &>>$LOGFILE

VALIDATE $? "nstall redis-6.2"

sed -i 's/127.0.0.1/0.0.0.0/g'  /etc/redis.conf /etc/redis/redis.conf &>>$LOGFILE

VALIDATE $? "Allowing the remote connection to Redis"

systemctl enable redis &>>$LOGFILE

VALIDATE $? "enable redis"

systemctl start redis &>>$LOGFILE

VALIDATE $? "start redis"