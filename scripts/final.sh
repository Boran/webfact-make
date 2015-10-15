#!/bin/sh
#
# Final script to run after Drupal has been installed.
# Do stuff that cannot be done in the makefile or profile.

cd /var/www/html; 
echo "-- Install drupal composer and composer-manager modules"
drush dl -y composer-8.x-1.x; 

# 2015.05.21: hotfix: composer module is broken, see https://www.drupal.org/node/2461921
# for now manually apply patch
#echo "-- Apply composer module patch https://www.drupal.org/files/issues/2461921-2.patch"
#cd /root/.drush/composer
#wget https://www.drupal.org/files/issues/2461921-2.patch
#patch -p1 < 2461921-2.patch
#cd /var/www/html; 

drush -y composer-manager install;

# Setup a default update mechanism
ln -s sites/all/modules/custom/webfact/webfact_update.sh webfact_update.sh

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

# Defaults as installed by vagrant
# todo: set these as docker environment variables
drush vset webfact_msglevel2 1
drush vset webfact_msglevel3 1
drush vset webfact_fserver webfact.docker
drush vset webfact_dserver unix:///var/run/docker.sock
drush vset webfact_rproxy nginx
# Use docker volume for data persistence
drush vset webfact_data_volume 1
drush vset webfact_www_volume 1
# Disable automatic image backups
drush vset webfact_rebuild_backups 0

# external DB
ln -s /var/www/html/sites/all/modules/custom/webfact /webfact
(cd /webfact && mysql -uroot -p$MYSQL_ENV_MYSQL_ROOT_PASSWORD mysql < external_db/ext_db.sql)

drush vset webfact_manage_db 1
drush vset webfact_manage_db_host mysql
drush vset webfact_manage_db_user webfact_create
# TODO: import the mysql stored procedures
# parameter!
drush vset webfact_manage_db_pw $WEBFACT_MANAGE_DB_PW
env | grep PAS


sudo mkdir -p /opt/sites/vanilla/www /opt/sites/vanilla/data
sudo chown -R www-data /opt/sites/vanilla


# clear caches
drush -y cache-clear drush

# Ensure webui can access docker socket
sudo chown www-data /var/run/docker.sock;
sudo usermod -aG docker www-data

# Git settings
git config --global push.default matching

