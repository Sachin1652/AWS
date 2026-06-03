#!/bin/bash
apt update
apt install nginx awscli unzip -y

sudo rm -rf /var/www/html/*
aws s3 cp s3://sachin-blue-green-artifacts/green-app.zip /tmp/green.zip
unzip /tmp/green.zip -d /var/www/html/
mv /var/www/html/green-app/index.html /var/www/html/index.html
sudo rm -rf /var/www/html/green-app
systemctl restart nginx