Automated building/testing with Jenkins
----------------------------------------
Create a "jenkins2" container based on the boran/jenkins image, with environment VIRTUAL_PORT=8080, volume /var/run/docker.sock:/run/docker.sock:rw, and port 8080:8070. Start the container and install docker via the command line. Add jenkins to the docker group (so it can read the docker socket: usermod -a -G  docker jenkins).

Connect to jenkins http://yourhost.example:8070.
Create a job that watches the Webfact repos on git, and executes an shell to run the following build script.
```
date

echo "-- load settings "
name=webfactci
domain=$name.webfact.example.ch
email=yourname@example.ch
image="boran/drupal"
port=8099

echo "--- grab the latest image from docker hub"
docker pull boran/drupal

sh -c "docker stop $name 2>/dev/null; docker rm $name 2>/dev/null; echo '-- clean old container'"

echo "--- create and start $name docker container "
docker run -td -p $port:80 -e "VIRTUAL_HOST=$domain" -v /var/run/docker.sock:/var/run/docker.sock -e "DRUPAL_SITE_NAME=WebFactory build" -e "DRUPAL_ADMIN_EMAIL=$email" -e "DRUPAL_SITE_EMAIL=$email" -e "DRUPAL_MAKE_REPO=https://github.com/Boran/webfact-make" -e "DRUPAL_MAKE_DIR=webfact-make" -e DRUPAL_INSTALL_PROFILE=webfactp -e DRUPAL_FINAL_CMD="chown www-data /var/run/docker.dock; cd /var/www/html; drush dl -y composer-8.x-1.x; drush -y composer-manager install;"  -e "VIRTUAL_HOST=$domain" --restart=always --hostname $domain --name $name $image

date
echo "-- wait 3mins and hope the build is done"
sleep 180
date

echo "-- show the docker logs"
docker logs --tail --timestamps $name

echo "-- complete, you can now connect to http://$domain:$port"

# todo: how do we know when its really done

# Run some tests
# Does the site respond, is some expected text there?
curl --silent -o - http://$domain:$port/ | grep  -c "The webfactory allows"
```
Optionally 
 * Job: enable SCM (git) polling and email notification.
 * Configure the SMTP server (under manage jenkins)

Todo: add some real tests.
