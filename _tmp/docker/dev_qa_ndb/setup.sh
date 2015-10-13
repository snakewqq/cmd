#!/bin/sh

ssh -t -t -o "StrictHostKeyChecking no" git@192.168.5.26
git clone git@192.168.5.26:ndb.git /usr/share/nginx/www/ndb
chmod 777 /usr/share/nginx/www/ndb/protected/runtime
chmod 777 /usr/share/nginx/www/ndb/assets
cd /usr/share/nginx/www/ndb
git checkout develop
cp /root/main.qa.php /usr/share/nginx/www/ndb/protected/config/
cp /root/console.qa.php /usr/share/nginx/www/ndb/protected/config/
cp /root/envs.php /usr/share/nginx/www/ndb/protected/config/

