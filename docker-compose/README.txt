
Example docker-compose file to create containers for the Webfactory
Requires: docker > 1.8
Status: alpha

See the doc in vagrand.md for more details.
Vagrant.sh also contains a few lines for creating folder, setting permissions and downloading the default nginx-gen template.

Using
-----

 - First, install a (Ubuntu) VM with docker, docker-compose.
 - Clone this repo https://github.com/Boran/webfact-make.git.

 - Create folders (This is already done if you used "vagrant up")
   - Create sites folders on the docker server.
     mkdir -p /opt/sites/nginx /opt/sites/webfact
     chown -R www-data /opt/sites
   - Allow the apache user access to docker operations
     sudo usermod -aG docker www-data 

 - Optional: edit the compose file change the lines with "adapt" in the comments, e.g. domain names
   cd webfact-make/docker-compose
   vi docker-compose.yml

 - Build and start the main webfact_1 container:
   docker-compose up -d webfact
 - Then connect to http://VMIP:8000 for the webfactory UI  (VMIP is the IP of the VM running docker)

Notes
 - change the label com.example to your company name
 - Containers are named explicity, since for example nginx-gen has to talk to ngnix


Dynamic reverse proxy
--------------------
```
docker-compose up -d nginx nginx-gen
# verify that docker-gen has created a config, review it, there should be an entry for webfact.docker
docker logs nginx-gen
sudo more /opt/sites/nginx/conf/default.conf

# start the vanilla container, then review default.conf to verify the vanilla.docker entries
docker start vanilla
sudo more /opt/sites/nginx/conf/default.conf

# look at the nginx activity
```

