#!/bin/bash
yum update -y
yum install -y nginx
systemctl start nginx
systemctl enable nginx
echo "I am rishabh" > /usr/share/nginx/index.html