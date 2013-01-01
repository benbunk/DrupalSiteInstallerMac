#!/bin/bash

# Requirements:
#  1. Drush pre installed and part of the path
#  2. Apache setup with user home directories
#  3. Git installed and part of the path

# @todo - Change the repo checkout logic. Default to local and only checkout 
#          from elsewhere if needed. When checking out from elsewhere checkout  
#          directly to local cache and then clone from local as usual.
# @todo - Fix all the relative pathing and directory changing so that we don't 
#          need to run the script from inside the root of the ~/Sites directory.
# @todo - For d8 the database must be created manually and you must use 127.0.0.1 instead of localhost.


# CREATE DATABASE d8;
# GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, LOCK TABLES, CREATE TEMPORARY TABLES ON `d8`.* TO 'drupal7'@'localhost';
# FLUSH PRIVILEGES;

# Setup Static variables
MYSQLUSER=drupal7
MYSQLPASS=password
MYSQLHOST=127.0.0.1

# Setup the variables and echo them out for debugging
VERSION=$1
SITENAME=$2
REPO=$3

# Default repo is github -- this is 10x faster then d.o
REPOURL="git://github.com/drupal/drupal.git"
# Check if the they manually selected d.o over github.
if [ "$REPO" = "drupal.org" ]; then
  REPOURL="http://git.drupal.org/project/drupal.git"
fi
# Check if the local repos are to be used.
if [ "$REPO" = "local" ]; then
  REPOURL=~/Sites/drupal-$VERSION
fi

echo Creating Site: $SITENAME from Repo: $REPOURL
git clone --recursive --branch $VERSION.x $REPOURL $SITENAME

# Check if the local repo for this version exists. If not create it for caching.
if [ ! -e ~/Sites/drupal-$VERSION ]; then 
  git clone $SITENAME ~/Sites/drupal-$VERSION
fi

# Only create the settings file if the site checked out.
if [ -e ~/Sites/$SITENAME ]; then
  echo Setup the Drupal settings.
  cd ~/Sites/$SITENAME/sites/default
  cp default.settings.php settings.php
  chmod 777 settings.php
fi

# Only create files if the git checkout worked.
if [ -e ~/Sites/$SITENAME ]; then
  echo Setup the public files.
  mkdir files
  chmod 777 files
fi

echo Drush Site Install.
if [ "$VERSION" = "7" ]; then
  drush site-install standard --account-name=admin --account-pass=password --account-mail=benbunk@example.com --db-url=mysql://$MYSQLUSER:$MYSQLPASS@$MYSQLHOST:3306/$SITENAME --site-name=$SITENAME --yes
  drush dis dblog, update, color, comment, dashboard, help, overlay, search, shortcut --yes
  drush en syslog --yes
elif [ "$VERSION" = "8" ]; then
  drush site-install standard --account-name=admin --account-pass=password --account-mail=benbunk@example.com --db-url=mysql://$MYSQLUSER:$MYSQLPASS@$MYSQLHOST:3306/$SITENAME --site-name=$SITENAME --yes
else
  # @todo - This always fails for Drupal 6 on my machine. It does however 
  #         create the DB so all that's needed is to finish the install in the 
  #         browser.
  drush site-install default --account-name=admin --account-pass=password --account-mail=benbunk@example.com --db-url=mysqli://$MYSQLUSER:$MYSQLPASS@$MYSQLHOST:3306/$SITENAME --site-name=$SITENAME --yes
fi

echo Setup the apache config.
mv ~/Sites/$SITENAME/.htaccess ~/Sites/$SITENAME/.htaccess.bak
sed s@'# RewriteBase /'@"RewriteBase /~$USER/$SITENAME"@ ~/Sites/$SITENAME/.htaccess.bak > ~/Sites/$SITENAME/.htaccess

echo Site Installed.
echo Username: admin
echo Password: password
echo Site URL: http://localhost/~$USER/$SITENAME
