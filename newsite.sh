#!/bin/bash

# Requirements:
#  1. Drush pre installed and part of the path
#  2. Apache setup with user home directories

# Setup the variables and echo them out for debugging
SITENAME=$1

echo Creating Site: $SITENAME

mkdir ~/Sites/$SITENAME

cp -a ~/Sites/drupal-7.14/ ~/Sites/$SITENAME

# Download the Drupal installation
cd ~/Sites/$SITENAME/sites/default

echo Setup the settings.
cp default.settings.php settings.php
chmod 777 settings.php

echo Setup the public files.
mkdir files
chmod 777 files

echo Drush Site Install
# mysql user - drupal7
# mysql user password - password
# mysql host - localhost

drush site-install standard --account-name=admin --account-pass=password --account-mail=benbunk@gmail.com --db-url=mysql://drupal7:password@localhost:3306/$SITENAME --site-name=$SITENAME --yes

#todo
echo Setup the apache config.
mv ~/Sites/$SITENAME/.htaccess ~/Sites/$SITENAME/.htaccess.bak
sed s@'# RewriteBase /'@"RewriteBase /~ben/$SITENAME"@ ~/Sites/$SITENAME/.htaccess.bak > ~/Sites/$SITENAME/.htaccess

echo Site Installed.
echo Username: admin
echo Password: password
echo Site URL: http://localhost/~ben/$SITENAME
