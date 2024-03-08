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

# Установка Nginx
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx

# Firewall
sudo ufw allow "OpenSSH"
sudo ufw allow 'Nginx HTTPS'
sudo ufw enable
# sudo ufw status


# Обновление списка пакетов и установка обновлений
# sudo apt update && sudo apt upgrade -y

# Установка Nginx
# sudo apt install nginx -y

# Включение и запуск Nginx
# sudo systemctl enable nginx
# sudo systemctl start nginx
