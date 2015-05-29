
Installing docker on Ubuntu 14.04
---------------------------------
Install docker from the official Docker repo (not the docker.io from the Ubuntu repos)
```
apt-get update -yq
apt-get -qy install apt-transport-https linux-image-extra-`uname -r`
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
echo deb https://get.docker.io/ubuntu docker main\ > /etc/apt/sources.list.d/docker.list
apt-get update -yq

# install the latest:
apt-get install -yq lxc-docker

# Pull an example image and start a container.
sudo docker run -i -t ubuntu /bin/bash
```
If you are behind a forward proxy, add "http-proxy=http://myproxy.example.com:80" to the "apt-key adv" line above.

Install a specific version
```
apt-get install -yq lxc-docker-1.4.1
```

Upgrade docker
```
# First, note a list of running containers for reference.

apt-get update
apt-get install lxc-docker
reboot

# After: Be patient after the reboot, it make take a minute or two to start all containers. Check that expected containers auto-started.
```

Proxies: optional specify a forward proxy for docker to use when downloading
```
vi /etc/default/docker
export http_proxy="http://myproxy.example.com:80"
export https_proxy="http://myproxy.example.com:80"

restart docker
```

Reaching docker via TCP: to be able to run docker commands remotely via the network
 * Add "-H tcp://0.0.0.0:2375" to the options in /etc/default/docker
 * Consider configuring a local firewall to restrict access:
```
# see what ports already open
netstat -tan
 
# see https://docs.docker.com/installation/ubuntulinux/#docker-and-ufw
vi /etc/default/ufw
DEFAULT_FORWARD_POLICY="ACCEPT"
# open existing ports to anyone (i.e. as it was before the firewall)
sudo ufw allow 80
sudo ufw allow 22
sudo ufw allow 443
sudo ufw allow 53	
# e.g. localhost and docker containers to access the docker port
ufw allow from 127.0.0.1 to any port 2375
ufw allow from 172.17.0.0/16 to any port 2375
# enable the firewall
sudo ufw enable
```
