#!/bin/bash
sudo apt update
sudo apt-get install -y apache2
sudo systemctl start apache2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip -y
sudo unzip awscliv2.zip
sudo ./aws/install
sudo rm /var/www/html/index.html
sudo aws s3 sync s3://buckie-the-bucket /var/www/html
sudo apt install mysql-client -y

echo "* * * * * root sudo aws s3 sync s3://buckie-the-bucket /var/www/html" >> /etc/crontab

echo "for filename in \$(ls -1 /var/www/html); do mysql -u remuser -premuser -h 192.168.0.200 -e \"USE files; INSERT INTO file (name) VALUES ('\$filename');\"; done" > /home/ubuntu/sqlInsert.sh
sudo chmod 755 /home/ubuntu/sqlInsert.sh
echo "* * * * * root sudo /home/ubuntu/sqlInsert.sh" >> /etc/crontab


