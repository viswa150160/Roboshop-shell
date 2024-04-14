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

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "Copied mongodb repo into yum.repos.d"

yum install mongodb-org -y &>> $LOGFILE

VALIDATE $? "install mongodb"

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "enable mongod"

systemctl start mongod &>> $LOGFILE

VALIDATE $? "start mongod"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "Edit mongod.conf"

systemctl restart mongod &>> $LOGFILE

VALIDATE $? " restart mongod"




