#!/bin/sh

sudo apt-get update
sudo apt-get install php5 apache2 libapache2-mod-php5 mysql-server mysql-client php5-mysql php5-suhosin libzend-framework-php libzend-framework-zendx-php
sudo a2enmod rewrite
sudo a2enmod headers
wget https://raw.github.com/TeamRocketScience/etcMagic/master/etc/php5/apache2/php.ini -O /etc/php5/apache2/php.ini
service apache2 restart
