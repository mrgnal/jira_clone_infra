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
upstream jenkins {
  keepalive 32; # keepalive connections
  server 127.0.0.1:8080; # jenkins ip and port
}

map $http_upgrade $connection_upgrade {
  default upgrade;
  '' close;
}

server {
  listen          443 ssl;       
  server_name     jenkins.clonejira.pp.ua;  

  root            /var/run/jenkins/war/;

  access_log      /var/log/nginx/jenkins.access.log;
  error_log       /var/log/nginx/jenkins.error.log;
  ssl_certificate /etc/nginx/ssl/jenkins.crt;
  ssl_certificate_key /etc/nginx/ssl/jenkins.key;

  # pass through headers from Jenkins that Nginx considers invalid
  ignore_invalid_headers off;

  location ~ "^\/static\/[0-9a-fA-F]{8}\/(.*)$" {
    rewrite "^\/static\/[0-9a-fA-F]{8}\/(.*)" /$1 last;
  }

  location /userContent {
    root /var/lib/jenkins/;
    if (!-f $request_filename){
      rewrite (.*) /$1 last;
      break;
    }
    sendfile on;
  }

  location / {
      sendfile off;
      proxy_pass         http://jenkins;
      proxy_redirect     default;
      proxy_http_version 1.1;

      # Required for Jenkins websocket agents
      proxy_set_header   Connection        $connection_upgrade;
      proxy_set_header   Upgrade           $http_upgrade;

      proxy_set_header   Host              $http_host;
      proxy_set_header   X-Real-IP         $remote_addr;
      proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
      proxy_set_header   X-Forwarded-Proto $scheme;
      proxy_max_temp_file_size 0;

      #this is the maximum upload size
      client_max_body_size       10m;
      client_body_buffer_size    128k;

      proxy_connect_timeout      90;
      proxy_send_timeout         90;
      proxy_read_timeout         90;
      proxy_request_buffering    off; 
  }
}
EOF

#Start nginx
ln -s /etc/nginx/sites-available/jenkins /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
systemctl restart nginx