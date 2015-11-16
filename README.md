Webfact-make: Automation for building a Webfactory UI

The Webfactory provides a UI to interface to the Docker API, allowing operations on containers/images. It aims to streamline dev and operations for Drupal websites. See also https://github.com/Boran/webfact.

Containers can also managed on a Mesos cluster via Marathon and bamboo (experimental).

The Webfactory consists of several modules: webfact (main logic), webfact_content_types (features/views), webfact-make (build/install), webfact_theme (styling), webfactapi (optional remote control).

You need:
  Docker server (e.g. Ubuntu 14.04) with docker 1.7 or later
  Mysql and drupal container for the webfactory (e.g. the "boran/drupal" container)
  THe webfact modules listed above.
  Some Drupal contrib modules and the Bootstrap theme.


Installation: Vagrant (easiest)
---------------------
See the vagrant.md document for an automated install of a local VM with docker+webfactory. This is the recommended way to get going.


Installation: using docker-compose
----------------------------------
We assume you have docker installed (see docker.md) and know how to use it.

The docker-compose tool can be used to install the webfactory container. It is also used as part of the vagrant automation.


Installation: With Mesos rather than docker
-------------------------------------------
The Webfactory can also manage container on a Mesos cluster via Marathon and Bamboo APIs. Set WEBFACT_API=1 when installing the container. Installation via vagrant or docker-compose has not been implemented for this scenario. See [mesos.md in the webfact repo](https://github.com/Boran/webfact/blob/mesos/mesos.md). 


Installation: using a drush makefile and the boran/drupal image
-----------------------------------------------------------------------
We assume you have docker installed (see docker.md) and know how to use it.

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

# incase you already had a webfact
docker stop $name; docker rm $name;

docker run -td -p $port:80 -v /var/run/docker.sock:/var/run/docker.sock -v /opt/sites/$name:/data -v /opt/sites:/opt/sites -e "DRUPAL_SITE_NAME=WebFactory" -e "DRUPAL_ADMIN_EMAIL=$email" -e "DRUPAL_SITE_EMAIL=$email" -e "DRUPAL_MAKE_REPO=https://github.com/Boran/webfact-make" -e "DRUPAL_MAKE_DIR=webfact-make" -e DRUPAL_INSTALL_PROFILE=webfactp -e DRUPAL_FINAL_SCRIPT=/opt/drush-make/webfact-make/scripts/final.sh  -e "VIRTUAL_HOST=$domain" --restart=always --hostname $domain --name $name $image

# follow progress
docker logs -f $name
```

Installation done: go to the website page and log on as admin, password=admin and see the configuration section below.



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


Installation: /var/www/html from  your custom repo
-----------------------------------------------
Lets say you have installed a fresh Drupal and checked /var/www/html into your own repo. Assuming all required modules are available, one can install the container ba a) checking out your repo, running the webfact profile and final script, e.g.
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

docker run -td -p $port:80 -e "VIRTUAL_HOST=$domain" -v /var/run/docker.sock:/var/run/docker.sock -v /opt/sites/$name:/data -v /opt/sites:/opt/sites -e "DRUPAL_SITE_NAME=WebFactory" -e "DRUPAL_ADMIN_EMAIL=$email" -e "DRUPAL_SITE_EMAIL=$email" -e "DRUPAL_GIT_REPO=https://YOUR.GITREPO.COM/some/path" -e "DRUPAL_GIT_BRANCH=master" -e DRUPAL_INSTALL_PROFILE=webfactp -e DRUPAL_FINAL_SCRIPT=/var/www/html/profiles/webfactp/scripts/final.sh"  -e "VIRTUAL_HOST=$domain" --restart=always --hostname $domain --name $name $image
```
Notes: adapt DRUPAL_GIT_REPO and DRUPAL_GIT_BRANCH. Clone https://github.com/Boran/webfact-make.git/ into /var/www/html/profiles/webfactp. Adapt /var/www/html/profiles/webfactp/scripts/final.sh if you need to automated some settings when installing.


TO DO
-----
See the issues on github and specifically the meta #3: https://github.com/Boran/webfact-make/issues/3


Configuration (after installation)
----------------------------------
After installation a basic webfactory should be running, with one sample website and one template. 
Next steps:
* Login and change the admin password.
* Webfactory settings:
  admin/config/development/webfact: set the URL for the docker host, domain prefix and other settings
* menu order: put 'home' first (admin/structure/menu/manage/main-menu)
* Permissions: 
  - Assign the Site Owner role to users who need to create websites.
  - permissions: This role should be able to create new, edit own and delete own 'website' entities. You may wish to allow Site Owners to create and edit own Template entities.
  - Site Owners probably need teh 'Access websites" and otpionally 'Manage Containers'.
  - the Administrator role should have all rights on the Website/Template content types and Webfactory UI.

Optional configuration: 
* Webfactory
  - admin/structure/block: enable the myWebsites into the content zone, only for the listed pages 'user', 'user/*'
  - node/add: add more templates 
* Modules:
  - Enable node export. Now you can export/import templates from another Webfactory instance (see node/add/node_export)
* Backups
  . Enable the Backup/Migrate modules, and configure it - admin/config/system/backup_migrate 
  . In the settings tab, override the the manual and schedules directories to /data/backup_migrate/manual and /data/backup_migrate/scheduled
  . Create a Schedule "daily" with default settings
  . Override Settings > Settings profiles > Default > Override > Advanced: enable 'Send an email if backup succeeds'
  . Do a 'Backup now' with destination of Manual Backups Directory
* Contact: The contact form is already enabled as /contact. Set recipients under admin/structure/contact. Add it to the main menu after templates.

Using
-----
* Build a first Drupal website: 
  - Go to the websites menu > vanilla > Manage > create.  
  - It will take about 20 seconds and the 'built status' will reach 100. 
  - Go to Manage > Docker logs to follow progress.
  - Now, visit the new website that has been created? If the installation was done via Vagrant, go to http://http://localhost:8001. The website can be reached in several ways, mapping a port on the docker server to the new website, or using an nginx container to automatically map the port.
* So lets make the website visible by mapping a port
  - For the vanilla example, there is a mapping to poprt 8001. Go to Websites > vanilla > meta data, scroll down to advanced and open that section, see "80:9001" in the docker ports section. 
  - Back on the vanilla page, go to Advanced > Rebuild from sources. Wait 30 secs. 
  - Then go to http://127.0.0.1:8001/, replacing 127.0.0.1 with the IP of your docker server. You'll see the drupal front page and can login with user/passwd=admin/admin (the default for the boran/drupal docker image).
* From the vanilla page (website/advanced/3), experiment with the start/stop/logs commands in the manage menu.
* In the Advanced menu, checkout the Inspect and Run Command
* Try Advanced > 'Rebuild container', or 'Rebuild, wipe data'
* Now you've had a basic overview, enjoy the rest. (Feel free to submit a patch with additional doc :-)


