Webfact-make: Automation for building a Webfactory UI

The Webfactory provides a UI to interface to the Docker API, allowing operations on containers/images. It aims to streamline dev and operations for Drupal websites. See also https://github.com/Boran/webfact

The Webfactory consists of several modules: webfact (main logic), webfact_content_types (features/views), webfact-make (build/install), webfact_theme (styling), webfactapi (optional remote control) and webfactory (deprecated: full site install)

You need:
  Docker server (e.g. Ubuntu 14.04) with docker 1.5 or later
  Container for the webfactory (e.g. the drupal lamp "boran/drupal" container)
  THe webfact modules listed above.
  Some Drupal contrib modules and the Bootstrap theme.


Installation: quickie using boran/drupal
----------------------------------------
We assume you have docker installed and know how to use it.

Setup a new container based on the boran/drupal image. The container called webfact points port 8020 on the docker host to it. It also makes the docker socket available in the container.
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

docker run -td -p $port:80 -e "VIRTUAL_HOST=$domain" -v /var/run/docker.sock:/var/run/docker.sock -e "DRUPAL_SITE_NAME=WebFactory" -e "DRUPAL_ADMIN_EMAIL=$email" -e "DRUPAL_SITE_EMAIL=$email" -e "DRUPAL_MAKE_REPO=https://github.com/Boran/webfact-make" -e "DRUPAL_MAKE_DIR=webfact-make" -e DRUPAL_INSTALL_PROFILE=webfactp -e DRUPAL_FINAL_CMD="chown www-data /var/run/docker.dock; cd /var/www/html; drush dl -y composer-8.x-1.x; drush -y composer-manager install;"  -e "VIRTUAL_HOST=$domain" --restart=always --hostname $domain --name $name $image

# follow progress
docker logs -f $name
```

Installation done: go to the website page and log as admin/admin and see the configuration section below.


Installation: step by step
---------------------------
Lets install step by step to better understand (or if the quickie section above did not work for you).
First install a boran/drupal docker container.  This will setup vanilla drupal and point port 8020 on the docker host to it. It also makes the docker socket available in the container.
```
# grab the latest image
docker pull boran/drupal
 
# create a webfact container (adapt name/email)
name=webfact
domain=$name.example.ch
email=bob@example.ch
image="boran/drupal"
docker run -td -p 8020:80 -e "VIRTUAL_HOST=$domain" -v /var/run/docker.sock:/var/run/docker.sock -e "DRUPAL_SITE_NAME=WebFactory" -e "DRUPAL_ADMIN_EMAIL=$email" -e "DRUPAL_SITE_EMAIL=$email" --restart=always --hostname $domain --name $name $image
```

Now connect into the container (via "docker exec -it webfact bash"), remove any previous DB or code. You could also start from this step if not using the boran/drupal container.
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
mkdir -p /var/www/html/sites/default/files /var/www/html/sites/all/libraries/composer /var/lib/drupal-private
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
chown www-data /var/run/docker.dock;
```


Installation done: go to the website page and log as admin/admin and see the configuration section below.


TO DO
-----
See the issues on github and specifically the meta #3: https://github.com/Boran/webfact-make/issues/3


Configuration (after installation)
----------------------------------
Login and change the admin password.
* Webfactory
  admin/config/development/webfact: set the URL for the docker host, domain prefix and other settings

* Theme
  admin/appearance/settings: hide the site slogan, set the logo to Factory150.jpg
  admin/structure/block : disable the navigation blocks
* menu order
* Webfactory
  - admin/structure/block: enable the myWebsites into the content zone, only for the listed pages 'user', 'user/*'
  - admin/config/development/webfact: set the URL for the docker host and domain prefix
  - node/add: add a template (better: use node export from an existing site)
* Login and change the admin password.
* Permissions: 
  - the Site Owner role should be able to create new, edit own and delete own 'website' content. Assign this role of users who need to create websites.
  - the Administrator role should have all rights on the Website/Template content types and Webfactory UI.
Optional: 
* admin/config/system/backup_migrate 
  . create a directory /data/backup_migrate and set the owner to www-data
  . Create a Schedule "daily" with default settings
  . Change the destination "Scheduled Backups Directory" to /data/backup_migrate
  . Override Settings > Settings profiles > Default > Override > Advanced: enable 'Send an email if backup succeeds'
  . Do an example backup
  . enable the contact module, and a contact page/menu.

Using
-----
Todo: add a walkthough on create templates and websites and operations on websites.


