#!/bin/bash

# Mount the mysql-server directory
sudo mkdir -p ~/mysql-server
sudo mount /dev/sdb ~/mysql-server

# Install and configure MySQL
sudo yum update -y
sudo yum install -y mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo mysql_secure_installation <<EOF

y
password
password
y
y
y
y
EOF

# Install and configure Nginx
sudo amazon-linux-extras install -y nginx1.12
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl stop nginx

# Configure Nginx for the domain
sudo mkdir -p /var/www/example.com/html
sudo chown -R $USER:$USER /var/www/example.com/html
sudo chmod -R 755 /var/www/example.com
sudo tee /etc/nginx/conf.d/example.com.conf > /dev/null <<EOT
server {
    listen 80;
    server_name example.com www.example.com;
    root /var/www/example.com/html;
    index index.html index.htm;
    location / {
        try_files $uri $uri/ =404;
    }
}
EOT

# Start Nginx and install Certbot
sudo systemctl start nginx
sudo systemctl enable nginx
sudo amazon-linux-extras install -y epel
sudo yum install -y certbot python2-certbot-nginx

# Obtain and install the SSL certificate from Let's Encrypt
sudo certbot --nginx -d example.com -d www.example.com <<EOF
email@example.com
A
EOF

# Add disk to /var/www
sudo mkdir -p /var/www/wordpress
sudo chown -R $USER:$USER /var/www/wordpress
sudo chmod -R 755 /var/www/wordpress
sudo mount /dev/sdc /var/www/wordpress

# Download and extract the latest version of WordPress
cd /tmp
curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
sudo cp -a /tmp/wordpress/. /var/www/wordpress
sudo chown -R $USER:$USER /var/www/wordpress
sudo chmod -R 755 /var/www/wordpress

# Configure WordPress
cd /var/www/wordpress
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/wordpress/g" wp-config.php
sed -i "s/username_here/wpuser/g" wp-config.php
sed -i "s/password_here/password/g" wp-config.php

# Reload Nginx to apply changes
sudo systemctl reload nginx
