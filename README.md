Automation for building a the webfactory UI

Installation
----------------------------------------------
First install a boran/drupal docker container 


# remove any old traces
\rm -rf /var/www/html
echo "drop database drupal" |mysql
echo "create database drupal; grant all on drupal.* to drupal" |mysql

# get and execute the make file: download all modules
drush make https://raw.githubusercontent.com/Boran/webfact-make/master/webfact-make.make /var/www/html

# create directories
mkdir -p  /var/www/html/sites/default/files /var/www/html/sites/all/libraries/composer /var/lib/drupal-private
chown -R www-data /var/www/html/sites/default /var/www/html/sites/all /var/lib/drupal-private

# run the install profile
export MYSQL_PASSWORD=`cat /drupal-db-pw.txt`
export YOUREMAIL="you@example.com"
(cd /var/www/html/sites/default &&  drush site-install webfactp -y --account-name=admin --account-pass=changeme --account-mail=$YOUREMAIL --site-name=webfacty --site-mail=$YOUREMAIL  --db-url="mysqli://drupal:${MYSQL_PASSWORD}@localhost:3306/drupal" )

# manual step: download composer components
(cd /var/www/html; drush -y composer-manager install)
# theme TPL
(cd /var/www/html/sites/all/themes/contrib/bootstrap; ln -s /var/www/html/sites/all/modules/custom/webfact/views-view-field--websites.tpl.php views-view-field--websites.tpl.php)


# Done: go to the website page and log ad admin/changeme


TO DO
-----
Full automate
- automate composer:
  (cd /var/www/html; drush -y composer-manager install)
- link theme tpl
- term: category
  - admin/structure/taxonomy/category: add 'test' and 'production'
  - admin/structure/types/manage/website/fields: set default template+category

low prio:
- menu order
- Theme
  admin/appearance/settings: hide the site slogan, set the logo to Factory150.jpg
  admin/structure/block : disable the search+navigation blocks
- Webfactory
  - admin/structure/block: enable the myWebsites into the content zone, only for the listed pages 'user', 'user/*'
  - admin/config/development/webfact: set the URL for the docker host and domain prefix
  - node/add: add a template (better: use node export from an existing site)
- Login and change the admin password.
- Permissions: 
  - the Site Owner role should be able to create new, edit own and delete own 'website' content. Assign this role of users who need to create websites.
  - the Administrator role should have all rights on the Website/Template content types and Webfactory UI.
- admin/config/system/backup_migrate 
  . create a directory /data/backup_migrate and set the owner to www-data
  . Create a Schedule "daily" with default settings
  . Change the destination "Scheduled Backups Directory" to /data/backup_migrate
  . Override Settings > Settings profiles > Default > Override > Advanced: enable 'Send an email if backup succeeds'
  . Do an example backup
Optional: 
  . enable the contact module, and a contact page/menu.


Later:
# manually: enable feature
 'Attempt to create field name <em class="placeholder">field_image</em> which already exists and is       [error]
active.' in /var/www/html/modules/field/field.crud.inc:85


Early days yet..
