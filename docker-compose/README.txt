
Example docker-compose file to create the 3 containers usually need for the Webfactory

Requires: docker > 1.8

Usage
 - edit the compose file
 - change the lines with "adapt" in the comments, e.g. domain names
 - Create sites folders on the docker server
   mkdir -p /opt/sites/nginx /opt/sites/webfact
 - Build and start the webfact container on its own:
   docker-compose up webfact
 - Then connect to http://yourhost.com:8000 for the webfactory UI

 Run all, i.e. with the nginx frontend:
 - Put and configure ssl keys and nginx-template file somewhere, e.g in the yml file we assume
   /root/inno-drupal/sslkeys /root/inno-drupal/nginx-templates
 - crate a DNS wildcard pointing *.webfact.yourdomain.com to the server
 - start containers
   docker-compose up webfact
 - Connect to http://webfact.yourdomain.com and https://webfact.yourdomain.com

 Notes
 - change the label com.example to your company name
 - Containers are named explicity, since nginx-gen has to talk to ngnix for example

TODO
- more testing
- why does docker-compose need to be sent into the background?


