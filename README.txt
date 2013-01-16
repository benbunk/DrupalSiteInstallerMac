DESCRIPTIONS:
  This is a very simple script to download the latest copy of Drupal and 
  install and configure it for first time use. There are many assumptions made 
  about the configuration of the Mac and I will try my best to list them below.

QUICK:
  The short version of all this is that if you have an unmodified Mac you can 
  download Git, Drush, and MySQL and run this script and have a fully 
  functioning Drupal site in minutes.

INSTALL: Download newsite.sh and make sure it's executable.

USAGE:
  ./newsite [DRUPAL VERSION] [SITE NAME] [Repo to checkout]
    [DRUPAL VERSION] = 6 or 7
    [SITE NAME] = Used for database name, folder name, and url part (http://localhost/~username/sitename)
    [Repo to checkout] = (OPTIONAL) github, drupal.org, local
      Local only works after you've used either github or drupal.org at least once.

  Example:
  ./newsite 6 test_site github
  ./newsite 7 test_site7 drupal.org
  ./newsite 6 localinstall local
  ./newsite 7 local7install local

ASSUMPTIONS: 
 - Stock OSX Apache installation and configuration
 - Stock OSX PHP installation configuration
 - Apache is configured to allow user directories in the form of 
     http://localhost/~USERNAME/ which is located in ~/Sites
 - Apache is configured to allow .htaccess files to override existing configs.
 - Git must be installed and part of the PATH environment variable.
 - Drush must be installed and part of the PATH environment variable.
 - MySQL must be installed and part of the PATH environment variable.
 - MySQL 
     Username: drupal
     Password: password

