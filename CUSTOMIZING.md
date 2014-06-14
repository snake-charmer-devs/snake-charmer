# Snake Charmer

## Customization guide

This document covers the technology behind Snake Charmer in more detail, and
discusses some ways to customize your VMs and create new ones.

### "vagrant up" -- under the covers

Before you start customizing VMs, it's a good idea to understand how all the
pieces fit together, and in particular, what happens when you fire up a VM for
the first time.

When you first perform a `vagrant up` command on a new VM, the following steps
take place. The procedure is known as 'provisioning' in Vagrant terminology.

#### Vagrant

Firstly, Vagrant performs the following process, governed by the Vagrantfile
(really just a Ruby script using Vagrant's configuration API).

1. Test for the presence of the `vagrant-vbguest` plugin, and
install it automatically if it's missing.
1. Download a standard Ubuntu VM image from
[Vagrant Cloud](https://vagrantcloud.com/), unless you have a local copy
cached from a previous Vagrant run.
1. Create a new VM from the image, with port forwarding and folder
sharing configured as described in the [README](README.md).
1. Install the Salt minion (i.e. client) service on the VM.
1. Tell the Salt minion to configure the new machine (see below).
1. Stop the Salt minion service, and disable run-on-startup behaviour.

Notes:

* `vagrant-vbguest` is required in order to keep VirtualBox's guest extensions
package on the VM version-synced with your VirtualBox package on the host.
* The VM is set up to use NAT networking, so it can see the LAN and internet
but will not appear as a distinct device on the network. It is therefore only
accessible from the host, via port forwarding.
  * The host's DNS configuration will be used to resolve hostname queries.
  * If your host has more than one network interface available, you'll be
  prompted by Vagrant to pick one.
* In the initial release, only one VM is defined in the Vagrantfile
(`charmed34`), but the plan is to provide multiple VMs for different versions
of Python.
  * The `34` at the end of `charmed34` refers to Python 3.4.
* Many aspects of the `Vagrantfile`, for example port numbers for forwarding,
are parameterized by Python version.
* Having more than one VM using the same Python version, on the same host, is
not currently supported. In principle it's possible, but it would require
additional work to implement naming and port forwarding correctly.
* Provisioning more than one VM at the same time, from the same installation
of Snake Charmer, is not supported.

#### Salt

The [Salt](http://www.saltstack.org)-based configuration procedure follows
the following process.

1. Install a number of required packages on the VM from standard Ubuntu
apt repositories. These are cached on the host in case they're needed again.
1. Enable the third-party [deadsnakes](https://launchpad.net/~fkrull/+archive/deadsnakes)
repo, and install the appropriate Python version from there.
1. Install `distribute` directly from
[pypi](http://pypi.python.org/packages/source/d/distribute/) in order to provide Pip.
1. One by one, install the required Python packages via Pip, either directly
from PyPI or by a `git clone` of the source. As with apt packages, they are
cached on the host outside the VM to save time later if they are needed again.
1. Install the IPython Notebook process as a Unix service, start it, and set it
to start automatically when the VM boots.

Notes:

* The files used by Salt to configure the VM are in the `salt/roots/salt`
subdirectory of your Snake Charmer installation directory. Most of the action
happens in `init.sls`.
* `.sls` files are just YAML files holding data structures understood by Salt.
* Many aspects of these config files, e.g. package version numbers,
are parameterized by Python version. This is what the two digits on the end of
the VM name (e.g. `charmed34`) refer to.
* The lists of Ubuntu and Python packages to install are stored in a file in
`salt/roots/pillar` named for the Python version in use, e.g. `python34.sls`.
  * This lets us provide different dependencies (or different versions) for
  different versions of Python.
  * The format is described below.
* The Salt log is `log/<VM name>/minion` on the host, in case you need it for
debugging.
* Likewise, the Pip log is in `log/<VM name>/pip.log` on the host.
* The cached packages are stored in the `.cache` directory within the Snake
Charmer install directory -- or `/srv/cache` within the VM. It's safe
to delete this cache any time, except while you're actually performing a
provisioning operation in Vagrant.

### Reprovisioning

By default, the full provisioning process only takes place on first creating a
VM -- since it takes so long.

If you've made a configuration change, you'll need to explicitly reprovision
the VM in order to apply it:

    vagrant reload --provision <VM name>

This reboots the VM and reapplies the config rules. It is usually much quicker
than the initial provisioning, as in general, only new or version-changed
packages will be installed.

Note that this **won't** delete packages which you've removed from the package
lists (see below). You'll have to do that manually via the Linux command line,
if it's important. Or, just destroy and recreate the VM.

### Environment variables

Snake Charmer recognizes a number of environment variables that can be used to
modify the behaviour of VMs without editing config files. Set these as
appropriate for your environment, then `vagrant up` or `vagrant reload`.

* `CHARMER_RAM` (integer; default 2048)

Amount of memory to supply to each VM, in megabytes. 1000 is probably the
minimum you can get away with.

*This will take effect on next boot, regardless of whether the `--provision`
flag is used.*

* `CHARMER_CPUS` (integer; default 2)

Number of virtual CPUs to give each VM. Most Python programs will run happily
on one CPU. If you're using multiprocessing, IPython clustering, or running the
test suite (see below), raise this as high as you can -- but bear in mind
you'll probably need to raise `CHARMER_RAM` somewhat too.

*This will take effect on next boot, regardless of whether the `--provision`
flag is used.*

* `CHARMER_SLIM` (boolean; default "false")

If set to "true" this will disable downloading of some example data files after
provisioning, to speed up VM creation. Currently this just disables the
[NLTK downloader](http://www.nltk.org/data.html).

*This flag only has an effect during initial provisioning or reprovisioning.*

* `CHARMER_NOTEBOOK_DIR` (string; default "notebooks")

A custom location on the host to mount as `/home/vagrant/notebooks`, instead
of the `notebooks` subdirectory of the `snake-charmer` directory.

*This will take effect on next boot, regardless of whether the `--provision`
flag is used.*

* `CHARMER_DATA_DIR` (string; default "data")

A custom location on the host to mount as `/home/vagrant/data`, instead
of the `data` subdirectory of the `snake-charmer` directory.

*This will take effect on next boot, regardless of whether the `--provision`
flag is used.*

* `CHARMER_CACHE_DIR` (string; default ".cache")

A custom location on the host for cached packages and source code, instead of
the `.cache` subdirectory of the `snake-charmer` directory. This is mounted as
`/srv/cache` on the guest.

*This will take effect on next boot, regardless of whether the `--provision`
flag is used.*

* `CHARMER_LOG_DIR` (string; default "log")

A custom location on the host for cached packages and source code, instead of
the `log` subdirectory of the `snake-charmer` directory. Within this directory,
a subdirectory will be created which is named after the VM (e.g. `charmed34`).
This is then mounted as `/srv/log` on the guest.

*This will take effect on next boot, regardless of whether the `--provision`
flag is used.*

* `CHARMER_SALT_ROOT` (string; default "salt/roots/salt") and `CHARMER_PILLAR_ROOT` (string; default "salt/roots/pillar")

Locations for Salt configuration files. Don't change these unless you're a
Salt guru and you know what you're doing.

*These will take effect on next boot, regardless of whether the `--provision`
flag is used.*

### Editing the package lists

The package lists are in `salt/roots/pillar/python<ver>.sls`. You are free to
edit these, to add/remove packages from your VM definition. If you are creating
an entirely new VM, copy one of these to get going.

The `apt_pkgs` data structure describes what `.deb` packages to install via
`apt-get` from the standard Ubuntu repositories (including universe &
multiverse). It's a key-value map (dict) so order isn't important -- `apt-get`
runs once, and figures out the correct order by looking at dependencies.

The format is simply `- <pkg name>: <pkg version>`, e.g.

```yaml
    - libatlas-base-dev: 3.8.4-3build1
```

The `pip_pkgs` structure is used to install Python packages via Pip. We
actually run Pip once for each package listed, in the order specified, letting
it install dependencies for each specified package unless they've already been
satisfied.

To preserve order, it's a list of dicts, rather than a single dict.

Packages can be specified in one of two ways. Most, simply, you can just
provide a name, and a Pip-style version spec:

```yaml
    - name:   numpy
      ver:    ==1.8.1
```

This will install the requested version from PyPI.

Or, you may need to install from a git checkout, if it's a bleeding-edge
version or needs special treatment. The basic way to achieve this is by
providing a name, repo URL, and revision identifier -- e.g. a commit hash
or tag:

```yaml
    - name:   Theano
      git:    https://github.com/Theano/Theano.git
      rev:    46b19c24e3b04bbde3f2cf957824e07885916b9b
    - name:   numpydoc
      git:    https://github.com/numpy/numpydoc.git
      rev:    latest_rc_tag
```

#### Custom installation commands

If you're installing via a Git clone, you can add a custom `setup` command to
use insted of Pip, which is executed (via bash) from the source directory after
cloning:

```yaml
    - name:   numba
      git:    https://github.com/numba/numba.git
      rev:    4b9a36e7b344823fa2d2bb85221a14ff9e0abb03
      setup:  pip3.4 install --install-option=build_ext --install-option="--inplace" . 
```

#### Custom module names for import statements

The post-install process attempts to start Python and import all of these
packages, to verify that installation worked and that they can coexist. It
assumes that the module name to import is just the package name in lowercase
(e.g. "Cython" => `import cython`).

In **either case** (PyPI or Git install), you will also need to override this
behaviour with an `import` option if this isn't true, e.g. when capitalization
is used in the module name, or there is some other more significant difference:

```yaml
    - name:   beautifulsoup4
      ver:    ==4.2.1
      import: bs4
    - name:   Pyro4
      import: Pyro4
      ver:    ==4.25
    - name:   Pillow
      import: PIL
      git:    https://github.com/python-imaging/Pillow.git
      rev:    84a701a82b33896a4d6997743c2131ab0a40c588
```

### Hacking Vagrant

For now, refer to the [Vagrant docs](http://docs.vagrantup.com/v2/) for how to
perform customizations not described here, such as syncing additional folders,
or spinning up VMs in AWS.

### Designing new VMs

If you want to create a completely new VM template, e.g. for an OS version or
Python version that isn't supplied, you'll need to modify the following files:

    Vagrantfile
    salt/roots/pillar/top.sls

And copy and modify the package lists:

    salt/roots/pillar/python34.sls

This will be covered in detail in a later release.

### Running the test suites

We supply a notebook called "Snake Charmer QA" which runs the test suites for
the major Python packages used. This is a big job -- we recommend using a
server-grade VM with at least 12 vCPUS and 8GB of RAM, and even with that
setup, the whole process will take over an hour.

So, we recommend you only do this if you've made a modification to one of the
fundamental underlying components, for example NumPy. Unless you have server
time to spare...

However, it's easy to edit that notebook to run only specific tests of
interest. It's also straightforward to add new tests for packages you've added
yourself. Instructions are included within the notebook.


