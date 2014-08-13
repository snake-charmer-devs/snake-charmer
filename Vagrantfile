# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'vagrant/util/which'

require 'yaml'

def get_env(key, default)
  if ENV.has_key? key
    return YAML.load(ENV[key])
  else
    return default
  end
end

def mkdir(*dirs)
  dirs.each do |dir|
    Dir.mkdir dir unless File.exists? dir
  end
end

def install_plugins(vagrant_exe, *plugins)
  needs_restart = false

  plugins.each do |plugin|
    unless Vagrant.has_plugin? plugin
      # Install vbguest via another vagrant process; wait for completion
      cmd1 = [vagrant_exe, "plugin", "install", plugin]
      system *cmd1
      needs_restart = true
    end
  end

  if needs_restart
    # Restart vagrant with same args as current invocation
    cmd2 = ARGV
    cmd2.unshift vagrant_exe
    exec *cmd2
  end
end

begin
  Vagrant.require_version ">= 1.5.2"
rescue NoMethodError
  raise 'Snake Charmer is only supported on Vagrant >= 1.5.2, please upgrade. Thanks.'
end

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  vagrant_exe = Vagrant::Util::Which.which("vagrant")
  unless vagrant_exe
    raise 'vagrant not found in path'
  end
  git_exe = Vagrant::Util::Which.which("git")

  install_plugins vagrant_exe, "vagrant-vbguest"

  # Get working directories from environment, using defaults if not supplied,
  # and create them if necessary
  notebook_dir = get_env("CHARMER_NOTEBOOK_DIR", "notebooks")
  data_dir = get_env("CHARMER_DATA_DIR", "data")
  salt_root = get_env("CHARMER_SALT_ROOT", "salt/roots/salt")
  pillar_root = get_env("CHARMER_PILLAR_ROOT", "salt/roots/pillar")
  cache_dir = get_env("CHARMER_CACHE_DIR", ".cache")
  log_dir = get_env("CHARMER_LOG_ROOT", "log")
  mkdir notebook_dir, data_dir, cache_dir, cache_dir + "/apt", cache_dir + "/apt/partial", log_dir

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
  config.vm.synced_folder notebook_dir, "/home/vagrant/notebooks"
  config.vm.synced_folder data_dir, "/home/vagrant/data"
  config.vm.synced_folder salt_root, "/srv/salt"
  config.vm.synced_folder pillar_root, "/srv/pillar"
  config.vm.synced_folder cache_dir, "/srv/cache"

  config.vm.define "charmed34" do |charmed34|

    # These locations are unique to each VM
    my_log = log_dir + "/charmed34"
    mkdir my_log
    charmed34.vm.synced_folder my_log, "/srv/log"
    
    # Bound ports -- IPython Notebook and SSH
    charmed34.vm.network "forwarded_port", guest: 8834, host: 8834, host_ip: "127.0.0.1"
    charmed34.vm.network "forwarded_port", guest: 22, host: 2234, host_ip: "127.0.0.1"

    # Unbound ports 9034, 9134 ... 9934 for user use -- forwarded automatically
    for i in 90..99
      port = (i * 100) + 34
      charmed34.vm.network "forwarded_port", guest: port, host: port
    end

    # Wipe salt minion log ready for fresh run
    charmed34.vm.provision "shell",
      inline: "truncate -s 0 /srv/log/minion"

    # Install and configure packages via salt
    charmed34.vm.provision :salt do |salt|
      salt.minion_config = "salt/minion"
      salt.run_highstate = true
      salt.pillar({
        "run_tests" => get_env("CHARMER_TEST", false), # not currently used
        "slimline" => get_env("CHARMER_SLIM", false)
      })
    end

    # Stop salt-minion service to save resources, and disable it;
    # then run post-install sanity check
    charmed34.vm.provision "shell",
      inline: "service salt-minion stop; echo manual > /etc/init/salt-minion.override; /root/bin/sanity_check.py"

    # VM settings
    charmed34.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.name = "charmed34"
      v.memory = get_env("CHARMER_RAM", 1024)
      v.cpus = get_env("CHARMER_CPUS", 1)
    end

    charmed34.vm.hostname = "charmed34"

  end

  # Write top of git log into data so we can show it in Hello World notebook
  msg = "commit not found"
  if git_exe
    last_commit = `"#{git_exe}" log --no-merges -n 1`
    if $?.success?
      msg = last_commit
    end
  end
  File.open("notebooks/last_commit.txt", "w") do |f|
    f.write(last_commit)
  end

end

# TODO
#
# Loop through set of python versions and configure
# a VM for each one, something like this:
#     http://maci0.wordpress.com/2013/11/09/dynamic-multi-machine-vagrantfile/

