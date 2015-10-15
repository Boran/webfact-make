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
  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http     = "http://proxy.vptt.ch:80/"
    config.proxy.https    = "http://proxy.vptt.ch:80/"
    #config.proxy.ftp      = "http://proxy.example.ch:80/"
    config.proxy.no_proxy = "localhost,127.0.0.1,.docker,webfact.docker"
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

  # For the nginx reverse proxy, try to grab the default http port 80/443
  # MAC: Vagrant cannot fwd ports below 1024 (unix limitation)
  #   for Mac 10.10, see http://salvatore.garbesi.com/vagrant-port-forwarding-on-mac/
  #   and https://github.com/emyl/vagrant-triggers
  # so first, map 8080,8443 in vagrant
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 8443, host: 8443
  # then portmap 80 > 8080, 443->8443
  if Vagrant.has_plugin?("vagrant-triggers")
    config.trigger.after [:provision, :up, :reload] do
      system('echo "
rdr pass on lo0 inet proto tcp from any to 127.0.0.1 port 80 -> 127.0.0.1 port 8080  
rdr pass on lo0 inet proto tcp from any to 127.0.0.1 port 443 -> 127.0.0.1 port 8443  
" | sudo pfctl -f - > /dev/null 2>&1; echo "==> Fowarding Ports: 80 -> 8080, 443 -> 8443"')  
    end

    # remove port fwd when not needed
    config.trigger.after [:halt, :destroy] do
      system("sudo pfctl -f /etc/pf.conf > /dev/null 2>&1; echo '==> Removing Port Forwarding'")
    end
  end

  # Provider-specific configuration for VirtualBox
  config.vm.provider "virtualbox" do |vb|
    # Setting teh hostname can be useful
    #vb.name = "webfact-vm"
    # Increase these resources for many containers
    vb.memory = "1024"
    #vb.cpus = 2
    # do not allow the VM to hog too many resources
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
  end

  # Run provisioning script
  config.vm.provision "shell", path: "vagrant.sh"

end

