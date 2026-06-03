#!/bin/bash
apt update
apt install nginx awscli unzip -y

sudo rm -rf /var/www/html/*
aws s3 cp s3://sachin-blue-green-artifacts/blue-app.zip /tmp/blue.zip
unzip /tmp/blue.zip -d /var/www/html/
mv /var/www/html/blue-app/index.html /var/www/html/index.html
sudo rm -rf /var/www/html/blue-app
systemctl restart nginx