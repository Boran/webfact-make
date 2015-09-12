Automate webfactory installation via Vagrant

Introduction
------------

The Vagrantfile allows automated installation of a Uuntu VM 14.04, with docker, docker-compose from which webfact containers can be run.
Requirements: Vagrant + a provider such as virtualbox, outgoing internetz connectivity.

Initial install
---------------
* Install Virtualbox and Vagrant.
* Clone the webfact-make repository and change to that directory
* Install:
  vagrant up
* connect to for the Webfactory UI , login as admin/admin
  http://127.0.0.1:8000 

First website
* Add a new test website 
  title=vanilla  
  hostname=vanilla
  template=plain drupal7 (default)
  advanced > docker ports = 80:8001
  "save"
* Create the montainer
  Manage > Create
* Visit the new website
  http://127.0.0.1:8000  
  
  
TODO
----
More to come, e.g. using nginx..  
Also explain how the vagrant file works


