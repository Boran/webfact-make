# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Automate installation of a Ubuntu VM, with docker+tools and webfact container.
#
# USAGE: see vagrant.md
# See also https://docs.vagrantup.com, 
#     provider-specific configuration for VirtualBox
#     https://docs.vagrantup.com/v2/virtualbox/configuration.html
########

# The "2" in Vagrant.configure configures the configuration version 
Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/trusty64"
  # Disable automatic box update checking. 
  # Boxes can be checked for updates with `vagrant box outdated`. 
  config.vm.box_check_update = false

  # Proxies: 
  if ENV['http_proxy'] and Vagrant.has_plugin?("vagrant-proxyconf") 
    config.proxy.http     = ENV.fetch('http_proxy')
    if ENV['https_proxy']
      config.proxy.https    = ENV.fetch('https_proxy')
    end
    if ENV['no_proxy']
      config.proxy.no_proxy = ENV.fetch('no_proxy')
    end
  end

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. 
  # Forward the Webfactory UI and prepare for 5 website containers:
  config.vm.network "forwarded_port", guest: 8000, host: 8000
  config.vm.network "forwarded_port", guest: 8001, host: 8001
  config.vm.network "forwarded_port", guest: 8002, host: 8002
  config.vm.network "forwarded_port", guest: 8003, host: 8003
  config.vm.network "forwarded_port", guest: 8004, host: 8004
  config.vm.network "forwarded_port", guest: 8005, host: 8005


  # Option: use a reverse proxy to access websites by name and not by port number
  # so first, map 8080,8443 in vagrant (for nginx proxy)
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 8443, host: 8443

  # Option above: grab the default http port 80/443
  # MAC: Vagrant cannot fwd ports below 1024 (unix limitation)
  #   for Mac 10.10, see http://salvatore.garbesi.com/vagrant-port-forwarding-on-mac/
  #   and https://github.com/emyl/vagrant-triggers
  # so portmap 80 > 8080, 443->8443
  # >> uncomment he ffoling standza for mac 10.10, if you wish to bind to port 80
  #if Vagrant.has_plugin?("vagrant-triggers")
  #  config.trigger.after [:provision, :up, :reload] do
  #    system('echo "
#rdr pass on lo0 inet proto tcp from any to 127.0.0.1 port 80 -> 127.0.0.1 port 8080  
#rdr pass on lo0 inet proto tcp from any to 127.0.0.1 port 443 -> 127.0.0.1 port 8443  
#" | sudo pfctl -f - > /dev/null 2>&1; echo "==> Fowarding Ports: host 80 -> host 8080, 443 -> 8443"')  
  #  end

  #  # remove port fwd when not needed
  #  config.trigger.after [:halt, :destroy] do
  #    system("sudo pfctl -f /etc/pf.conf > /dev/null 2>&1; echo '==> Removing Port Forwarding'")
  #  end
  #end

  # Provider-specific configuration for VirtualBox
  config.vm.provider "virtualbox" do |vb|
    # Increase these resources if many containers
    vb.memory = "1024"
    #vb.cpus = 2
    # do not allow the VM to hog too many resources
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
    # Setting the hostname can be useful
    #vb.name = "webfact-vm"
  end

  # Run provisioning script
  config.vm.provision "shell", path: "vagrant.sh"

  # Create containers
  config.vm.provision "shell", inline: "cd /vagrant/docker-compose && docker-compose up -d mysql"
  config.vm.provision "shell", inline: "cd /vagrant/docker-compose && docker-compose up -d webfact"
  config.vm.provision "shell", inline: "echo 'Connect to the  Webfact UI in about 5 minutes http://localhost:8000, or logon with <vagrant ssh> and do <docker logs webfact> to see the progress of the Webfactory installation' "

  #config.vm.provision "shell", inline: "cd /vagrant/docker-compose && docker-compose up -d nginx nginx-gen"
  #config.vm.provision "shell", inline: "echo 'To use the  nginx reverse proxy, configure DNS as noted in vagrant.md and then connect to http://webfact.docker' "

end

