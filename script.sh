#!/bin/bash

# Mount the mysql-server directory
sudo mkdir -p ~/mysql-server
sudo mkfs -t xfs /dev/nvme1n1
sudo mount /dev/sdb ~/mysql-server
echo $(blkid | grep /dev/nvme1n1 | awk '{print $2}') /home/ec2-user/mysql xfs defaults 1 1 >> /etc/fstab
sudo mount -a

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







# Install and configure Nginx
sudo yum install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
sudo chown -R ec2-user:ec2-user /usr/share/nginx/html/
sudo echo "Welcome to my website!" > /usr/share/nginx/html/index.html

# Configure Nginx to serve WordPress
sudo mkdir /etc/nginx/sites-available
sudo mkdir /etc/nginx/sites-enabled
sudo touch /etc/nginx/sites-available/mywebsite.com
sudo ln -s /etc/nginx/sites-available/mywebsite.com /etc/nginx/sites-enabled/mywebsite.com
sudo echo "server {
    listen 80;
    server_name mywebsite.com www.mywebsite.com;
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl;
    server_name mywebsite.com www.mywebsite.com;

    ssl_certificate /etc/letsencrypt/live/mywebsite.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/mywebsite.com/privkey.pem;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }

    location /wp-admin/ {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
        expires max;
        log_not_found off;
    }
}" | sudo tee /etc/nginx/sites-available/mywebsite.com

# Note: replace 'mywebsite.com' with your own domain name.

# Install Certbot and obtain SSL certificate
sudo amazon-linux-extras install -y epel
sudo yum install -y certbot python3-certbot-nginx
sudo certbot --nginx -d mywebsite.com -d www.mywebsite.com

# Note: replace 'mywebsite.com' with your own domain name.

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
