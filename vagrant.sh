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

echo "---- install curl, extras for aufs  -----"
apt-get update -yq
apt-get -yqq install apt-transport-https linux-image-extra-`uname -r` curl



echo "---- install docker-compose -----"
curl -sSL https://github.com/docker/compose/releases/download/1.4.0/docker-compose-`uname -s`-`uname -m` > /tmp/docker-compose
mv /tmp/docker-compose /usr/local/bin/docker-compose
chmod 755 /usr/local/bin/docker-compose

echo "---- install docker -----"
if [ ! -z "http_proxy" ]; then
  # Some parts of the docker install don't work with proxies
  echo "Proxies enabled: for keyserver "
  apt-key adv --keyserver-options http-proxy=$http_proxy --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
fi
curl -sSL https://get.docker.com/ | sh
if [ ! -z "http_proxy" ]; then
  echo "Proxies enabled: for docker daemon "
  echo "export https_proxy=$https_proxy" >> /etc/default/docker
fi
restart docker
docker --version

echo "--------------------------"
echo "---- permissions -----"
mkdir -p /opt/sites/nginx /opt/sites/webfact/www /opt/sites/webfact/data
chown -R www-data /opt/sites /var/run/docker.sock

echo "---- environment -----"
locale-gen UTF-8
git config --global push.default matching
echo "---- Set VM name to webfact-vm --"
sudo hostname webfact-vm
echo webfact-vm > /etc/hostname

echo "---- Install webfactory container via docker-compose  -----"
cd /vagrant/docker-compose/
docker-compose up -d webfact
#docker-compose up -d nginx
echo "---- provisioning done `date +%Y%m%d` ----- "
echo "     Connect to the  Webfact UI in 2-3 minutes: http://localhost:8000 or https://localhost:8443"
#echo "  For nginx reverse proxy, add webfact.local as an alias to 127.0.0.1 in /etc/hosts, then connect to http://webfact.local:9000"

