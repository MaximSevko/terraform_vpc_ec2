#!/bin/bash


## Mount the mysql-server directory
sudo yum install xfsprogs -y     
#sudo mkdir /home/ec2-user/mysql-server     
#sudo mkfs -t xfs /dev/nvme1n1     
#echo $(blkid | grep /dev/nvme1n1 | awk '{print $2}') /home/ec2-user/mysql-server xfs defaults 1 1 >> /etc/fstab     
#sudo mount -a     
#
## Install and configure MySQL
#sudo yum update -y     
#sudo yum install https://dev.mysql.com/get/mysql80-community-release-el7-5.noarch.rpm -y     
#sudo yum install mysql-community-server -y     
#
#sudo yum install -y mysql-server     
#sudo systemctl enable mysqld     
#sudo systemctl start mysqld     
#

# Install and configure Nginx
sudo yum install -y nginx     
sudo systemctl enable nginx     
sudo systemctl start nginx     

sudo chown -R ec2-user:ec2-user /usr/share/nginx/html/     
sudo echo "Welcome to my website!" > /usr/share/nginx/html/index.html     

# Install Certbot and obtain SSL certificate
sudo python3 -m venv /opt/certbot/
sudo /opt/certbot/bin/pip install --upgrade pip
sudo /opt/certbot/bin/pip install certbot certbot-nginx


# Configure Nginx to serve WordPress
sudo mkdir /etc/nginx/sites-available     
sudo mkdir /etc/nginx/sites-enabled      
sudo touch /etc/nginx/sites-available/mywebsite.dev.qkdev.net     
sudo ln -s /etc/nginx/sites-available/mywebsite.dev.qkdev.net /etc/nginx/sites-enabled/mywebsite.dev.qkdev.net     
sudo echo "server {
    listen 80;
    listen [::]:80;
    server_name mywebsite.dev.qkdev.net;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name mywebsite.dev.qkdev.net;

    # SSL Certificate
    ssl_certificate /etc/letsencrypt/live/mywebsite.dev.qkdev.net/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/mywebsite.dev.qkdev.net/privkey.pem;
    ssl_trusted_certificate /etc/letsencrypt/live/mywebsite.dev.qkdev.net/chain.pem;

    # SSL Settings
    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:50m;
    ssl_session_tickets off;
    ssl_protocols TLSv1.2;
    ssl_prefer_server_ciphers off;
    ssl_ciphers ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256;
    ssl_stapling on;
    ssl_stapling_verify on;
    resolver 8.8.8.8 8.8.4.4 valid=300s;
    resolver_timeout 5s;

    # Root directory of website
    root /var/www/mywebsite.dev.qkdev.net;

    # Index page
    index index.html index.htm;

    # Location of Certbot's validation file
    location ~ /.well-known/acme-challenge {
        allow all;
        root /var/www/mywebsite.dev.qkdev.net;
    }

    # Other location rules
    location / {
        # Your other location rules go here
    }
}
" | sudo tee /etc/nginx/nginx.conf



# Restart Nginx to apply changes
sudo nginx -t
sudo systemctl restart nginx

## Configure MySQL to use the mounted disk
#sudo systemctl stop mysqld     
#sudo mkdir /mnt/mysql-data     
#sudo mv /var/lib/mysql/* /mnt/mysql-data/     
#sudo echo "datadir=/mnt/mysql-data" | sudo tee -a /etc/my.cnf     
#sudo systemctl start mysqld     
#