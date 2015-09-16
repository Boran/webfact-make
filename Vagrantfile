# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Automate installation of a Uuntu VM, with docker+tools and webfact and nginx proxy container.
# USAGE: see vagrant.md
#

# The "2" in Vagrant.configure configures the configuration version 
Vagrant.configure(2) do |config|

  # See also https://docs.vagrantup.com.
  config.vm.box = "ubuntu/trusty64"
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. 
  config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080
  # Forward 6 ports for the Webfactory UI and 5 containers:
  config.vm.network "forwarded_port", guest: 8443, host: 8443
  config.vm.network "forwarded_port", guest: 8000, host: 8000
  config.vm.network "forwarded_port", guest: 8001, host: 8001
  config.vm.network "forwarded_port", guest: 8002, host: 8002
  config.vm.network "forwarded_port", guest: 8003, host: 8003
  config.vm.network "forwarded_port", guest: 8004, host: 8004
  config.vm.network "forwarded_port", guest: 8005, host: 8005
  # For the nginx-proxy
  config.vm.network "forwarded_port", guest: 9000, host: 9000

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  # When working on the Drupal image:
  #config.vm.synced_folder "../docker-drupal", "/docker-drupal"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #   vb.memory = "1024"
  # end
  #

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL
  config.vm.provision "shell", inline: <<-SHELL
     # Install curl, docker, docker-compose:
     echo "---- install curl, extras for aufs  -----"
     sudo locale-gen UTF-8
     sudo apt-get update -yq
     sudo apt-get -yqq install apt-transport-https linux-image-extra-`uname -r` curl

     echo "---- install docker-compose -----"
     curl -sSL https://github.com/docker/compose/releases/download/1.4.0/docker-compose-`uname -s`-`uname -m` > /tmp/docker-compose
     sudo mv /tmp/docker-compose /usr/local/bin/docker-compose 
     sudo chmod 755 /usr/local/bin/docker-compose

     echo "---- install docker -----"
     curl -sSL https://get.docker.com/ | sh
     docker --version

     echo "---- permissions -----"
     sudo usermod -aG docker vagrant
     sudo usermod -aG docker www-data
     sudo mkdir -p /opt/sites/nginx /opt/sites/webfact/www /opt/sites/webfact/data
     sudo chown -R www-data /opt/sites /var/run/docker.sock

     #echo "---- Install webfactory container via docker-compose  -----"
     cd /vagrant/docker-compose/
     sudo docker-compose up -d webfact
     #sudo docker-compose up -d nginx
     echo "---- provisioning done `date +%Y%m%d` ----- "
     echo "     Connect to the  Webfact UI in 2-3 minutes: http://localhost:8000 or https://localhost:8443"
     #echo "  For nginx reverse proxy, add webfact.local as an alias to 127.0.0.1 in /etc/hosts, then connect to http://webfact.local:9000"
  SHELL

end

