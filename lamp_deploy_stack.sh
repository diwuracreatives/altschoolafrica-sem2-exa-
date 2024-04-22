#TASK- On the Master node, create a bash script to automate the deployment of a LAMP (Linux, Apache, MySQL, PHP) stack.
#This script should clone a PHP application from GitHub, install all necessary packages, and configure Apache web server and MySQL. 
#Ensure the bash script is reusable and readable.


#Update and install Apache, MySQL, PHP
sudo apt-get update
sudo apt-get install -y apache2 mysql-server php php-mysql libapache2-mod-php php-cli php-fpm php-json php-common php-mysql php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath

# Set up MySQL database
sudo mysql -e "CREATE DATABASE IF NOT EXISTS laravel;"
sudo mysql -e "CREATE USER IF NOT EXISTS 'laraveluser'@'localhost' IDENTIFIED BY 'password';"
sudo mysql -e "GRANT ALL PRIVILEGES ON laravel.* TO 'laraveluser'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Clone Laravel project
cd /var/www/html
sudo git clone https://github.com/laravel/laravel.git
cd laravel
sudo composer install

# Setting up folder permissions
sudo chown -R www-data:www-data /var/www/html/laravel
sudo chmod -R 755 /var/www/html/laravel

# Configuring Apache
sudo echo "<VirtualHost *:80>
    DocumentRoot /var/www/html/laravel/public
    <Directory /var/www/html/laravel/public>
        AllowOverride All
        Order Allow,Deny
        Allow from all
    </Directory>
</VirtualHost>" > /etc/apache2/sites-available/laravel.conf

sudo a2ensite laravel.conf
sudo a2dissite 000-default.conf
sudo systemctl restart apache2
