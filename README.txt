This program will assist in the setup of a Drupal 6, 7, or 8 site on your Mac using stock configurations of Apache, MySQL, and PHP.

There are two types of configurations supported:

1. VHOSTS - Checkout the vhosts branch above.
  Provides a unique apache VHOST for each site.
  Creates an entry in /etc/hosts.
  Requires an apache restart for each new site.
  Requires root privileges to install (write to /etc/hosts, /etc/apache2/extras, restart apache).
  Now supports deleting sites as well.

2. User Sites - Checkout the user-sites branch above.
  Much easier setup.
  Requires modifying the htaccess file in the drupal directory.
  Simple to get started.
