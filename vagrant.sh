#!/bin/bash

# What does this do?
# a) ConfigureUbuntu 14.04 VM to host docker containers
# b) Installs the webfgact container(s)
# Note:
# - expects to run as root/sudo

echo "------------ Install docker + tools ------------"

echo "---- docker group -----"
groupadd docker
usermod -aG docker vagrant
usermod -aG docker www-data

#echo "---- install curl, extras for aufs  -----"
#apt-get update -yq
#apt-get -yqq install apt-transport-https linux-image-extra-`uname -r` curl

echo "---- install docker-compose -----"
curl -sSL https://github.com/docker/compose/releases/download/1.4.0/docker-compose-`uname -s`-`uname -m` > /tmp/docker-compose
mv /tmp/docker-compose /usr/local/bin/docker-compose
chmod 755 /usr/local/bin/docker-compose

echo "---- install docker -----"
curl -sSL https://get.docker.com/gpg | sudo apt-key add -
curl -sSL https://get.docker.com/ | sh

echo "--------------------------"
docker --version

echo "--------------------------"
echo "---- permissions -----"
mkdir -p /opt/sites/webfact/www /opt/sites/webfact/data
chown -R www-data /opt/sites /var/run/docker.sock

mkdir -p /opt/sites/mysql/data

echo "-- download default nginx-gen temlate --"
mkdir -p /opt/sites/nginx/conf /opt/sites/nginx/certs
mkdir -p /opt/sites/nginx-gen/templates
(cd /opt/sites/nginx-gen/templates && curl -so nginx.tmpl https://raw.githubusercontent.com/jwilder/docker-gen/master/templates/nginx.tmpl)


## Optional stuff:
echo "---- environment: timezone/locale for Switzerland"
echo -e "\nLC_ALL=en_US.UTF-8" >> /etc/default/locale
locale-gen UTF-8 en_US en_US.UTF-8 de_CH de_CH.UTF-8
dpkg-reconfigure locales
echo "--- Timezone Europe/Zurich "
timedatectl set-timezone Europe/Zurich


# todo: if proxies are enabled, they have not yet been recognised by docker, so image download will fail 
#       Workaround: Run docker-compose from Vagrantfile, once this script has been executed.

echo "---- vagrant.sh provisioning done `date +%Y%m%d` ----- "

