#!/bin/bash

# Запрос домена 
echo "Enter domain name:"
read domainname

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

# Install Nginx
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx

# Setup Firewall
sudo ufw allow "OpenSSH"
sudo ufw allow 'Nginx HTTPS'
sudo ufw enable
# sudo ufw status

# SSH
rsync --archive —chown="$username":"$username" ~/.ssh /home/"$username"

# Create Server Block
sudo mkdir -p /var/www/"$domainname"/web
sudo chown -R "$username":"$username" /var/www/"$domainname"
sudo chmod -R 755 /var/www/"$domainname"

# Setup Nginx for Server Block
config_file="/etc/nginx/sites-available/$domainname"
sudo touch "$config_file"
echo "server {
    listen 80;
    server_name $domainname www.$domainname;

    root /var/www/$domainname/html;
    index index.html index.htm index.nginx-debian.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}" > "$config_file"

# Обновление списка пакетов и установка обновлений
# sudo apt update && sudo apt upgrade -y

# Установка Nginx
# sudo apt install nginx -y

# Включение и запуск Nginx
# sudo systemctl enable nginx
# sudo systemctl start nginx
