#!/bin/bash

# Remove a site created with the newsite.sh tool.

SITENAME=$1
PATTERN=$SITENAME

# Remove the site directory.
sudo rm -r ~/Sites/$SITENAME.localhost

# Drop the MySQL database;
sudo mysql -e "drop database $SITENAME;"

# Remove the hosts entry.
# http://stackoverflow.com/questions/4396974/sed-delete-n-lines-following-a-pattern
sudo sed -i -e "/$PATTERN/,/$PATTERN/ d" ~/Dropbox/install/hosts

# Remove the virtual host.
sudo sed -i -e "/$PATTERN/,/<\/VirtualHost>/ d" ~/Dropbox/install/httpd/extra/httpd-vhosts.conf
