Automate webfactory installation via Vagrant

Introduction
------------

The Vagrantfile allows automated installation of a Ubuntu VM 14.04 with docker, docker-compose and from which webfact containers can be run.

Requirements: Vagrant + a provider such as virtualbox, outgoing internet connectivity.
Tested on: Mac 10.10, with Virtualbox 4.3.30 and Vagrant 1.7.4


Initial install
---------------

* Install Virtualbox and Vagrant.

* Clone the webfact-make repository and change to that directory

* Install:
  vagrant up

* Wait for 5 minutes, as the docker container is created and installed within the VM. To follow progress connect into the vm with "vagrant ssh" and follow the installation with "docker logs --follow webfact"

* Connect to the Webfactory UI, login as admin/admin to: http://localhost:8000 or https://localhost:8443

First website

* There should be one default template for drupal7, and one initial website Vanilla

* Modify Vanilla so that its port 80 is mapped to port 8001:
```
  Select Websites > Vanilla > Meta data:
  title=vanilla  
  hostname=vanilla
  template=Plain Drupal7 (default)
  advanced > docker ports = 80:8001
  "save"
```
* Create the container:
  Manage > Create

* Wait 3 minutes as Drupal installs. Follow progress via Manage > Docker Logs.

* Visit the new website
  http://localhost:8001  



Note: outgoing proxies
----------------------
If your network needs outgoing proxies, enable and adapt the proxy lines in Vagrantfile and docker-compose/docker-compose.yml

  
nginx reverse proxy + Wild card Dns
-----------------------------------
The following procedure in for a Mac (10.10). Both DNS and port mapping are setup within the OS.

* Install dnsmasq (via macports)
* Add /opt/local/etc/dnsmasq.conf
```
  vi /opt/local/etc/dnsmasq.conf
      address=/docker/127.0.0.1
  # reload:    
  sudo killall dnsmasq
```
* Add dnsmasq as a resolver for *.docker
```
  mkdir -v /etc/resolver
  echo "nameserver 127.0.0.1" > /etc/resolver/docker
  sudo killall mDNSResponder
```
* check DNS 
```
  scutil --dns
  ...resolver #8
    domain   : docker
    nameserver[0] : 127.0.0.1
    
  # check dnsmasq resolution
  nslookup webfact.docker localhost
  nslookup foo.webfact.docker localhost
  ping webfact.docker
  ping foo.webfact.docker
```  
  
* Install the vagrant plugin to allow firewall (pf) control
```  
vagrant plugin install vagrant-triggers 

# and enable the firewall
sudo pfctl -e

# Optional; look at firewall status:  
sudo pfctl -s all
# NAT rules: 
sudo pfctl -s nat
```  

* Start nginx containers 
```
cd docker-compose
docker-compose up -d nginx nginx-gen
```

* Connect to the Webfactory UI routed though pf, vagrant, nginx:
  http://webfact.docker
* Connect to the Webfactory subsite "vanilla" routed to the container with VIRTUAL_HOST=vanilla
  http://VANILLA.webfact.docker

  
TODO
----
Prio #1

* Proxies: the Install of the Vm, docker+tools works, but not the automated install of the webfact container. Running the "docker composer -d webfact" by hand within the vm "vagrant ssh" works fine. This is not a problem without proxies.
* Browser proxy: does not allow access to http://webfact.docker (Fine without proxies)

Prio #2

* explain more how the vagrant file works (ports mapped, etc.)
* document docker composer usage
* Add a boran/jenkins & cibuild container to docker-compose?
* nginx: add some certs, https example.


