#!/bin/bash

# Обновление списка пакетов и установка обновлений
sudo apt update && sudo apt upgrade -y

# Установка Nginx
sudo apt install nginx -y

# Включение и запуск Nginx
sudo systemctl enable nginx
sudo systemctl start nginx
