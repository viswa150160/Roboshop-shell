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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE

VALIDATE $? "downlod"

yum install nodejs -y &>>$LOGFILE

VALIDATE $? "install nodejs"

useradd roboshop &>>$LOGFILE

VALIDATE $? "useradd roboshop"

mkdir /app &>>$LOGFILE

VALIDATE $? "mkdir"

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>>$LOGFILE

unzip /tmp/cart.zip &>>$LOGFILE

VALIDATE $? "unzip"

npm install &>>$LOGFILE

VALIDATE $? "donpm installwnlod"

cp /home/centos/Roboshop-shell/cart.service /etc/systemd/system/cart.service &>>$LOGFILE

VALIDATE $? "copy cart.service file into remote"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "daemon-reload"

systemctl enable cart &>>$LOGFILE

VALIDATE $? "enable cart"

systemctl start cart &>>$LOGFILE

VALIDATE $? "start cart"