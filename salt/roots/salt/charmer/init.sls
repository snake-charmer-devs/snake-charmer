python-software-properties:
    pkg.installed

pandoc:
    pkg.installed

libfreetype6-dev:
    pkg.installed

gfortran:
    pkg.installed

libpq-dev:
    pkg.installed

libhdf5-serial-1.8.4:
    pkg.installed

libhdf5-serial-dev:
    pkg.installed

libpng12-0:
    pkg.installed

libpng12-dev:
    pkg.installed

# scipy won't build when this is enabled, but we may not need it
# libsuitesparse-dev:
#     pkg.installed

g++:
    pkg.installed

git:
    pkg.installed

atlas:
    pkg.installed:
        - pkgs:
            - libatlas3gf-base
            - libatlas-base-dev
            - libatlas-dev
            - liblapack3gf
            - liblapack-dev

xml_libs:
    pkg.installed:
        - pkgs:
            - libxml2-dev
            - libxslt1-dev

deadsnakes:
    pkgrepo.managed:
        - ppa: fkrull/deadsnakes
        - require:
            - pkg: python-software-properties

python_pkgs:
    pkg.installed:
        - pkgs:
            - python{{ pillar['pyver'] }}
            - python{{ pillar['pyver'] }}-dev
            - python{{ pillar['pyver'] }}-doc
        - require:
            - pkgrepo: deadsnakes

distribute_setup:
    cmd.run:
        - name: python{{ pillar['pyver'] }} /vagrant/distribute_setup.py
        - require:
            - pkg: python_pkgs

pip_setup:
    cmd.run:
        - name: easy_install-{{ pillar['pyver'] }} pip
        - require:
            - cmd: distribute_setup

numpy_setup:
    cmd.run:
        - name:  pip{{ pillar['pyver'] }} install numpy
        - require:
            - pkg: pip_setup
            - pkg: libfreetype6-dev
            - pkg: gfortran
            - pkg: atlas

scipy_setup:
    cmd.run:
        - name: pip{{ pillar['pyver'] }} install scipy
        - require:
            - cmd: numpy_setup
            - pkg: g++

matplotlib_setup:
    cmd.run:
        - name: pip{{ pillar['pyver'] }} install matplotlib
        - require:
            - cmd: scipy_setup
            - pkg: libpng12-0
            - pkg: libpng12-dev

# Temporary URL, as there's no 3.4-compatible release yet
skl_setup:
    cmd.run:
        - name: pip{{ pillar['pyver'] }} install git+https://github.com/scikit-learn/scikit-learn.git@c3ab3baf85bb6abbfc3c4c3aa6dd099acc0c4815
        - require:
            - cmd: scipy_setup
            - pkg: git

pytables_reqs:
    cmd.run:
        - name: pip{{ pillar['pyver'] }} install numexpr cython
        - require:
            - cmd: numpy_setup
            - pkg: libhdf5-serial-dev
            - pkg: libhdf5-serial-1.8.4

toolkit:
    cmd.run:
        - name: pip{{ pillar['pyver'] }} install ipython[all] prettyplotlib seaborn pandas sympy nose deap psycopg2 pymc lxml theano tables fastcluster
        - require:
            - cmd: scipy_setup
            - cmd: matplotlib_setup
            - cmd: pytables_reqs
            - pkg: libpq-dev
            - pkg: xml_libs


