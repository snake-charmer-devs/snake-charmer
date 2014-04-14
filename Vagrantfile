# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "hashicorp/precise64"

  # config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.network "public_network"

  config.ssh.forward_agent = true

  # config.vm.synced_folder "../data", "/vagrant_data"
  config.vm.synced_folder "salt/roots", "/srv"

  config.vm.provision :salt do |salt|
    salt.minion_config = "salt/minion"
    salt.run_highstate = true
  end

  config.vm.define "charmed34" do |charmed34|
    charmed34.vm.provision :salt do |salt|
      salt.pillar({
        "pyver" => "3.4"
      })
    end
  end

end
