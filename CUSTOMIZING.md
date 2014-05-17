# Snake Charmer

## Customization guide

This document discusses some ways to customize your VMs and create new ones.

### Environment variables

Snake Charmer recognizes a number of environment variables that can be used to
modify the behaviour of VMs without editing config files. Set these as
appropriate for your environment, then `vagrant up` or `vagrant reload`.

* `CHARMER_RAM` (integer; default 2048)

Amount of memory to supply to each VM, in megabytes. 1000 is probably the
minimum you can get away with.

* `CHARMER_CPUS` (integer; default 2)

Number of virtual CPUs to give each VM. Most Python programs will run happily
on one CPU. If you're using multiprocessing, IPython clustering, or running the
test suite (see below), raise this as high as you can -- but bear in mind
you'll probably need to raise `CHARMER_RAM` somewhat too.

* `CHARMER_SLIM` (boolean; default "false")

If set to "true" this will disable downloading of some example data files after
provisioning, to speed up VM creation. Currently this just disables the
[NLTK downloader](http://www.nltk.org/data.html).

* `CHARMER_TEST` (boolean; default "false")

If set to "true" this will run test suites for the major packages supplied, at
the end of provisioning. The results will be written into
`log/<VM name>/test_output`.

**This will take several hours even on a decent server.** Raise `CHARMER_CPUS`
as high as you can (not more than your host machine's number of cores though)
as tests are run in parallel where possible. Make sure you raise `CHARMER_RAM`
high enough to avoid swapping or out-of-memory errors. We use 16 CPUs and 8000
MB RAM for testing.

### Editing the package list

**TODO**

### Hacking Vagrant

#### Syncing additional folders

#### Deploying to Amazon AWS

**TODO**

### Creating new VMs

**TODO**

