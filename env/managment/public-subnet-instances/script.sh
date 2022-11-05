#!/bin/bash
sudo apt-get update
sudo apt-get install nginx -y 
sudo systemctl enable --now nginx
wget https://www.free-css.com/assets/files/free-css-templates/download/page2/prestigious.zip
sudo apt-get install zip -y
unzip prestigious.zip
sudo rm -rf /var/www/html/*.html
sudo cp -rf /home/ubuntu/prestigious/* /var/www/html/
sudo systemctl restart nginx