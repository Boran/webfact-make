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
  Select Websites > Vanilla > Meta data:
  title=vanilla  
  hostname=vanilla
  template=Plain Drupal7 (default)
  advanced > docker ports = 80:8001
  "save"

* Create the container:
  Manage > Create

* Wait 3 minutes as Drupal installs. Follow progress via Manage > Docker Logs.

* Visit the new website
  http://localhost:8001  



Note: outgoing proxies
----------------------
If your network needs outgoing proxies, enable and adapt the proxy lines in Vagrantfile and docker-compose/docker-compose.yml

  
Notes: Wild card Dns (on mac)
---------------------
* Install dnsmasq (via macports)
* Add /opt/local/etc/dnsmasq.conf
  address=/.docker/127.0.0.1
  killall dnsmasq
* Add dnsmasq as a resolver for *.docker
  mkdir -v /etc/resolver
  echo "nameserver 127.0.0.1" > /etc/resolver/docker
  sudo killall mDNSResponder
* check DNS 
  scutil --dns
  ...resolver #8
    domain   : docker
    nameserver[0] : 127.0.0.1
  nslookup webfact.docker

* Start nginx container
  docker-compose up -d nginx
* Connect to the Webfactory UI routed though nginx:
  http://webfact.docker
* Connect to the Webfactory subsite "vanilla" routed though nginx:
  http://VANILLA.webfact.docker

  
TODO
----
Prio #1

* dns wilcard+nginx-proxy: Dnsmasq and dns routing working fine on OSX 10.10, e.g. ping x.webfact.docker resolves to localhost. However the web browser does not respect this resolution and lookups up foreign dns server, not dnsmasq locally.

* proxies: the Install of the Vm, docket+tools works, but not yet the automated install of the webfact container. Running the docker composer by hadn after works fine.

Prio #2

* explain how the vagrant file works (ports mapped, etc.)
* document docker composer usage
* Add a boran/jenkins build container to docker-compose?

