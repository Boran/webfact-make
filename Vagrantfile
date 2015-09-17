# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Automate installation of a Ubuntu VM, with docker+tools and webfact container.
# USAGE: see vagrant.md
########

# The "2" in Vagrant.configure configures the configuration version 
Vagrant.configure(2) do |config|

  # See also https://docs.vagrantup.com.
  config.vm.box = "ubuntu/trusty64"
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. 
  config.vm.box_check_update = false

  # Proxies: if you network requires outgoing access via a proxy
  # vagrant plugin install vagrant-proxyconf
  # http://tmatilai.github.io/vagrant-proxyconf/
  # updates /etc/profile.d/proxy.sh /etc/environment 
  # can override: VAGRANT_HTTP_PROXY="http://proxy.example.com:8080" vagrant up
  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http     = "http://proxy.example.ch:80/"
    config.proxy.https    = "http://proxy.example.ch:80/"
    #config.proxy.ftp      = "http://proxy.example.ch:80/"
    config.proxy.no_proxy = "localhost,127.0.0.1"
  end

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

  # Provider-specific configuration for VirtualBox
  # https://docs.vagrantup.com/v2/virtualbox/configuration.html
  config.vm.provider "virtualbox" do |vb|
    vb.name = "webfact-vm"
    # Display the VirtualBox GUI when booting the machine
    #vb.gui = true
    #vb.memory = "1024"
    #vb.cpus = 2
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
  end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available.
  config.vm.provision "shell", path: "vagrant.sh"

end

