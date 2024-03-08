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
sudo adduser "$username" sudo
# groups "$username"

# SSH
rsync --archive --chown="$username":"$username" ~/.ssh /home/"$username"

# Create Server Block
sudo mkdir -p /var/www/"$domain"/html
sudo chown -R "$username":"$username" /var/www/"$domain"
sudo chmod -R 755 /var/www/"$domain"

# Install Nginx
echo "Install Nginx"
sudo apt install nginx -y > /dev/null
sudo systemctl enable nginx > /dev/null
sudo systemctl start nginx > /dev/null

# Setup Nginx for Server Block
config_file="/etc/nginx/sites-available/$domain"
sudo touch "$config_file"
echo "server {
    listen 80;
    server_name $domain www.$domain;

    root /var/www/$domain/html;
    index index.html index.htm index.nginx-debian.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}" | sudo tee "$config_file" > /dev/null

# Setup Firewall
echo "Setup Firewall for OpenSSH"
sudo ufw allow "OpenSSH" > /dev/null

echo "Setup Firewall for Nginx HTTPS"
sudo ufw allow 'Nginx HTTPS' > /dev/null

# yes | sudo ufw enable
# sudo ufw status

# Обновление списка пакетов и установка обновлений
# sudo apt update && sudo apt upgrade -y

# Установка Nginx
# sudo apt install nginx -y

# Включение и запуск Nginx
# sudo systemctl enable nginx
# sudo systemctl start nginx
