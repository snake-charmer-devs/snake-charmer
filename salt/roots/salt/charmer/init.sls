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

{{ piplog }}:
    file.managed:
        - contents: ""

# numpy and scipy first.

numpy:
    cmd.run:
        - name: {{ pip }} install --log {{ piplog }} numpy
        - require:
            - cmd: pip
            - file: {{ piplog }}

Scipy:
    cmd.run:
        - name: {{ pip }} install --log {{ piplog }} scipy
        - require:
            - cmd: numpy

# Remove invalid character from Theano -- temporary workaround.

https://github.com/Theano/Theano.git:
    git.latest:
        - rev: {{ theanover }}
        - target: /root/Theano
        - force_checkout: True

/root/Theano/NEWS.txt:
    file.managed:
        - contents: "Dummy file"
        - require:
            - git: https://github.com/Theano/Theano.git

theano:
    cmd.run:
        - name: {{ pip }} install --log {{ piplog }} /root/Theano
        - require:
            - cmd: scipy
            - file: /root/Theano/NEWS.txt

# Use a script to install the rest individually, as some of them
# will get messed up if they are installed together.

pip_pkgs:
    cmd.run:
        - name: /vagrant/install_reqs.sh "{{ pip }}" "{{ reqfile }}" "{{ piplog }}"
        - require:
            - cmd: theano

local_mathjax:
    cmd.run:
        - name: python{{ pyver }} -c "from IPython.external.mathjax import install_mathjax; install_mathjax()"
        - require:
            - cmd: pip_pkgs

/etc/init/ipynb.conf:
    file.managed:
        - source: salt://ipynb.upstart
        - user: root
        - group: root
        - mode: 655
        - template: jinja
        - defaults:
        - require:
            - cmd: local_mathjax

ipynb:
    service.running:
        - enable: True
        - require:
            - file: /etc/init/ipynb.conf

# TODO
# Shutdown minion service after provisioning?
# Run more test suites
# Install R
# Clipboard integration?
# Get rid of Github URLs, once those projects have 3.4-compatible releases
# Fix version numbers, so it's reproducible
# Notebook security: http://ipython.org/ipython-doc/stable/notebook/public_server.html

