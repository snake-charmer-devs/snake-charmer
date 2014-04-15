# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "hashicorp/precise64"

  config.vm.network "public_network"

  config.ssh.forward_agent = true

  # config.vm.synced_folder "../data", "/vagrant_data"
  config.vm.synced_folder "salt/roots", "/srv"

  config.vm.define "charmed34" do |charmed34|
    
    charmed34.vm.network "forwarded_port", guest: 8834, host: 8834

    charmed34.vm.provision :salt do |salt|
      salt.pillar({
        "pyver" => "3.4",
        "theanover" => "rel-0.6"
      })
      salt.minion_config = "salt/minion"
      salt.run_highstate = false
    end

    charmed34.vm.provider "virtualbox" do |v|
      v.name = "charmed34"
      v.memory = 4096
      v.cpus = 3
    end

    charmed34.vm.hostname = "charmed34"

  end

end

# TODO
# Start notebook server on port 8834 via salt
# Make this persist between sessions?
# Take out v.memory and v.cpus
# Read these details from user's default Vagrantfile if possible:
#     http://mgdm.net/weblog/vagrantfile-inheritance/
# Loop through set of python versions and configure
# a VM for each one, something like this:
#     http://maci0.wordpress.com/2013/11/09/dynamic-multi-machine-vagrantfile/
# Resolve public vs private network issue

