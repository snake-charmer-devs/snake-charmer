pyver: '3.4'

# Deb packages (with optional versions) to install via apt -- order is not important
# TODO fix apt version numbers -- but need a way to automate checking for updates

apt_pkgs:
    - g++
    - gfortran
    - git: 1:1.7.9.5-1
    - libatlas-base-dev
    - libatlas-dev
    - libatlas3gf-base
    - libfreetype6-dev
    - libhdf5-serial-dev
    - libjpeg8-dev
    - liblapack-dev
    - liblapack3gf
    - liblcms1-dev
    - liblzo2-dev
    - libpng12-dev
    - libpq-dev
    - libtiff4-dev
    - libwebp-dev
    - libxml2-dev
    - libxslt1-dev
    - libzmq-dev
    - parallel
    - pandoc
    - python-software-properties
    - r-base-dev
    - r-recommended
    - tcl8.5-dev
    - tk8.5-dev
    - zlib1g-dev

# Python packages to install via pip -- a list of dicts, so order is maintained

pip_pkgs:
    - name:   numpy
      ver:    ==1.8.1
    - name:   scipy
      ver:    ==0.13.3
    - name:   Theano
      git:    https://github.com/Theano/Theano.git
      rev:    46b19c24e3b04bbde3f2cf957824e07885916b9b
    - name:   numpydoc
      git:    https://github.com/numpy/numpydoc.git
      rev:    56a1b39e8b16f2292f6b2b54ce26d259003fadad
    - name:   Bottleneck
      ver:    ==0.8.0
    - name:   matplotlib
      ver:    ==1.3.1
    - name:   patsy
      ver:    ==0.2.1
    - name:   numexpr
      ver:    ==2.4
    - name:   Cython
      git:    https://github.com/cython/cython.git
      rev:    c646da0b6527bf2ad18e706eb4273c712ac356a8
    - name:   tables
      ver:    ==3.1.1
    - name:   beautifulsoup4
      ver:    ==4.2.1
      import: bs4
    - name:   lxml
      ver:    ==3.3.5
    - name:   deap
      ver:    ==1.0.1
    - name:   fastcluster
      ver:    ==1.1.13
    - name:   sympy
      ver:    ==0.7.5
    - name:   pandas
      ver:    ==0.13.1
    - name:   nose
      ver:    ==1.3.3
    - name:   statsmodels
      git:    https://github.com/statsmodels/statsmodels.git
      rev:    d7ff1828cbd7c869f93aa86ea7dcd937fa90f5ff
    - name:   pymc
      git:    https://github.com/andrewclegg/pymc
      rev:    66c3f3743de9c39643ba4fb3ef14f79e4845e8f3
    - name:   psycopg2
      ver:    ==2.5.2
    - name:   brewer2mpl
      ver:    ==1.4
    - name:   prettyplotlib
      ver:    ==0.1.7
    - name:   seaborn
      ver:    ==0.3.1
    - name:   ipython[all]
      import: IPython
      ver:    ==2.0.0
    - name:   scikit-learn
      git:    https://github.com/scikit-learn/scikit-learn.git
      rev:    c3ab3baf85bb6abbfc3c4c3aa6dd099acc0c4815
      import: sklearn
    - name:   runipy
      ver:    ==0.0.8
    - name:   Pillow
      import: PIL
      git:    https://github.com/python-imaging/Pillow.git
      rev:    84a701a82b33896a4d6997743c2131ab0a40c588
    - name:   joblib
      git:    https://github.com/joblib/joblib.git
      rev:    6c4abdb0461e65857ef3b9dd5247a6d8911ce54e
    - name:   rpy2
      ver:    ==2.3.10
    - name:   pyyaml
      import: yaml
      ver:    ==3.11
    - name:   nltk
      git:    https://github.com/nltk/nltk.git
      rev:    24e257a6fd29df503e9ffe628f96604012c8a8e1
    - name:   Pyro4
      import: Pyro4
      ver:    ==4.25


