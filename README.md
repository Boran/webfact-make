Automation for building a Webfactory UI

Installation: step by step
----------------------------------------------
First install a boran/drupal docker container.  This will setup vanilla drupal and point port 8000 on the docker host to it. It also makes the docker socket available in the container.
```
# grab the latest image
docker pull boran/drupal
 
# create a webfact container (adapt name/email)
name=webfact
domain=$name.example.ch
email=bob@example.ch
image="boran/drupal"
docker run -td -p 8000:80 -e "VIRTUAL_HOST=$domain" -v /var/run/docker.sock:/var/run/docker.sock -e "DRUPAL_SITE_NAME=WebFactory" -e "DRUPAL_ADMIN_EMAIL=$email" -e "DRUPAL_SITE_EMAIL=$email" --restart=always --hostname $domain --name $name $image
```

Now connect into the container (via nsenter or docker exec), remove any previous DB or code. You could also start from this step if not using the boran/drupal container.
```
\rm -rf /var/www/html
echo "drop database drupal" |mysql
echo "create database drupal; grant all on drupal.* to drupal" |mysql
```

Get and execute the make file: download all modules
```
drush make https://raw.githubusercontent.com/Boran/webfact-make/master/webfact-make.make /var/www/html
```

Create directories
```
mkdir -p  /var/www/html/sites/default/files /var/www/html/sites/all/libraries/composer /var/lib/drupal-private
chown -R www-data /var/www/html/sites/default /var/www/html/sites/all /var/lib/drupal-private
```

Run the install profile
```
MYSQL_PASSWORD=`cat /drupal-db-pw.txt`
YOUREMAIL="bob@example.ch"
sitename="webfact"
(cd /var/www/html/sites/default &&  drush site-install webfactp -y --account-name=admin --account-pass=changeme --account-mail=$YOUREMAIL --site-name=$sitename --site-mail=$YOUREMAIL  --db-url="mysqli://drupal:${MYSQL_PASSWORD}@localhost:3306/drupal" )
```

Manual step: download composer components
```
(cd /var/www/html; drush dl -y composer-8.x-1.x; drush -y composer-manager install)
# theme TPL
(cd /var/www/html/sites/all/themes/contrib/bootstrap; ln -s /var/www/html/sites/all/modules/custom/webfact/views-view-field--websites.tpl.php views-view-field--websites.tpl.php; drush cc all)
```


Done: go to the website page and log as admin/changeme


Installation: quickie using boran/drupal
----------------------------------------------
Do everything from the boran/drupal docker container.  This will setup a container called webfact point port 8000 on the docker host to it. It also makes the docker socket available in the container.
```
# grab the latest image
docker pull boran/drupal

# create a webfact container
name=webfact
domain=$name.example.ch
email=bob@example.ch
image="boran/drupal"
port=8020

docker stop $name;
docker rm $name;

docker run -td -p $port:80 -e "VIRTUAL_HOST=$domain" -v /var/run/docker.sock:/var/run/docker.sock -e "DRUPAL_SITE_NAME=WebFactory" -e "DRUPAL_ADMIN_EMAIL=$email" -e "DRUPAL_SITE_EMAIL=$email" -e "DRUPAL_MAKE_REPO=https://github.com/Boran/webfact-make" -e "DRUPAL_MAKE_DIR=webfact-make" -e DRUPAL_INSTALL_PROFILE=webfactp -e DRUPAL_FINAL_CMD="cd /var/www/html; drush dl -y composer-8.x-1.x; drush -y composer-manager install; cd sites/all/themes/contrib/bootstrap; ln -s /var/www/html/sites/all/modules/custom/webfact/views-view-field--websites.tpl.php views-view-field--websites.tpl.php;" -e "VIRTUAL_HOST=$domain" --restart=always --hostname $domain --name $name $image


# follow progress
docker logs -f $name
```

To do on this oneline: feature not installed?


TO DO
-----
Full automate
* automate composer:
  (cd /var/www/html; drush -y composer-manager install)
* link theme tpl
* term: category
  * admin/structure/taxonomy/category: add 'test' and 'production'
  * admin/structure/types/manage/website/fields: set default template+category

low prio:
* hide search blcok
* enable page caching
* menu order
* Theme
  admin/appearance/settings: hide the site slogan, set the logo to Factory150.jpg
  admin/structure/block : disable the search+navigation blocks
* Webfactory
  - admin/structure/block: enable the myWebsites into the content zone, only for the listed pages 'user', 'user/*'
  - admin/config/development/webfact: set the URL for the docker host and domain prefix
  - node/add: add a template (better: use node export from an existing site)
* Login and change the admin password.
* Permissions: 
  - the Site Owner role should be able to create new, edit own and delete own 'website' content. Assign this role of users who need to create websites.
  - the Administrator role should have all rights on the Website/Template content types and Webfactory UI.
* admin/config/system/backup_migrate 
  . create a directory /data/backup_migrate and set the owner to www-data
  . Create a Schedule "daily" with default settings
  . Change the destination "Scheduled Backups Directory" to /data/backup_migrate
  . Override Settings > Settings profiles > Default > Override > Advanced: enable 'Send an email if backup succeeds'
  . Do an example backup
Optional: 
  . enable the contact module, and a contact page/menu.


Later:
* manually: enable feature
 'Attempt to create field name <em class="placeholder">field_image</em> which already exists and is       [error]
active.' in /var/www/html/modules/field/field.crud.inc:85


Early days yet..
