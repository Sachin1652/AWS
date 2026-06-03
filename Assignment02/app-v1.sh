#!/bin/bash
apt update -y
apt install nginx awscli unzip -y

rm -f /var/www/html/index.nginx*

aws s3 cp s3://sachin-rolling-artifacts/app-v1.zip /tmp/app.zip

unzip /tmp/app.zip -d /var/www/html/

cp /var/www/html/app-v1/index.html /var/www/html/index.html

rm -rf /tmp/app.zip
rm -rf /var/www/html/app-v1

systemctl restart nginx
