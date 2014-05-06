pyver: '3.4'

# Deb packages (with optional versions) to install via apt -- order is not important

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
    - name:   matplotlib
    - name:   patsy
    - name:   numexpr
    - name:   Cython
      git:    https://github.com/cython/cython.git
      rev:    c646da0b6527bf2ad18e706eb4273c712ac356a8
    - name:   tables
    - name:   beautifulsoup4
      ver:    ==4.2.1
      import: bs4
    - name:   lxml
    - name:   deap
    - name:   fastcluster
    - name:   sympy
    - name:   pandas
    - name:   nose
    - name:   statsmodels
      git:    https://github.com/statsmodels/statsmodels.git
      rev:    d7ff1828cbd7c869f93aa86ea7dcd937fa90f5ff
    - name:   pymc
      git:    https://github.com/andrewclegg/pymc
      rev:    66c3f3743de9c39643ba4fb3ef14f79e4845e8f3
    - name:   psycopg2
    - name:   brewer2mpl
    - name:   prettyplotlib
    - name:   seaborn
    - name:   ipython[all]
      import: IPython
    - name:   scikit-learn
      git:    https://github.com/scikit-learn/scikit-learn.git
      rev:    c3ab3baf85bb6abbfc3c4c3aa6dd099acc0c4815
      import: sklearn
    - name:   runipy
    - name:   Pillow
      import: PIL
    - name:   joblib
    - name:   rpy2

