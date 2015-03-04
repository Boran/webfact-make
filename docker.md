
Installing docker on Ubuntu 14.04
---------------------------------
```
apt-get update
apt-get -qy install apt-transport-https linux-image-extra-`uname -r`
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
echo deb https://get.docker.io/ubuntu docker main\ > /etc/apt/sources.list.d/docker.list
apt-get update -yq

# install a specific version
#apt-get install -yq lxc-docker-1.4.1
# install the latest:
apt-get install -yq lxc-docker
```

