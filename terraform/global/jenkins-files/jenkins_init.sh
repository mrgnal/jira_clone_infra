#!/bin/bash

set -e

apt update -y
apt install -y curl nginx default-jdk openssl

#Install jenkins
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt -y update
sudo apt install -y jenkins

#Create SSL certificate
mkdir -p /etc/nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/jenkins.key \
  -out /etc/nginx/ssl/jenkins.crt \
  -subj "/C=UA/ST=Kyiv/L=Kyiv/O=DevOps/CN=jenkins.local"

#NGINX config
cat <<EOF > /etc/nginx/sites-available/jenkins
server {
    listen 443 ssl;
    server_name jenkins.local;
    access_log  /var/log/nginx/jenkins.access.log;
   error_log   /var/log/nginx/jenkins.error.log;

    ssl_certificate /etc/nginx/ssl/jenkins.crt;
    ssl_certificate_key /etc/nginx/ssl/jenkins.key;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_redirect http://localhost:8080 https://$host/;
   }
}
EOF

#Start nginx
ln -s /etc/nginx/sites-available/jenkins /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
systemctl restart nginx