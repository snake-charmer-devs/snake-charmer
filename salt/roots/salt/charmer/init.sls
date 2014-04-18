{% set pyver = pillar['pyver'] %}
{% set theanover = pillar['theanover'] %}

apt_pkgs:
    pkg.installed:
        - pkgs: 
            - python-software-properties
            - pandoc
            - libfreetype6-dev
            - gfortran
            - libpq-dev
            - libhdf5-serial-dev
            - libpng12-dev
            - g++
            - git
            - libatlas3gf-base
            - libatlas-base-dev
            - libatlas-dev
            - liblapack3gf
            - liblapack-dev
            - libxml2-dev
            - libxslt1-dev
            - libzmq-dev

# scipy won't build when this is enabled, but we may not need it
# libsuitesparse-dev:
#     pkg.installed

deadsnakes:
    pkgrepo.managed:
        - ppa: fkrull/deadsnakes
        - require:
            - pkg: apt_pkgs

python_pkgs:
    pkg.installed:
        - pkgs:
            - python{{ pyver }}
            - python{{ pyver }}-dev
            - python{{ pyver }}-doc
        - require:
            - pkgrepo: deadsnakes

distribute:
    cmd.run:
        - name: python{{ pyver }} /vagrant/distribute_setup.py
        - require:
            - pkg: python_pkgs

pip:
    cmd.run:
        - name: easy_install-{{ pyver }} pip
        - require:
            - cmd: distribute

{% set pip = 'pip' + pyver %}
{% set pyver_ints = pyver|replace('.', '') %}
{% set reqfile = '/vagrant/requirements.' + pyver_ints %}
{% set piplog = '/vagrant/pip_' + pyver_ints + '.log' %}

# numpy and scipy first.

numpy:
    cmd.run:
        - name: {{ pip }} install --log {{ piplog }} numpy
        - require:
            - cmd: pip

scipy:
    cmd.run:
        - name: {{ pip }} install --log {{ piplog }} scipy
        - require:
            - cmd: numpy

# Remove invalid character from Theano -- temporary workaround.

theano:
    cmd.run:
        - name: git clone https://github.com/Theano/Theano.git && cd Theano && git checkout {{ theanover }} && truncate -s 0 NEWS.txt && {{ pip }} install --log {{ piplog }} .
        - require:
            - cmd: scipy

# Use a script to install the rest individually, as some of them
# will get messed up if they are installed together.

pip_pkgs:
    cmd.run:
        - name: /vagrant/install_reqs.sh "{{ pip }}" "{{ reqfile }}" "{{ piplog }}"
        - require:
            - cmd: theano

notebook:
    cmd.run:
        - name: cd /vagrant && python{{ pyver }} -m IPython notebook --pylab inline --port 88{{ pyver_ints }}
        - require:
            - cmd: theano

# TODO
# Run more test suites
# Start iPython service
# Install R
# Clipboard integration?
# Get rid of Github URLs, once those projects have 3.4-compatible releases
# Fix version numbers, so it's reproducible
# Notebook security: http://ipython.org/ipython-doc/stable/notebook/public_server.html

