#!/bin/bash
sudo mkdir /home/test
sudo apt-get update -y
sudo apt-get install -y mysql-server
sudo systemctl start mysql
sudo systemctl enable mysql
sleep 30
sudo mysql
echo "ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'matteo';"