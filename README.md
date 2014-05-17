# Snake Charmer

A portable Python workbench for data science, built with Vagrant,
VirtualBox and Salt.

<!-- toc -->

## Introduction

Wouldn't it be great if you could magic up a local IPython Notebook server,
complete with SciPy, Pandas, Matplotlib, PyMC, scikit-learn, R integration,
and all the usual goodness, and running the latest version of Python, just
by typing one line?

    vagrant up charmed34

And wouldn't it be great if you could do that from pretty much any Windows, Mac
or Linux machine, and know that you'd get the exact same environment every
time?

Well, read on.

### *Work in progress - pre-release version*

If you are interested in being an early adopter, please keep a close eye on
the commits and issues here -- I am finding and fixing bugs almost daily.

Thanks! -- [Andrew](https://twitter.com/andrew_clegg).

## Requirements

Snake Charmer runs IPython and all the associated tools in a sandboxed virtual
machine. It relies on [Vagrant](http://www.vagrantup.com/) for creating and
managing these, and [VirtualBox](https://www.virtualbox.org/) for running them
-- so please go and install those now.

*Experienced users of other virtualization platforms can edit the Vagrantfile
to use one of these instead, if they prefer.*

Everything else is installed automatically. See below for a
[list of included packages](#what-is-included).

## Getting started

Check out this git repository:

    git clone git@github.com:andrewclegg/snake-charmer.git
    cd snake-charmer

Start the VM:

    vagrant up charmed34

*If you're already a Vagrant user, be aware that Snake Charmer's Vagrantfile
will attempt to install the [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest/)
plugin automatically.*

This command currently takes around an hour to download and install all the
necessary software. When this completes, it will run some tests and then
display a message like this:

    Your VM is up and running: http://localhost:8834/tree

This link will take you to a fully-kitted-out IPython Notebook server. Open the
"Hello World" notebook to see a full list of installed packages and other
system information. *N.B.* The notebook server is started with inline graphics
enabled for matplotlib, but _not_ `--pylab`, as this is
[considered harmful](http://carreau.github.io/posts/10-No-PyLab-Thanks.ipynb.html).

On a VM that's already been fully configured, `vagrant up` will just restart
it, without going through the full install process.

You can log into the server via

    vagrant ssh charmed34

from the same directory, for full command-line control. It's an Ubuntu 12.04
box, under the covers.

Some more useful commands:

    vagrant reload charmed34  # reboot the VM
    vagrant halt charmed34    # shut down the VM, reclaim the memory it used
    vagrant destroy charmed34 # wipe it completely, reclaiming disk space too
    vagrant suspend charmed34 # 'hibernate' the machine, saving current state
    vagrant resume charmed34  # 'unhibernate' the machine

See the [Vagrant docs](http://docs.vagrantup.com/v2/cli/index.html) for more
details.

### Folder structure

The notebook server runs from within the `notebooks` subdirectory of the
current `snake-charmer` directory, and initially contains a single "Hello
World" notebook.

Snake Charmer uses IPython 2 so any subdirectories of `notebooks` will be
visible and navigable as folders in the IPython web interface. However, you
can't actually *create* directories from the web interface yet, so you'd need
to log in via ssh, or just enter a shell command into IPython with `!`.

Vagrant sets up a number of synced folders, which are directories visible to
both the VM and the host (your computer). Files placed in these will be visible
to both the VM and the host, so this is a good way to make data available to
the VMs. If you create more than one VM (feature coming soon!), files in synced
folders will be visible to all of them -- apart from /srv/log which is specific
to one VM only.

The paths in the left-hand column are relative to the `snake-charmer` install
directory -- your local copy of this repo.

    Folder on your computer   Folder within VM         Contents
    ------------------------  -----------------------  --------
    notebooks                 /home/vagrant/notebooks  Any notebooks
    data                      /home/vagrant/data       Data you wish to share (initially empty)
    .cache                    /srv/cache               Cache for downloaded files
    log/charmed34             /srv/log                 Certain setup logs, useful for debugging only
    salt/roots/salt           /srv/salt                Config management information (ignore this)
    salt/roots/pillar         /srv/pillar              Config management information (ignore this)

### Data persistence

If you get your VM into a mess somehow, you can just type

    vagrant destroy charmed34
    vagrant up charmed34

to build a new one. Files in synced folders will not be affected if you do
this, so you won't lose any data or notebooks. However, any data stored on the
VM but *outside* these synced folders will be lost.

The virtual disk on each VM is configured with an 80GB limit -- it grows to
take up real disk space on the host up to this limit, and then stops. But data
stored in synced folders does not count towards this. So you will likely never
reach the 80GB limit.

If you want to make another folder available to the VM, see **Customizing your
VMs** below.

## What is included

Snake Charmer provides an out-of-the-box workbench for data analysis,
statistical modelling, machine learning, mathematical programming and
visualization.

It is designed to be used primarily via IPython Notebook.

The environment is based on Ubuntu 12.04 and Python 3.4, with
the following modules installed.

Packages marked 'alpha' or 'dev' should be considered experimental, although
in many cases they are largely problem-free. We will endeavour to discover and
document any known issues [here](https://github.com/andrewclegg/snake-charmer/issues).

* Data handling and processing:
    * [IPython](http://ipython.org/) 2.0.0
        * [runipy](https://pypi.python.org/pypi/runipy) 0.0.8
    * [Pandas](http://pandas.pydata.org/) 0.13.1
    * [PyTables](http://www.pytables.org/moin) 3.1.1
    * [lxml](http://lxml.de/lxmlhtml.html) 3.3.5
    * [Psycopg](http://initd.org/psycopg/) 2.5.2
    * [joblib](https://pythonhosted.org/joblib/) 0.8.0 alpha 3

* Graphics and visualization:
    * [Matplotlib](http://matplotlib.org/) 1.3.1
    * [prettyplotlib](http://olgabot.github.io/prettyplotlib/) 0.1.7
    * [brewer2mpl](https://github.com/jiffyclub/brewer2mpl) 1.4
    * [Seaborn](http://www.stanford.edu/~mwaskom/software/seaborn/) 0.3.1
    * [Pillow](http://python-imaging.github.io/) 2.4.0

* Machine learning and inference:
    * [scikit-learn](http://scikit-learn.org/) 0.15 dev
    * [PyMC](http://pymc-devs.github.io/pymc/) 3.0 alpha
    * [DEAP](https://code.google.com/p/deap/) 1.0.1
    * [fastcluster](http://danifold.net/fastcluster.html) 1.1.13

* Natural language processing and text mining:
    * [gensim](http://radimrehurek.com/gensim) 0.9.1
    * [NLTK](http://www.nltk.org/nltk3-alpha/) 3.0 alpha 3 (very experimental)

* Numeric and statistical computing:
    * [NumPy](http://www.numpy.org/) 1.8.1
    * [SciPy](http://www.scipy.org/) 0.13.3
    * [Bottleneck](http://berkeleyanalytics.com/bottleneck/) 0.8.0
    * [Statsmodels](http://statsmodels.sourceforge.net/) 0.6.0 dev
    * [Patsy](http://patsy.readthedocs.org/en/latest/) 0.2.1
    * [Theano](http://deeplearning.net/software/theano/) 0.6.0 dev
    * [numexpr](https://github.com/pydata/numexpr) 2.4
    * [SymPy](http://sympy.org/) 0.7.5
    * [Cython](http://cython.org/) 0.21 dev

* Non-Python tools:
    * [GNU Parallel](http://www.gnu.org/software/parallel/) 20121122
    * [R](http://www.r-project.org/) 2.14.1
        * [r-base-dev and r-recommended](http://cran.r-project.org/bin/linux/ubuntu/) packages
        * [rpy2](http://rpy.sourceforge.net/rpy2.html) and [rmagic](http://ipython.org/ipython-doc/dev/config/extensions/rmagic.html) 2.3.10 for Python integration

Coming soon: Other Python versions. Ubuntu 14.04 LTS.

Potential future additions include: CrossCat, BayesDB, Bokeh, Blaze, Numba,
SysCorr, bayesian, PEBL, libpgm, BayesPy, STAN, BayesOpt, mpld3,
Pylearn2, cudamat, Gnumpy, py-earth, Orange, NeuroLab, PyBrain, scikits-sparse,
other scikits, annoy, Zipline, Quandl, BNFinder, Alchemy API, openpyxl,
xlrd/xlwt, NetworkX, OpenCV, boto, gbq, SQLite, PyMongo, mpi4py, PyCUDA,
Jubatus, Vowpal Wabbit, and one or more Hadoop clients.

If you have suggestions for any other packages to add, please submit them by
raising an [issue](https://github.com/andrewclegg/snake-charmer/issues).

## Under the covers

### Setup process in more detail

When you first perform a `vagrant up` command on a new VM, the following steps
take place.

#### Vagrant

Firstly, Vagrant performs the following steps (slightly simplified).

1. Test for the presence of the `vagrant-vbguest` plugin, and
install it automatically if it's missing.
1. Download a standard Ubuntu VM image from
[Vagrant Cloud](https://vagrantcloud.com/), unless you have a local copy
cached from a previous Vagrant run.
1. Create a new VM from the image, with port forwarding and folder
sharing configured as described earlier.
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
* Many aspects of the `Vagrantfile`, for example port numbers for forwarding,
are parameterized by Python version. This is what the two digits on the end of
the VM name (e.g. `charmed34`) refer to.
* Having more than one VM using the same Python version, on the same host, is
not currently supported. In principle it's possible, but it would require
additional work to implement naming and port forwarding correctly.

#### Salt

The [Salt](http://www.saltstack.org)-based configuration procedure follows
the following process -- once again, slightly simplified.

1. Install a number of required packages on the VM from standard Ubuntu
apt repositories.
1. Enable the third-party [deadsnakes](https://launchpad.net/~fkrull/+archive/deadsnakes)
repo, and install the appropriate Python version from there.
1. Install `distribute` directly from
[pypi](http://pypi.python.org/packages/source/d/distribute/) in order to provide Pip.
1. One by one, install the required Python packages via Pip, caching them
locally outside the VM to save time later if they are needed again.
selected to work with the Python version requested (e.g. 3.4 for `charmed34`).
1. Install the IPython Notebook process as a Unix service, start it, and set it
to start automatically when the VM boots.

Notes:

* The files used by Salt to configure the VM are in the `salt/roots/salt`
subdirectory of your Snake Charmer installation directory. Most of the action
happens in `init.sls`.
* Many aspects of these config files, e.g. package version numbers,
are parameterized by Python version. This is what the two digits on the end of
the VM name (e.g. `charmed34`) refer to.
* The Salt log is `log/<VM name>/minion` on the host, in case you need it for
debugging.
* The Pip log -- which is likely to be much more useful if you do need to
debug a failed package install -- is in `log/<VM name>/pip.log` on the host.
* The cached packages are stored in the `.cache` directory within the Snake
Charmer install directory -- or `/srv/cache` within the VM. It's safe
to delete this cache any time, except while you're actually performing a
provisioning operation in Vagrant.

### Boot process in more detail

**TODO**

### Troubleshooting

If a VM starts behaving strangely, the golden rule is:
**Don't waste time fixing it.**

This may sound strange, but the advantage of Snake Charmer is that you can
create a factory-fresh VM with almost no effort at all.

The first thing to try is to reboot the VM:

    vagrant reload 

Option two is reprovisioning the machine. This runs through the install
process and ensures all required packages are installed. First, delete the
package cache in case anything in there is messed up:

    # On OS X or Linux:
    rm -rf .cache

    # Or on Windows:
    rd /s /q .cache

    # N.B. Make sure you're in the snake-charmer directory first!

Then reboot and reprovision:

    vagrant reload --provision charmed34

If this doesn't fix the problem, then delete it completely, and recreate it:

    vagrant destroy charmed34
    vagrant up charmed34

If this still doesn't fix it, you may have found a bug. Please open a
[Github issue](https://github.com/andrewclegg/snake-charmer/issues)
describing it in as much detail as possible, preferably with
instructions on how to reproduce it.

The VirtualBox admin GUI can of course be used to check on the status of VMs,
inspect their hardware and network configuration, manually start or stop them,
attach via the console, etc.

#### Important reminder

Only use the **host** filesystem to store data, notebooks etc. -- that is, the
`data` and `notebooks` folders which are synced to the VM. If you store files
in other places on a VM, they **will** be lost forever when you destroy it. 

## Customizing your VMs

**TODO**

## F.A.Q.

See the separate [Snake Charmer F.A.Q.](FAQ.md).

## Credits

Developed by [Andrew Clegg](https://github.com/andrewclegg) (Twitter:
[@andrew_clegg](http://twitter.com/andrew_clegg)), tested at
[Pearson](http://labs.pearson.com/).

## License

Snake Charmer does *not* include bundled distributions of its components
(Python, Ubuntu, Python libraries, other libraries and packages etc.). Rather,
it provides a set of machine-readable instructions for obtaining these
components from third-party open-source repositories. Please refer to each
individual component's documentation for license details.

Snake Charmer itself is distributed under the Apache License:

    Copyright 2014 Andrew Clegg

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

