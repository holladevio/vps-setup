#!/bin/bash

# Запрос имени нового пользователя
echo "Enter new user:"
read username

# Проверка, было ли введено имя пользователя
if [ -z "$username" ]; then
    echo "Имя пользователя не введено. Скрипт будет остановлен."
    exit 1
else
    # Создание нового пользователя
    sudo adduser "$username"
fi


# Обновление списка пакетов и установка обновлений
# sudo apt update && sudo apt upgrade -y

# Установка Nginx
sudo apt install nginx -y

# Включение и запуск Nginx
sudo systemctl enable nginx
sudo systemctl start nginx
