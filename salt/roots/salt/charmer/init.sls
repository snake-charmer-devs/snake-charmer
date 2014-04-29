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
            - libtiff4-dev
            - libjpeg8-dev
            - zlib1g-dev
            - libfreetype6-dev
            - liblcms1-dev
            - libwebp-dev
            - tcl8.5-dev
            - tk8.5-dev

# scipy won't build when this is enabled, but we may not need it
# libsuitesparse-dev:
#     pkg.installed

deadsnakes:
    pkgrepo.managed:
        - ppa: fkrull/deadsnakes
        - require:
            - pkg: apt_pkgs

# Workarounds for annoying dangling symlink:
# https://github.com/nose-devs/nose/issues/731

/usr/local/share/man:
    file.directory:
        - user: root
        - group: root
        - dir_mode: 755
        - follow_symlinks: True
        - recurse:
            - user
            - group
            - mode
        - require:
            - pkg: apt_pkgs

man_dir_check:
    cmd.run:
        - name: test -d /usr/local/man || ln -sf /usr/local/share/man /usr/local/man
        - user: root
        - group: root
        - require:
            - file: /usr/local/share/man

# Install Python etc.

python_pkgs:
    pkg.installed:
        - pkgs:
            - python{{ pyver }}
            - python{{ pyver }}-dev
            - python{{ pyver }}-doc
        - require:
            - pkgrepo: deadsnakes
            - cmd: man_dir_check

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
{% set pipcache = '/vagrant/pip_cache' %}

{{ piplog }}:
    file.absent

# Now the Python packages -- numpy and scipy first.

numpy:
    cmd.run:
        - name: {{ pip }} install --log {{ piplog }} --download-cache {{ pipcache }} numpy==1.8.1 # FIXME param
        - require:
            - cmd: pip
            - file: {{ piplog }}

scipy:
    cmd.run:
        - name: {{ pip }} install --log {{ piplog }} --download-cache {{ pipcache }} scipy==0.13.3 # FIXME param
        - require:
            - cmd: numpy

# Remove invalid character from Theano -- temporary workaround.

https://github.com/Theano/Theano.git:
    git.latest:
        - rev: {{ theanover }}
        - target: /root/src/theano
        - force_checkout: True

/root/src/theano/NEWS.txt:
    file.managed:
        - contents: "Dummy file"
        - require:
            - git: https://github.com/Theano/Theano.git

theano:
    cmd.run:
        - name: {{ pip }} install --log {{ piplog }} /root/src/theano#egg=Theano
        - require:
            - cmd: scipy
            - file: /root/src/theano/NEWS.txt

# Needed to use the right Fortran libs

/home/vagrant/.theanorc:
    file.managed:
        - source: salt://theanorc
        - user: vagrant
        - group: vagrant
        - mode: 655
        - require:
            - cmd: theano

# Use a script to install the rest individually, as some of them
# will get messed up if they are installed together.

pip_pkgs:
    cmd.run:
        - name: /vagrant/install_reqs.sh "{{ pip }}" "{{ reqfile }}" "{{ piplog }}" "{{ pipcache }}"
        - require:
            - cmd: theano
            - file: /home/vagrant/.theanorc

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
# Version numbers for scipy and numpy
# Run more test suites
# Install R
# Clipboard integration?
# Get rid of Github URLs, once those projects have 3.4-compatible releases
# Fix version numbers, so it's reproducible
# Notebook security: http://ipython.org/ipython-doc/stable/notebook/public_server.html
