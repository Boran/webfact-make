Automate webfactory installation via Vagrant

Introduction
------------

The Vagrantfile allows automated installation of a Ubuntu VM 14.04 with docker, docker-compose and from which webfact containers can be run.
Requirements: Vagrant + a provider such as virtualbox, outgoing internet connectivity.

Initial install
---------------
* Install Virtualbox and Vagrant.
* Clone the webfact-make repository and change to that directory
* Install:
  vagrant up
* connect to for the Webfactory UI , login as admin/admin
  http://localhost:8000 

First website
* Add a new test website 
  title=vanilla  
  hostname=vanilla
  template=plain drupal7 (default)
  advanced > docker ports = 80:8001
  "save"
* Create the container
  Manage > Create
* Visit the new website
  http://localhost:8000  
  
  
TODO
----
More to come, 
* e.g. using simple nginx proxy variant  with *.local DNS wildcard using dnsmasq
* Also explain how the vagrant file works
* document docker composer.
* Maybe add a jenkins build container to docker-compose?
