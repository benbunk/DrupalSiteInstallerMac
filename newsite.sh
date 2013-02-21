#!/bin/bash

# Requirements:
#  1. Drush pre installed and part of the path
#  2. Apache setup with vhosts
#  3. Git installed and part of the path

# @todo - Change the repo checkout logic. Default to local and only checkout 
#          from elsewhere if needed. When checking out from elsewhere checkout  
#          directly to local cache and then clone from local as usual.
# @todo - For d8 the database must be created manually and you must use 127.0.0.1 instead of localhost.

# CREATE DATABASE d8;
# GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, LOCK TABLES, CREATE TEMPORARY TABLES ON *.* TO 'drupal'@'localhost' IDENTIFIED BY 'password';
# FLUSH PRIVILEGES;

# Setup Static variables
MYSQLUSER=drupal
MYSQLPASS=password
MYSQLHOST=127.0.0.1

# Setup the variables and echo them out for debugging
VERSION=$1
SITENAME=$2
REPO=$3
PROFILE=$4

# Help Text.
if [ "$VERSION" = "help" ]; then
 echo "
Usage: newsite [version] [sitename] [repo] [profile]"
 echo "
Example: newsite 7 testSiteName github standard"
 echo "
Variables:
    version  - 6, 7 or 8
    sitename - Will be added to hosts file as [sitename].local
    repo     - github, local or drupal.org
    profile  - minimal, standard or anything custom you add to a local copy."
 echo "
Default Variables:
    DB User     - drupal
    DB Pass     - password
    DB Host     - 127.0.0.1

    Drupal User - admin
    Drupal Pass - password"
 exit
fi

# Create blank DB if option one is DB and option two is a DB name.

# Default Profile value
if [ -z "$PROFILE" ]; then
  PROFILE="standard"
fi

# Default repo is github -- this is 10x faster then d.o
REPOURL="git://github.com/drupal/drupal.git"
# Check if they manually selected d.o over github.
if [ "$REPO" = "drupal.org" ]; then
  REPOURL="http://git.drupal.org/project/drupal.git"
fi
# Check if the local repos are to be used.
if [ "$REPO" = "local" ]; then
  REPOURL=~/Sites/drupal-$VERSION
fi

echo Creating Site: $SITENAME from Repo: $REPOURL
git clone --recursive --branch $VERSION.x $REPOURL ~/Sites/$SITENAME.local

# Check if the local repo for this version exists. If not create it for caching.
if [ ! -e ~/Sites/drupal-$VERSION ]; then 
  git clone $SITENAME ~/Sites/drupal-$VERSION
fi

# Only create the settings file if the site checked out.
if [ -e ~/Sites/$SITENAME.local ]; then
  echo Setup the Drupal settings.
  cd ~/Sites/$SITENAME.local/sites/default
  cp default.settings.php settings.php
  chown _www:staff settings.php
fi

# Only create files if the git checkout worked.
if [ -e ~/Sites/$SITENAME.local ]; then
  echo Setup the public files.
  # Assumes we completed the cd command into the sites/default directory.
  mkdir files
  chown _www:staff files
fi

echo Drush Site Install.
if [ "$VERSION" = "7" ]; then
  drush site-install $PROFILE --account-name=admin --account-pass=password --account-mail=benbunk@example.com --db-url=mysql://$MYSQLUSER:$MYSQLPASS@$MYSQLHOST:3306/$SITENAME --site-name=$SITENAME --yes
elif [ "$VERSION" = "8" ]; then
  drush site-install $PROFILE --account-name=admin --account-pass=password --account-mail=benbunk@example.com --db-url=mysql://$MYSQLUSER:$MYSQLPASS@$MYSQLHOST:3306/$SITENAME --site-name=$SITENAME --yes
else
  # @todo - This always fails for Drupal 6 on my machine. It does however 
  #         create the DB so all that's needed is to finish the install in the 
  #         browser.
  drush site-install default --account-name=admin --account-pass=password --account-mail=benbunk@example.com --db-url=mysqli://$MYSQLUSER:$MYSQLPASS@$MYSQLHOST:3306/$SITENAME --site-name=$SITENAME --yes
fi

echo Setup the apache config.
echo "
# $SITENAME - Drupal-$VERSION - Profile $PROFILE - Repo $REPO 
<VirtualHost *:80>
    ServerAdmin webmaster@$SITENAME.local
    DocumentRoot '/Users/ben/Sites/$SITENAME.local'
    ServerName $SITENAME.local
    ServerAlias www.$SITENAME.local
    ErrorLog '/private/var/log/apache2/$SITENAME-error_log'
    CustomLog '/private/var/log/apache2/$SITENAME-access_log' common

    <Directory /Users/ben/Sites/$SITENAME.local>
      AllowOverride All
    </Directory>
</VirtualHost>

" >> ~/Documents/install/httpd/extra/httpd-vhosts.conf

echo Setup the hosts file.
echo "
# $SITENAME - Drupal-$VERSION - Profile $PROFILE - Repo $REPOURL
127.0.0.1 $SITENAME.local www.$SITENAME.local

" >> ~/Documents/install/hosts

echo Restarting Apache
sudo apachectl restart

echo Site Installed.
echo Username: admin
echo Password: password
echo Site URL: http://$SITENAME.local/
