#!/bin/bash

# Запрос домена 
echo "Enter domain name:"
read domain

# Запрос имени нового пользователя
echo "Enter new username:"
read username

# Проверка, было ли введено имя пользователя
if [ -z "$username" ]; then
    echo "Имя пользователя не введено. Скрипт будет остановлен."
    exit 1
else
    # Создание нового пользователя
    sudo adduser "$username"
fi

# Добавить пользователя в группу sudo
echo "Add user:$username to \"sudo\" group"
sudo adduser "$username" sudo > /dev/null
# groups "$username"

# SSH
echo "Config SSH for user:$username"
rsync --archive --chown="$username":"$username" ~/.ssh /home/"$username"  > /dev/null

# Create Server Block
echo "Create Server Block for domain:$domain"
sudo mkdir -p /var/www/"$domain"/html > /dev/null

index_html="/var/www/$domain/html/index.html"
sudo touch "$index_html" > /dev/null
echo "<html>
    <head>
        <title>Welcome to $domain!</title>
    </head>
    <body>
        <h1>Success! The $domain server block is working!</h1>
    </body>
</html>" | sudo tee "$index_html" > /dev/null

sudo chown -R "$username":"$username" /var/www/"$domain" > /dev/null
sudo chmod -R 755 /var/www/"$domain" > /dev/null

# Install Nginx
echo "Install Nginx"
sudo apt-get install nginx
sudo systemctl enable nginx
sudo systemctl start nginx

# Setup Nginx for Server Block
echo "Setup Nginx for Server Block"
config_file="/etc/nginx/sites-available/$domain"
sudo touch "$config_file" > /dev/null
echo "server {
    listen 80;
    server_name $domain www.$domain;

    root /var/www/$domain/html;
    index index.html index.htm index.nginx-debian.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}" | sudo tee "$config_file" > /dev/null
sudo ln -s "$config_file" /etc/nginx/sites-enabled/ > /dev/null

# Setup Firewall
echo "Setup Firewall for OpenSSH"
sudo ufw allow "OpenSSH" > /dev/null

echo "Setup Firewall for Nginx HTTPS"
sudo ufw allow 'Nginx HTTPS' > /dev/null
# sudo ufw status

# SSL
sudo snap install core; sudo snap refresh core
sudo apt remove certbot
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot --nginx -d "$domain" -d "www.$domain"
sudo systemctl status snap.certbot.renew.service

# Enable Firewall
yes | sudo ufw enable

