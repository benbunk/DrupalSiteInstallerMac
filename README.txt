This program will assist in the setup of a Drupal 6, 7, or 8 site on your Mac using stock configurations of Apache, MySQL, and PHP.

There are two types of configurations supported:

1. VHOSTS - Checkout the vhosts branch above.
  Provides a unique apache configuration for each site.
  Creates an entry in /etc/hosts
  Requires a special setup of the /etc/hosts and /etc/apache2/extras/httpd-vhosts.conf file.
  Requires an apache restart for each new site.
  Requires root privileges to install.

2. User Sites - Checkout the user-sites branch above.
  Much easier setup.
  Requires modifying the htaccess file in the drupal directory.
  Simple to get started.
