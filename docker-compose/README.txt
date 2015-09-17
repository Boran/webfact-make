
Example docker-compose file to create containers usually need for the Webfactory
Requires: docker > 1.8
Status: alpha

See automated variant in vagrand.md.

Using
-----
First, install a (Ubuntu) VM with docker, docker-compose, clone this repo https://github.com/Boran/webfact-make.git.

 - Optional: edit the compose file change the lines with "adapt" in the comments, e.g. domain names
   cd webfact-make/docker-compose
   vi docker-compose.yml
 - Create sites folders on the docker server
   mkdir -p /opt/sites/nginx /opt/sites/webfact
   chown -R www-data /opt/sites
 - Allow the apache user access to docker operations
   sudo usermod -aG docker www-data 
 - Build and start the main webfact_1 container:
   docker-compose up webfact
 - Then connect to http://VMIP:8000 for the webfactory UI  (VMIP is the IP of the VM running docker)

Notes
 - change the label com.example to your company name
 - Containers are named explicity, since for example nginx-gen has to talk to ngnix

TODO
----
prio 1
- Simple reverse proxy (no SSL)
- more testing

prio 2
- why does docker-compose need to be sent into the background?

Document advanced usage, e.g.. Run all, i.e. with the nginx frontend:
 - Put and configure ssl keys and nginx-template file somewhere, e.g in the yml file we assume
   /root/inno-drupal/sslkeys /root/inno-drupal/nginx-templates
 - create a DNS wildcard pointing *.webfact.yourdomain.com to the server
 - start containers
   docker-compose up webfact
 - Connect to http://webfact.yourdomain.com and https://webfact.yourdomain.com
