# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.5.2"


# Workaround for https://www.virtualbox.org/ticket/12879
# (missing symlink in guest additions package)

class MyInstaller < VagrantVbguest::Installers::Ubuntu

  # Aftr running standard install process, put the missing
  # symlink in place if it's not there already
  def install(opts=nil, &block)
    super
    fix_link = "test -e /usr/lib/VBoxGuestAdditions || ln -s /usr/lib/x86_64-linux-gnu/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions"
    communicate.sudo(fix_link, opts, &block)
  end

end


# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # This seems dirty somehow
  unless Vagrant.has_plugin? "vagrant-vbguest"

    # Install vbguest via another vagrant process; wait for completion
    cmd1 = ["vagrant", "plugin", "install", "vagrant-vbguest"]
    system *cmd1
    
    # Now restart vagrant with same args
    cmd2 = ARGV
    cmd2.unshift "vagrant"
    exec *cmd2

  end

  config.vbguest.installer = MyInstaller
  
  config.vm.box = "hashicorp/precise64"

  config.ssh.forward_agent = true

  config.vm.synced_folder "salt/roots", "/srv"
  config.vm.synced_folder "notebooks", "/home/vagrant/notebooks"

  config.vm.define "charmed34" do |charmed34|
    
    charmed34.vm.network "forwarded_port", guest: 8834, host: 8834

    charmed34.vm.provision :salt do |salt|
      salt.pillar({
        "pyver" => "3.4",
        "theanover" => "rel-0.6"
      })
      salt.minion_config = "salt/minion"
      salt.run_highstate = true
    end

    # Stop salt-minion service to save resources, and disable it
    charmed34.vm.provision "shell",
      inline: "service salt-minion stop; echo manual > /etc/init/salt-minion.override"

    charmed34.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.name = "charmed34"
      v.memory = 4096
      v.cpus = 3
    end

    charmed34.vm.hostname = "charmed34"

  end

end

# TODO
# Take out v.memory and v.cpus
# Read these details from user's default Vagrantfile if possible:
#     http://mgdm.net/weblog/vagrantfile-inheritance/
# Loop through set of python versions and configure
# a VM for each one, something like this:
#     http://maci0.wordpress.com/2013/11/09/dynamic-multi-machine-vagrantfile/

