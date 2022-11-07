#!/bin/bash
sudo apt-get update
sudo apt-get install nginx -y 
sudo systemctl enable --now nginx
wget https://www.free-css.com/assets/files/free-css-templates/download/page285/farmfresh.zip
sudo apt-get install zip -y
unzip farmfresh.zip
sudo rm -rf /var/www/html/*.html
sudo cp -rf /home/ubuntu/farmfresh/* /var/www/html/
sudo systemctl restart nginx