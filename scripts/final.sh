#!/bin/sh
#
# Final script to run after Drupal has been installed.
# Do stuff that cannot be done in the makefile or profile.

echo "---- Running $1 from webfact-make ----"

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

echo "-- theme settings"
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

echo "-- disable blocks"
echo "update block set status=0 where delta='navigation' and theme='webfact_theme'" | drush sql-cli
echo "update block set status=0 where delta='powered-by' and theme='webfact_theme'" | drush sql-cli
echo "update block set status=0 where module='search' and theme='webfact_theme'" | drush sql-cli

# Assume not for development
drush -y dis devel

echo "-- set webfact variables"
drush vset webfact_msglevel2 1
drush vset webfact_msglevel3 1
drush vset webfact_fserver webfact.docker
drush vset webfact_dserver unix:///var/run/docker.sock
drush vset webfact_rproxy nginx
echo "-- Use docker volume for data persistence"
drush vset webfact_data_volume 1
drush vset webfact_www_volume 1
echo "-- Disable automatic image backups"
drush vset webfact_rebuild_backups 0

# comfort when developing
ln -s /var/www/html/sites/all/modules/custom/webfact /webfact

echo "-- setup external DB on $MYSQL_HOST as $WEBFACT_MANAGE_DB_USER with API type $WEBFACT_API"
# Run the webfactory DB in a seperate container
drush vset webfact_manage_db 1
# set defaults
MYSQL_HOST=${MYSQL_HOST+mysql};  
WEBFACT_MANAGE_DB_USER=${WEBFACT_MANAGE_DB_USER+webfact_create}; 
WEBFACT_MANAGE_DB_PW=${WEBFACT_MANAGE_DB_PW+someThingRealllySecreT}; 
drush vset webfact_manage_db_host $MYSQL_HOST
drush vset webfact_manage_db_user $WEBFACT_MANAGE_DB_USER
drush vset -q webfact_manage_db_pw $WEBFACT_MANAGE_DB_PW

WEBFACT_API=${WEBFACT_API+0};  # set default=0 for Docker API
if [ "$WEBFACT_API" == "1" ] ; then 
  echo "****** mesos *****"
  echo "-- Webfact will manage containers via the mesos API, the following steps must be manually done, see https://github.com/Boran/webfact/tree/master/external_db  "
  echo "   1. Create a user $WEBFACT_MANAGE_DB_USER in the DB "
  echo "   2. load the stored procedures and grant access."
  echo "   3. Ensure this webfact container has writeable access to the /opt/sites volume"
  echo "   See also http://thisserver/admin/config/development/webfact"
  echo "**************"
else 
  echo "-- docker API "
  if [ -z "$MYSQL_HOST" ] ; then 
    # db is in a spearet container, premuse mysql root pw is available
    echo "-- create mysql user $WEBFACT_MANAGE_DB_USER"
    #echo "select User from user" | mysql -uroot -p$MYSQL_ENV_MYSQL_ROOT_PASSWORD mysql
    echo "create user $WEBFACT_MANAGE_DB_USER@'%' identified by '$WEBFACT_MANAGE_DB_PW'" | mysql -uroot -p$MYSQL_ENV_MYSQL_ROOT_PASSWORD mysql
    echo "-- add sql stored procedures"
    (mysql -uroot -p$MYSQL_ENV_MYSQL_ROOT_PASSWORD mysql < /var/www/html/sites/all/modules/custom/webfact/external_db/ext_db.sql)
  fi

  echo "-- Webfact will manage containers via the Docker API:  "
  echo "-- For vanilla test website: create /opt/sites/vanilla"
  sudo mkdir -p /opt/sites/vanilla/www /opt/sites/vanilla/data
  sudo chown -R www-data /opt/sites/vanilla

  echo "-- Ensure webui can access /var/run/docker.sock"
  sudo chown www-data /var/run/docker.sock;
  #sudo usermod -aG docker www-data
fi

echo "clear caches"
drush -y cache-clear drush

echo "-- git settings"
git config --global push.default matching

echo "---- Done $1 from webfact-make ----"

