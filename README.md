# Snake Charmer

Portable virtual machines for scientific Python, using Vagrant.

## *Work in progress - not yet fully tested*

## Introduction

Wouldn't it be great if you could magic up a local IPython Notebook server,
complete with SciPy, Pandas, Matplotlib, PyMC, scikit-learn and all the usual
goodness, and running the latest version of Python, just by typing one line?

    vagrant up charmed34

And wouldn't it be great if you could do that from pretty much any Windows,
Mac or Linux machine, and know that you'd get the exact same environment every
time?

Well, read on.

## Requirements

Snake Charmer runs IPython and all the associated tools in a sandboxed virtual
machine. It relies on [Vagrant](http://www.vagrantup.com/) for creating and
managing these, and [VirtualBox](https://www.virtualbox.org/) for running them
 -- so please go and install those now.

(Experienced users of other VM hosting platforms can edit the Vagrantfile to
use one of these instead, if they prefer.)

## Getting started

Check out this git repository:

    git clone git@github.com:andrewclegg/snake-charmer.git
    cd snake-charmer

Start the VM:

    vagrant up charmed34

This command currently takes an hour or so to install all the necessary
software. When it completes, click the following link:

[http://localhost:8834/](http://localhost:8834/)

This will take you to a fully-kitted-out IPython Notebook server.

On a VM that's already been fully configured, `vagrant up` will just restart
it and check a few components are up to date, without going through the full
install process.

You can log into the server via

    vagrant ssh charmed34

from the same directory, for full command-line control. It's an Ubuntu 12.10
box, under the covers.

Some more useful commands:

    vagrant halt charmed34    # shut down the VM, reclaim the memory it used
    vagrant destroy charmed34 # wipe it completely, reclaiming disk space too
    vagrant suspend charmed34 # 'hibernate' the machine, saving current state
    vagrant resume charmed34  # 'unhibernate' the machine

See the [Vagrant docs](http://docs.vagrantup.com/v2/cli/index.html) for
more details.

The `snake-charmer` directory where you run these commands from is visible
from within the VM as `/vagrant`, so to make data available to the VM,
just copy it into there (or move or symlink it).

You can see this in action by entering the following in a Notebook cell:

    import os
    os.listdir('/vagrant')

This will show you all the files in your installation directory.

Actually, this is also used as the current working directory for your IPython
Notebook server, so any notebooks you create will appear hear. (NB This may
change later...)

## What is included

Snake Charmer is designed to provide an out-of-the-box workbench for data
analysis, statistical modelling, machine learning, mathematical programming
and visualization.

It is designed to be used primarily via IPython Notebook.

The environment is based on Ubuntu 12.10 and Python 3.4, with
the following modules installed.

* Data handling and processing:
    * [IPython](http://ipython.org/)
    * [Pandas](http://pandas.pydata.org/)
    * [PyTables](http://www.pytables.org/moin)
    * [lxml](http://lxml.de/lxmlhtml.html)
    * [Psycopg](http://initd.org/psycopg/)

* Graphics and visualization:
    * [Matplotlib](http://matplotlib.org/)
    * [prettyplotlib](http://olgabot.github.io/prettyplotlib/)
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

Coming soon: NLTK, other Python versions.

Potential future additions include: CrossCat, BayesDB, Bokeh, Blaze, Numba,
gensim, mpld3, Pylearn2, cudamat, Gnumpy, py-earth, Orange, NeuroLab, PyBrain,
scikits-sparse, annoy, Zipline, Quandl, Alchemy API, openpyxl, xlrd/xlwt,
OpenCV, boto, gbq, SQLite, and one or more Hadoop clients.

## Under the covers

## Customizing your VM

## License

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

