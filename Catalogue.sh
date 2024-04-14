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

VALIDATE $? "Stting up NPM source"

yum install nodejs -y &>>$LOGFILE

VALIDATE $? "install nodejs"

# if we run the below command 2nd time it will fail,
# first check the user is created or not
# if created then exit

useradd roboshop &>>$LOGFILE

# write a condtion direxist or not
mkdir /app &>>$LOGFILE

rm -rf /tmp/*

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip

cd /app &>>$LOGFILE
VALIDATE $? " move to app folder "

unzip /tmp/catalogue.zip &>>$LOGFILE

VALIDATE $? "unzip the catalog"

npm install &>>$LOGFILE

VALIDATE $? "install npm"

cp /home/centos/Roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>>$LOGFILE

VALIDATE $? "copy catalogue.service file"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "daemon-reload"

systemctl enable catalogue &>>$LOGFILE

VALIDATE $? "enable catalogue"

systemctl start catalogue &>>$LOGFILE

VALIDATE $? "start catalogue"

cp /home/centos/Roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "copy mongo.repo file"

yum install mongodb-org-shell -y  &>>$LOGFILE

VALIDATE $? "install mongo client"

mongo --host mongodb.devops2024.cloud </app/schema/catalogue.js &>>$LOGFILE

VALIDATE $? "loading catalog data into mongodb"


