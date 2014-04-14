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

  # TODO loop through set of python versions and configure
  # a VM for each one, something like this:
  # http://maci0.wordpress.com/2013/11/09/dynamic-multi-machine-vagrantfile/

  config.vm.define "charmed34" do |charmed34|
    
    # Might not need port forwarding if we're on a bridged network?
    # charmed34.vm.network "forwarded_port", guest: 8888, host: 8834

    # TODO start notebook server on port 8834 via salt

    charmed34.vm.provision :salt do |salt|
      salt.pillar({
        "pyver" => "3.4"
      })
      salt.minion_config = "salt/minion"
      salt.run_highstate = true
    end

    charmed34.vm.provider "virtualbox" do |v|
      v.name = "charmed34"
    end

    charmed34.vm.hostname = "charmed34"

  end

end
