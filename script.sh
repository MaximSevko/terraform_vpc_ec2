#!/bin/bash

# Mount the mysql-server directory
sudo mkdir -p ~/mysql-server
sudo mkfs -t xfs /dev/nvme1n1
sudo mount /dev/sdb ~/mysql-server
echo $(blkid | grep /dev/nvme1n1 | awk '{print $2}') /home/ec2-user/mysql xfs defaults 1 1 >> /etc/fstab
sudo mount -a

# Install and configure MySQL
sudo yum update -y
sudo amazon-linux-extras install -y epel
sudo yum install -y mysql-server
sudo systemctl enable mysqld
sudo systemctl start mysqld
sudo mysql_secure_installation <<EOF

y
password
password
y
y
y
y
EOF

# Note: replace 'password' with your own secure password.

# Configure MySQL to use the mounted disk
sudo systemctl stop mysqld
sudo mkdir /mnt/mysql-data
sudo mv /var/lib/mysql/* /mnt/mysql-data/
sudo echo "datadir=/mnt/mysql-data" | sudo tee -a /etc/my.cnf
sudo systemctl start mysqld
# Install and configure Nginx
sudo yum install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
sudo chown -R ec2-user:ec2-user /usr/share/nginx/html/
sudo echo "Welcome to my website!" > /usr/share/nginx/html/index.html

# Configure Nginx to serve WordPress
sudo mkdir /etc/nginx/sites-available
sudo mkdir /etc/nginx/sites-enabled
sudo touch /etc/nginx/sites-available/mywebsite.dev.qkdev.net
sudo ln -s /etc/nginx/sites-available/mywebsite.dev.qkdev.net /etc/nginx/sites-enabled/mywebsite.dev.qkdev.net
sudo echo "server {
    listen 80;
    server_name mywebsite.dev.qkdev.net www.mywebsite.dev.qkdev.net;
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl;
    server_name mywebsite.dev.qkdev.net www.mywebsite.dev.qkdev.net;

    ssl_certificate /etc/letsencrypt/live/mywebsite.dev.qkdev.net/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/mywebsite.dev.qkdev.net/privkey.pem;

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
}" | sudo tee /etc/nginx/sites-available/mywebsite.dev.qkdev.net


# Install Certbot and obtain SSL certificate
sudo amazon-linux-extras install -y epel
sudo yum install -y certbot python3-certbot-nginx
sudo certbot --nginx -d mywebsite.dev.qkdev.net -d www.mywebsite.dev.qkdev.net

# Note: replace 'mywebsite.dev.qkdev.net' with your own domain name.

# Restart Nginx to apply changes
sudo systemctl restart nginx
