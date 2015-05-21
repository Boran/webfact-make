#!/bin/sh
#
# Final script to run after Drupal has been installed.
# Do stuff that cannot be done in the makefile or profile.

cd /var/www/html; 
echo "-- Install drupal composer and composer-manager modules"
drush dl -y composer-8.x-1.x; 

# 2015.05.21: hotfix: composer module is broken, see https://www.drupal.org/node/2461921
# for now manually apply patch
echo "-- Apply composer module patch https://www.drupal.org/files/issues/2461921-2.patch"
cd /root/.drush/composer
wget https://www.drupal.org/files/issues/2461921-2.patch
patch -p1 < 2461921-2.patch
cd /var/www/html; 

drush -y composer-manager install;

# Theming
cp /opt/drush-make/webfact-make/scripts/Factory150.jpg sites/default/files/Factory150.jpg
cat << EOF | drush vset --format=json theme_settings -
{
    "theme_settings": {
        "toggle_logo": 1,
        "toggle_name": 1,
        "toggle_slogan": 0,
        "toggle_node_user_picture": 1,
        "toggle_comment_user_picture": 1,
        "toggle_comment_user_verification": 1,
        "toggle_favicon": 1,
        "toggle_main_menu": 1,
        "toggle_secondary_menu": 1,
        "default_logo": 0,
        "logo_path": "public:\/\/Factory150.jpg",
        "logo_upload": "",
        "default_favicon": 0,
        "favicon_path": "",
        "favicon_upload": ""
    }
}
EOF

echo "update block set status=0 where delta='navigation' and theme='webfact_theme'" | drush sql-cli
echo "update block set status=0 where delta='powered-by' and theme='webfact_theme'" | drush sql-cli
echo "update block set status=0 where module='search' and theme='webfact_theme'" | drush sql-cli

# Assume not for development
drush -y dis devel

# clear caches
drush -y cache-clear drush

# Ensure webui can access docker socket
chown www-data /var/run/docker.sock;

# Git settings
git config --global push.default matching

