Automation of a Webfactory build

Install on a bse boran/druapl dcoker container:
----------------------------------------------
export DRUPAL_INSTALL_PROFILE=webfactp
export MYSQL_PASSWORD=yohg1Ohloope

tar cvzf webfactp.tgz webfactp
\rm -rf /var/www/html
echo "drop database drupal" |mysql
echo "create database drupal; grant all on drupal.* to drupal" |mysql

drush make webfact-make.make /var/www/html
mkdir -p  /var/www/html/sites/default/files /var/www/html/sites/all/libraries/composer /var/lib/drupal-private
chown -R www-data /var/www/html/sites/default /var/www/html/sites/all /var/lib/drupal-private

(cd /var/www/html/sites/default &&  drush site-install ${DRUPAL_INSTALL_PROFILE} -y --account-name=admin --account-pass=changeme --account-mail=sboran@vptt.ch --site-name=webfacty --site-mail=sboran@vptt.ch  --db-url="mysqli://drupal:${MYSQL_PASSWORD}@localhost:3306/drupal" )

(cd /var/www/html; drush -y composer-manager install)


to do:
- link theme tpl
- automate composer:
  (cd /var/www/html; drush -y composer-manager install)

low prio:
- term: category: production/test
- menu order


Later:
# manually: enable feature
 'Attempt to create field name <em class="placeholder">field_image</em> which already exists and is       [error]
active.' in /var/www/html/modules/field/field.crud.inc:85

