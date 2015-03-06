#!/bin/sh
#
# Script to run after the end of the Drupal installation
# example DRUPAL_FINAL_SCRIPT.

cd /var/www/html

drush -y dl prod_check && drush -y en prod_check
drush -y cache-clear drush
#drush -y prod-check-prodmode

drush status
