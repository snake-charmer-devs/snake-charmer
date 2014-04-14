# CAUTION!
# Do not turn state_auto_order off, this will break everything.

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
            - python{{ pillar['pyver'] }}
            - python{{ pillar['pyver'] }}-dev
            - python{{ pillar['pyver'] }}-doc
        - require:
            - pkgrepo: deadsnakes

distribute:
    cmd.run:
        - name: python{{ pillar['pyver'] }} /vagrant/distribute_setup.py
        - require:
            - pkg: python_pkgs

pip:
    cmd.run:
        - name: easy_install-{{ pillar['pyver'] }} pip
        - require:
            - cmd: distribute

{% set pip = 'MAKEFLAGS=-j pip' + pillar['pyver'] %}
{% set reqfile = '/vagrant/requirements.' + pillar['pyver'] %}

pip_pkgs:
    cmd.run:
        - name: for pkg in `cat {{ reqfile }}`; do pip install "$pkg"; done
        - require:
            - cmd: pip

# TODO
# Run test suites
# Start iPython service (forever?)
# Install R
# Clipboard integration?
# Fix scikit-learn URL, once there's a 3.4-compatible release
# Fix version numbers, so it's reproducible

