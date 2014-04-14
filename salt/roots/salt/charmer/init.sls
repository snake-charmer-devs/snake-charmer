{% set pyver = pillar['pyver'] %}

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
{% set logfile = '/vagrant/pip_' + pyver_ints + '.log' %}

new_distribute:
    cmd.run:
        - name: {{ pip }} install --upgrade distribute
        - require:
            - cmd: pip

pip_pkgs:
    cmd.run:
        - name: /vagrant/install_reqs.sh "{{ pip }}" "{{ reqfile }}" "{{ logfile }}"
        - require:
            - cmd: new_distribute

# TODO
# Check distribute upgrade doesn't break anything else
# Run test suites
# Start iPython service (forever?)
# Install R
# Clipboard integration?
# Fix scikit-learn and statsmodels URLs, once they have 3.4-compatible releases
# Fix version numbers, so it's reproducible

