# Snake Charmer

A portable Python workbench for data science, built with Vagrant,
VirtualBox and Salt.

**Tested on 64-bit Mac OS X and Linux machines.** If you can help us test
on Windows machines and/or 32-bit machines, please
[let us know](https://github.com/andrewclegg/snake-charmer/issues/24).
In principle it should work, in practice we don't have the resources to
check yet.

## Introduction

Wouldn't it be great if you could magic up a local IPython Notebook server,
complete with SciPy, Pandas, Matplotlib, PyMC, scikit-learn, R and Octave
integration, and all the usual goodness, and running the latest version of
Python, just by typing one line?

    vagrant up charmed34

And wouldn't it be great if you could do that from pretty any machine, and
know that you'd get the exact same environment every time?

Well, read on.

## What is included

Snake Charmer provides an out-of-the-box workbench for data analysis,
statistical modelling, machine learning, mathematical programming and
visualization.

It is designed to be used primarily via IPython Notebook.

The environment is based on Ubuntu 12.04 and Python 3.4, with the following
data science tools included. You are of course free to install any other Python
or Ubuntu packages -- or anything else that fits your need.

Packages marked 'alpha' or 'dev' should be considered experimental, although
in many cases they are largely problem-free. We will endeavour to discover and
document any known issues [here](https://github.com/andrewclegg/snake-charmer/issues).

* Data handling and processing tools:
    * [IPython](http://ipython.org/) 2.0.0
        * [runipy](https://pypi.python.org/pypi/runipy) 0.0.8
    * [Pandas](http://pandas.pydata.org/) 0.14.0
    * [PyTables](http://www.pytables.org/moin) 3.1.1
    * [joblib](https://pythonhosted.org/joblib/) 0.8.0 alpha 3
    * [GNU Parallel](http://www.gnu.org/software/parallel/) 20121122 &dagger;

* Graphics and visualization:
    * [Matplotlib](http://matplotlib.org/) 1.3.1
    * [MPLD3](http://mpld3.github.io/) 0.2
    * [prettyplotlib](http://olgabot.github.io/prettyplotlib/) 0.1.7
    * [brewer2mpl](https://github.com/jiffyclub/brewer2mpl) 1.4
    * [Seaborn](http://www.stanford.edu/~mwaskom/software/seaborn/) 0.3.1
    * [Pillow](http://python-imaging.github.io/) 2.4.0

* Machine learning and inference:
    * [scikit-learn](http://scikit-learn.org/) 0.15 dev
    * [PyMC](http://pymc-devs.github.io/pymc/) 3.0 alpha
    * [emcee](http://dan.iel.fm/emcee/current/) 2.1.0
    * [Stan/PyStan](http://mc-stan.org/) 2.2.0.2 &Dagger;
    * [Theano](http://deeplearning.net/software/theano/) 0.6.0
    * [DEAP](https://code.google.com/p/deap/) 1.0.1
    * [fastcluster](http://danifold.net/fastcluster.html) 1.1.13
    * [Vowpal Wabbit](https://github.com/JohnLangford/vowpal_wabbit/wiki) 7.6.1 &Dagger;
        * [Wabbit Wappa](https://github.com/andrewclegg/wabbit_wappa) 0.2.0-p3 dev

* Natural language processing and text mining:
    * [gensim](http://radimrehurek.com/gensim) 0.9.1
    * [NLTK](http://www.nltk.org/nltk3-alpha/) 3.0 alpha 3 (very experimental)

* Numeric and statistical computing:
    * [NumPy](http://www.numpy.org/) 1.8.1
    * [SciPy](http://www.scipy.org/) 0.14.0
    * [Bottleneck](http://berkeleyanalytics.com/bottleneck/) 0.8.0
    * [Statsmodels](http://statsmodels.sourceforge.net/) 0.6.0 dev
    * [lifelines](https://github.com/CamDavidsonPilon/lifelines/) 0.4.0.0
    * [Patsy](http://patsy.readthedocs.org/en/latest/) 0.2.1
    * [Theano](http://deeplearning.net/software/theano/) 0.6.0
    * [numexpr](https://github.com/pydata/numexpr) 2.4
    * [SymPy](http://sympy.org/) 0.7.5
    * [OpenBLAS](http://www.openblas.net/) 
    * [R](http://www.r-project.org/) 2.14.1 &Dagger;
        * [r-base-dev and r-recommended](http://cran.r-project.org/bin/linux/ubuntu/) packages
        * [rpy2](http://rpy.sourceforge.net/rpy2.html) and [rmagic](http://ipython.org/ipython-doc/dev/config/extensions/rmagic.html) 2.3.10
    * [Octave](http://www.gnu.org/software/octave/) 3.2.4 &Dagger;
        * [oct2py](https://pypi.python.org/pypi/oct2py) and [octavemagic](http://nbviewer.ipython.org/github/blink1073/oct2py/blob/master/example/octavemagic_extension.ipynb) 1.3.0

* Performance optimization:
    * [Cython](http://cython.org/) 0.21 dev
    * [Numba](https://github.com/numba/numba/) 0.13.1

* Connectivity and interoperability:
    * [lxml](http://lxml.de/lxmlhtml.html) 3.3.5
    * [Psycopg](http://initd.org/psycopg/) 2.5.2
    * [pymssql](http://www.pymssql.org/) 2.1.0

*&dagger; Non-Python tools*

*&Dagger; Non-Python tools usable via Python wrapper packages*

You are, of course, free to remove or upgrade these packages via `pip` or
`apt-get` as usual, or experiment with additional ones. Please feel free to
send pull requests when you get another package working.

Coming soon: Other Python versions. Ubuntu 14.04 LTS.

Potential future additions include: Parakeet, pattern, CrossCat, BayesDB,
ggplot, Bokeh, Blaze, numdifftools, PuLP, CVXPY, SysCorr, bayesian, PEBL,
libpgm, BayesPy, BayesOpt, mpld3, Pylearn2, nimfa, py-earth, Orange, NeuroLab,
PyBrain, annoy, Zipline, Quandl, BNFinder, Alchemy API, xlrd/xlwt, NetworkX,
PyMVPA, OpenCV, boto, gbq, SQLite, PyMongo, mpi4py, Jubatus, and one or
more Hadoop clients.

If you have suggestions for any other packages to add, please submit them by
raising an [issue](https://github.com/andrewclegg/snake-charmer/issues).

## Requirements

Snake Charmer runs IPython and all the associated tools in a sandboxed virtual
machine. It relies on [Vagrant](http://www.vagrantup.com/) for creating and
managing these, and [VirtualBox](https://www.virtualbox.org/) for running them
-- so please go and install those now.

*Experienced users of other virtualization platforms can edit the Vagrantfile
to use one of these instead, if they prefer.*

Everything else is installed automatically.

## Installation

Check out this git repository:

    # Either via ssh...
    git clone git@github.com:andrewclegg/snake-charmer.git
    # Or via https...
    git clone https://github.com/andrewclegg/snake-charmer.git
    
    # Then change into your new Snake Charmer directory...
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

### Testing your installation

The link above will take you to a fully-kitted-out IPython Notebook server.
Open the "Hello World" notebook to see a full list of installed packages and
other system information. **N.B.** The notebook server is started with inline
graphics enabled for matplotlib, but _not_ the `--pylab` option, as this is
[considered harmful](http://carreau.github.io/posts/10-No-PyLab-Thanks.ipynb.html).

There is also a "Snake Charmer QA" notebook supplied. This allows you to run
the test suites of the major components, but **don't** run this now! It's a
slow process and only needs to be performed if you've customized your VM. See
the [customization guide](CUSTOMIZING.md) for more information.

## Vagrant essentials

On a VM that's already been fully configured, `vagrant up` will just restart
it, without going through the full install process.

You can log into the server via

    vagrant ssh charmed34

from the same directory, for full command-line control. It's an Ubuntu 12.04
box, under the covers. But you can do most things through the IPython Notebook
anyway, so this is rarely essential.

Some more useful commands:

    vagrant reload charmed34  # reboot the VM (same as "vagrant up" if it's not running)
    vagrant halt charmed34    # shut down the VM, reclaim the memory it used
    vagrant destroy charmed34 # wipe it completely, reclaiming disk space too
    vagrant suspend charmed34 # 'hibernate' the machine, saving current state
    vagrant resume charmed34  # 'unhibernate' the machine

See the [Vagrant docs](http://docs.vagrantup.com/v2/cli/index.html) for more
details.

## Folder structure

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
folders will be visible to all of them -- apart from `/srv/log` which is
specific to one VM only.

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

These are all configurable via environment variables -- see the
[customization guide](CUSTOMIZING.md).

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

If you want to make another folder available to the VM, for example if your
datasets are stored on another disk, see the [customization guide](CUSTOMIZING.md).

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

Finally, you could try deleting your VirtualBox machines and Vagrant configuration
files:

    VBoxManage controlvm charmed34 poweroff
    VBoxManage unregistervm charmed34 --delete
    vagrant box remove charmed34
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

## Sharing your VMs

Snake Charmer VMs are Vagrant VMs, and Vagrant VMs can be published, shared
and remotely accessed via various mechanisms. This is discussed in the
[Snake Charmer F.A.Q.](FAQ.md).

## Customizing your VMs

Even if you don't know much about VirtualBox, Vagrant or Salt, you can
customize your VMs in several ways -- and if you want to tinker with the
configuration for these programs directly, the sky's the limit. See the
separate [customization guide](CUSTOMIZING.md).

## F.A.Q.

See the separate [Snake Charmer F.A.Q.](FAQ.md).

## Credits

Developed by [Andrew Clegg](https://github.com/andrewclegg) (Twitter:
[@andrew_clegg](http://twitter.com/andrew_clegg)), tested at
[Pearson](http://labs.pearson.com/).

Thanks to the authors and contributors of all the world-class open source
components included, whose hard work has made this possible.

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

