#!/bin/bash
# устанавливает на чистую виртуалку redmine и запускает его через webrick
# скрипт недопилен в плане параметров (пароли везде 123, юзер - juggler, ip виртуалки - 192.168.32.136
# так же, желательно работать через apache+passenger, а не через медленный webrick, но для локальных и тестовых нужд скрипт вполне годится
sudo apt-get install -y vim git ruby rake mysql-server mysql-client libmysqlclient16-dev ruby1.8-dev libopenssl-ruby1.8 rubygems

sudo gem install rails -v=2.3.11
sudo gem install rack -v=1.1.0
sudo gem install mysql
sudo gem install i18n -v=0.4.2

git clone git://github.com/edavis10/redmine.git

cd redmine
cp config/database.yml.example config/database.yml

ex config/database.yml <<EOEX
  :7s/username: root/username: redmine/
  :8s/password:/password: 123
  :x
EOEX

mkdir tmp public/plugin_assets
sudo chown -R juggler:juggler files log tmp public/plugin_assets
sudo chmod -R 755 files log tmp public/plugin_assets

sudo mysql -u root -e "create database redmine character set utf8;" --password="123"
sudo mysql -u root -e "create user 'redmine'@'localhost' identified by '123';" --password="123"
sudo mysql -u root -e "grant all privileges on redmine.* to 'redmine'@'localhost';" --password="123"


ex Rakefile <<EOEX
  :6s/.*/require 'rake\/dsl_definition'\rrequire 'rake'/
  :x
EOEX

rake generate_session_store
RAILS_ENV=production rake db:migrate
RAILS_ENV=production REDMINE_LANG="en" rake redmine:load_default_data

sudo ruby script/server webrick -e production -p 80 -b 192.168.32.136
