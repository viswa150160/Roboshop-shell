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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>$LOGFILE

yum install nodejs -y &>>$LOGFILE

useradd roboshop &>>$LOGFILE

mkdir /app

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>>$LOGFILE

cd /app 

unzip /tmp/user.zip &>>$LOGFILE

VALIDATE $? "unzip is"

npm install &>>$LOGFILE

VALIDATE $? "npm install"

cp /home/centos/Roboshop-shell/user.service /etc/systemd/system/user.service &>>$LOGFILE

VALIDATE $? "copy the user.service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "daemon-reload"

systemctl enable user &>>$LOGFILE

VALIDATE $? "enable user"

systemctl start user &>>$LOGFILE

VALIDATE $? "start user"

cp /home/centos/Roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "copy mongo repo into remote"

yum install mongodb-org-shell -y &>>$LOGFILE

VALIDATE $? "install mongodb client"

mongo --host mongodb.devops2024.cloud </app/schema/user.js &>>$LOGFILE 

VALIDATE $? "load data into monogodb"