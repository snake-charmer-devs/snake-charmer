# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

def get_env(key, default)
  if ENV.has_key? key
    return YAML.load(ENV[key])
  else
    return default
  end
end

def mkdir(dir)
  Dir.mkdir dir unless File.exists? dir
end

def install_plugins(*plugins)
  plugins.each do |plugin|
    unless Vagrant.has_plugin? plugin
      # Install vbguest via another vagrant process; wait for completion
      cmd1 = ["vagrant", "plugin", "install", plugin]
      system *cmd1
    end
  end

  # Now restart vagrant with same args as current invocation
  cmd2 = ARGV
  cmd2.unshift "vagrant"
  exec *cmd2
end


Vagrant.require_version ">= 1.5.2"


# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  install_plugins "vagrant-vbguest"

  # Create data and log directories
  mkdir 'data'
  mkdir 'log'

  # Workaround for https://www.virtualbox.org/ticket/12879
  # (missing symlink in guest additions package)

  config.vbguest.installer = Class.new(VagrantVbguest::Installers::Ubuntu) do

    # Aftr running standard install process, put the missing
    # symlink in place if it's not there already
    def install(opts=nil, &block)
      super
      fix_link = "test -e /usr/lib/VBoxGuestAdditions || ln -s /usr/lib/x86_64-linux-gnu/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions"
      communicate.sudo(fix_link, opts, &block)
    end

  end
  
  config.vm.box = "hashicorp/precise64"

  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true

  # Disable default synced folder -- it will lead to messiness...
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # These locations are shared between all VMs
  # TODO -- make these read only where possible
  config.vm.synced_folder "notebooks", "/home/vagrant/notebooks"
  config.vm.synced_folder "data", "/home/vagrant/data"
  config.vm.synced_folder "salt/roots/salt", "/srv/salt"
  config.vm.synced_folder "salt/roots/pillar", "/srv/pillar"
  config.vm.synced_folder ".cache", "/srv/cache"

  config.vm.define "charmed34" do |charmed34|

    # These locations are unique to each VM
    mkdir "log/charmed34"
    charmed34.vm.synced_folder "log/charmed34", "/srv/log"
    
    # Bound ports -- IPython Notebook and SSH
    charmed34.vm.network "forwarded_port", guest: 8834, host: 8834
    charmed34.vm.network "forwarded_port", guest: 22, host: 2234

    # Unbound ports 9034, 9134 ... 9934 for user use -- forwarded automatically
    for i in 90..99
      port = (i * 100) + 34
      charmed34.vm.network "forwarded_port", guest: port, host: port
    end

    charmed34.vm.provision :salt do |salt|
      salt.minion_config = "salt/minion"
      salt.run_highstate = true
      salt.pillar({
        "run_tests" => get_env("CHARMER_TEST", false),
        "slimline" => get_env("CHARMER_SLIM", false)
      })
    end

    # Stop salt-minion service to save resources, and disable it;
    # then run post-install sanity check
    charmed34.vm.provision "shell",
      inline: "service salt-minion stop; echo manual > /etc/init/salt-minion.override; /root/bin/sanity_check.py"

    charmed34.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.name = "charmed34"
      v.memory = get_env("CHARMER_RAM", 2048)
      v.cpus = get_env("CHARMER_CPUS", 2)
    end

    charmed34.vm.hostname = "charmed34"

  end

end

# TODO
# Loop through set of python versions and configure
# a VM for each one, something like this:
#     http://maci0.wordpress.com/2013/11/09/dynamic-multi-machine-vagrantfile/

