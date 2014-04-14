# Needed for proper PPA management

pandoc:
    pkg.installed

freetype*:
    pkg.installed

gfortran:
    pkg.installed

libpq-dev:
    pkg.installed

# scipy won't build when this is enabled, but we may not need it
# libsuitesparse-dev:
#     pkg.installed

g++:
    pkg.installed

python-software-properties:
    pkg.installed

atlas:
    pkg.installed:
        - pkgs:
            - libatlas3gf-base
            - libatlas-base-dev
            - libatlas-dev
            - liblapack3gf
            - liblapack-dev

deadsnakes:
    pkgrepo.managed:
        - ppa: fkrull/deadsnakes
        - watch:
            - pkg: python-software-properties

python_pkgs:
    pkg.installed:
        - pkgs:
            - python{{ pillar['pyver'] }}
            - python{{ pillar['pyver'] }}-dev
        - watch:
            - pkgrepo: deadsnakes

ez_setup:
    cmd.run:
        - name: python{{ pillar['pyver'] }} /vagrant/ez_setup.py
        - creates: /usr/local/bin/easy_install-{{ pillar['pyver'] }}
        - watch:
            - pkg: python_pkgs

pip_setup:
    cmd.run:
        - name: easy_install-{{ pillar['pyver'] }} pip
        - creates: /usr/local/bin/pip{{ pillar['pyver'] }}
        - watch:
            - pkg: ez_setup

numpy_setup:
    cmd.run:
        - name:  pip{{ pillar['pyver'] }} install numpy
        - creates: /usr/local/lib/python{{ pillar['pyver'] }}/dist-packages/numpy/version.py
        - watch:
            - pkg: pip_setup
            - pkg: freetype*
            - pkg: gfortran
            - pkg: atlas

scipy_setup:
    cmd.run:
        - name: pip{{ pillar['pyver'] }} install scipy
        - creates: /usr/local/lib/python{{ pillar['pyver'] }}/dist-packages/scipy/version.py
        - watch:
            - cmd: numpy_setup
            - pkg: g++

libs_setup:
    cmd.run:
        - name: pip{{ pillar['pyver'] }} install ipython[all] matplotlib prettyplotlib seaborn pandas sympy nose scikit-learn deap psycopg2 pymc lxml theano tables fastcluster
        - watch:
            - cmd: scipy_setup
            - pkg: libpq-dev


