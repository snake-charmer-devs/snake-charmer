# Snake Charmer

Portable virtual machines for scientific Python, using Vagrant.

## *Work in progress - not yet fully tested*

If you are interested in being an early adopter, please keep a close eye on
the commits and issues here -- I am finding and fixing bugs almost daily.

Thanks! -- [Andrew](https://twitter.com/andrew_clegg).

## Introduction

Wouldn't it be great if you could magic up a local IPython Notebook server,
complete with SciPy, Pandas, Matplotlib, PyMC, scikit-learn and all the usual
goodness, and running the latest version of Python, just by typing one line?

    vagrant up charmed34

And wouldn't it be great if you could do that from pretty much any Windows, Mac
or Linux machine, and know that you'd get the exact same environment every
time?

Well, read on.

## Requirements

Snake Charmer runs IPython and all the associated tools in a sandboxed virtual
machine. It relies on [Vagrant](http://www.vagrantup.com/) for creating and
managing these, and [VirtualBox](https://www.virtualbox.org/) for running them
-- so please go and install those now.

*Experienced users of other VM hosting platforms can edit the Vagrantfile to
use one of these instead, if they prefer.*

Everything else is installed automatically. See below for a
[list of included Python packages](#what-is-included).

## Getting started

Check out this git repository:

    git clone git@github.com:andrewclegg/snake-charmer.git
    cd snake-charmer

Start the VM:

    vagrant up charmed34

This command currently takes around an hour to download and install all the
necessary software. When it completes, click the following link:

[http://localhost:8834/](http://localhost:8834/)

This will take you to a fully-kitted-out IPython Notebook server.

*If you're already a Vagrant user, be aware that Snake Charmer's Vagrantfile
will attempt to install the [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest/)
plugin automatically.*

On a VM that's already been fully configured, `vagrant up` will just restart it
and check a few components are up to date, without going through the full
install process.

You can log into the server via

    vagrant ssh charmed34

from the same directory, for full command-line control. It's an Ubuntu 12.04
box, under the covers.

Some more useful commands:

    vagrant halt charmed34    # shut down the VM, reclaim the memory it used
    vagrant destroy charmed34 # wipe it completely, reclaiming disk space too
    vagrant suspend charmed34 # 'hibernate' the machine, saving current state
    vagrant resume charmed34  # 'unhibernate' the machine

See the [Vagrant docs](http://docs.vagrantup.com/v2/cli/index.html) for more
details.

### Folder structure

The notebook server runs from within the `notebooks` subdirectory of the
current `snake-charmer` directory, and initially contains a single "Hello
World" notebook. Inside the VM, `notebook` is within the home directory of the
default user, called `vagrant`.

snake-charmer uses IPython 2 so any subdirectories of `notebooks` will be
visible and navigable as folders in the IPython web interface. However, you
can't actually *create* directories from the web interface yet, so you'd need
to log in via ssh as above to do this.

The entire `snake-charmer` directory is visible within the VM as `/vagrant` in
case you need it. Note that the VM **can't** see files outside these locations
by default.

Or to put it another way:

```
Folder on your computer           Folder within VM          Contents
-----------------------           ----------------          --------
<home>/snake-charmer              /vagrant                  Your copy of this repo
<home>/snake-charmer/notebooks    /home/vagrant/notebooks   Any notebooks you create
<home>/snake-charmer/salt/roots   /srv                      Ignore this (internal use)
```

(`<home>` is wherever you were when you cloned this repo.)

If you get your VM into a mess somehow, you can just type

    vagrant destroy charmed34 vagrant up charmed34

to build a new one. You won't lose any data, unless for some reason you've
stored it in a directory that's local to the VM, i.e. *outside* the shared
folders listed above.

## What is included

Snake Charmer provides an out-of-the-box workbench for data analysis,
statistical modelling, machine learning, mathematical programming and
visualization.

It is designed to be used primarily via IPython Notebook.

The environment is based on Ubuntu 12.04 and Python 3.4, with
the following modules installed.

*N.B. package version numbers will be frozen and listed here, when first Snake Charmer stable version is released.*

* Data handling and processing:
    * [IPython](http://ipython.org/)
    * [Pandas](http://pandas.pydata.org/)
    * [PyTables](http://www.pytables.org/moin)
    * [lxml](http://lxml.de/lxmlhtml.html)
    * [Psycopg](http://initd.org/psycopg/)

* Graphics and visualization:
    * [Matplotlib](http://matplotlib.org/)
    * [prettyplotlib](http://olgabot.github.io/prettyplotlib/)
    * [brewer2mpl](https://github.com/jiffyclub/brewer2mpl)
    * [Seaborn](http://www.stanford.edu/~mwaskom/software/seaborn/)

* Machine learning and inference:
    * [scikit-learn](http://scikit-learn.org/)
    * [PyMC](http://pymc-devs.github.io/pymc/)
    * [DEAP](https://code.google.com/p/deap/)
    * [fastcluster](http://danifold.net/fastcluster.html)

* Numeric and statistical computing:
    * [NumPy](http://www.numpy.org/)
    * [SciPy](http://www.scipy.org/)
    * [Bottleneck](http://berkeleyanalytics.com/bottleneck/)
    * [Statsmodels](http://statsmodels.sourceforge.net/)
    * [Patsy](http://patsy.readthedocs.org/en/latest/)
    * [Theano](http://deeplearning.net/software/theano/)
    * [numexpr](https://github.com/pydata/numexpr)
    * [SymPy](http://sympy.org/)
    * [Cython](http://cython.org/)

Coming soon: runipy, Joblib, NLTK, other Python versions. Optionally R for rmagic.
Ubuntu 14.04 LTS.

Potential future additions include: CrossCat, BayesDB, Bokeh, Blaze, Numba,
gensim, mpld3, Pylearn2, cudamat, Gnumpy, py-earth, Orange, NeuroLab, PyBrain,
scikits-sparse, other scikits, annoy, Zipline, Quandl, BNFinder, Alchemy API,
openpyxl, xlrd/xlwt, NetworkX, OpenCV, boto, gbq, SQLite, PyMongo, mpi4py,
PyCUDA, Jubatus, Vowpal Wabbit, and one or more Hadoop clients.

## Under the covers

### Setup process in more detail

When you first perform a `vagrant up` command on a new VM, the following steps
take place.

#### Vagrant

Firstly, Vagrant performs the following steps (slightly simplified).

1. Test for the presence of the `vagrant-vbguest` plugin, and
install it automatically if it's missing.
1. Download a standard Ubuntu VM image from
[Vagrant Cloud](https://vagrantcloud.com/).
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
** If your host has more than one network interface available, you'll be
prompted by Vagrant to pick one.
* Many aspects of the `Vagrantfile`, for example port numbers for forwarding,
are parameterized by Python version. This is what the two digits on the end of
the VM name (e.g. `charmed34`) refer to.

#### Salt

The Salt-based configuration procedure follows the following process --
once again, slightly simplified.

1. Install a number of required packages on the VM from standard Ubuntu
apt repositories.
1. Enable the third-party [deadsnakes](https://launchpad.net/~fkrull/+archive/deadsnakes)
repo, and install the appropriate Python version from there.
1. Install `distribute` directly from
[pypi](http://pypi.python.org/packages/source/d/distribute/) in order to provide Pip.
1. One by one, install the required Python packages via Pip, using
a `requirements` file containing a list of Python packages
selected to work with the Python version requested (e.g. 3.4 for `charmed34`).
1. Install the iPython Notebook process as a Unix service, start it, and set it
to start automatically when the VM boots.

Notes:

* The files used by Salt to configure the VM are in the `salt/roots/salt`
subdirectory of this repo.
* Many aspects of these config files, e.g. package version numbers,
are parameterized by Python version. This is what the two digits on the end of
the VM name (e.g. `charmed34`) refer to.
* The Salt logs is `/var/log/salt/minion` on the VM, in case you need it for
debugging.
* The Pip logs -- which are likely to be much more useful if you do need to
debug a failed package install -- are in `/vagrant/pip_NN.log` on the VM,
where *NN* is the package number. As `/vagrant/` is shared with the host, you
can also see this file in the repo directory.

## Customizing your VM

## License

Individual components are distributed under their own licenses. All
original work is distributed under the Apache License:

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

