#!/bin/bash
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

# comfort when developing
ln -s /var/www/html/sites/all/modules/custom/webfact /webfact
ln -s /var/www/html/sites/all/modules/custom/webfact_content_types /webfact_content_types

# set defaults
WEBFACT_API=${WEBFACT_API:-0};  # set default=0 for Docker API
WEBFACT_MANAGE_DB_USER=${WEBFACT_MANAGE_DB_USER:-webfact_create}; 
WEBFACT_MANAGE_DB_PW=${WEBFACT_MANAGE_DB_PW:-someThingRealllySecreT}; 

echo "-- setup external DB on host $MYSQL_HOST as $WEBFACT_MANAGE_DB_USER with API type $WEBFACT_API"
# Run the webfactory DB in a seperate container
drush vset webfact_manage_db 1
drush vset webfact_manage_db_user $WEBFACT_MANAGE_DB_USER
drush vset -q webfact_manage_db_pw $WEBFACT_MANAGE_DB_PW

#MYSQL_HOST=${MYSQL_HOST:-mysql};  
if [ ! -z "${MYSQL_HOST+x}" ] ; then    # if mysql_host set?
  echo "  db is in a separate instance called $MYSQL_HOST"
  drush vset webfact_manage_db_host $MYSQL_HOST
  if [ ! -z "${MYSQL_ENV_MYSQL_ROOT_PASSWORD+x}" ] ; then
    MYSQL_ENV_MYSQL_ROOT_USER=${MYSQL_ENV_MYSQL_ROOT_USER:-root}; 
    echo "   create mysql user $WEBFACT_MANAGE_DB_USER using $MYSQL_ENV_MYSQL_ROOT_USER"
    echo "create user $WEBFACT_MANAGE_DB_USER@'%' identified by '$WEBFACT_MANAGE_DB_PW'" | mysql -h$MYSQL_HOST -u$MYSQL_ENV_MYSQL_ROOT_USER -p$MYSQL_ENV_MYSQL_ROOT_PASSWORD mysql
    echo "   add sql stored procedures"
    (mysql -h$MYSQL_HOST -u$MYSQL_ENV_MYSQL_ROOT_USER -p$MYSQL_ENV_MYSQL_ROOT_PASSWORD mysql < /var/www/html/sites/all/modules/custom/webfact/external_db/ext_db.sql)

  else 
    echo "-- no MYSQL_ENV_MYSQL_ROOT_PASSWORD specified, the following steps must be manually done, see https://github.com/Boran/webfact/tree/master/external_db  "
    echo "   1. Create a user $WEBFACT_MANAGE_DB_USER in the DB "
    echo "   2. load the stored procedures and grant access."
    echo "   3. Ensure this webfact container has writeable access to the /opt/sites volume"
    echo "   See also http://thisserver/admin/config/development/webfact"
  fi
fi

if [ "$WEBFACT_API" == "1" ] ; then 
  drush vset -q webfact_container_api 1
  echo "** mesos **"

else 
  echo "-- Webfact will manage containers via the Docker API:  "
  echo "-- New containers: create volume dirs for data persistence"
  drush vset webfact_data_volume 1
  drush vset webfact_www_volume 1

  ## todo: env variables?
  echo "   For vanilla test website: create /opt/sites/vanilla"
  sudo mkdir -p /opt/sites/vanilla/www /opt/sites/vanilla/data
  sudo chown -R www-data /opt/sites/vanilla
  echo "   Ensure webui can access /var/run/docker.sock"
  sudo chown www-data /var/run/docker.sock;
  #sudo usermod -aG docker www-data
fi

echo "clear caches"
drush -y cache-clear drush

echo "-- git settings"
git config --global push.default matching

# todo: why is this needed?
mkdir /var/lib/drupal-private 2>/dev/nell
chown -R www-data /var/lib/drupal-private


echo "---- Done $1 from webfact-make ----"

