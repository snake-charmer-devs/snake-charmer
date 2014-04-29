# DO NOT SWITCH STATE AUTO ORDERING OFF!

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

man_dir_check:
    cmd.run:
        - name: test -d /usr/local/man || ln -sf /usr/local/share/man /usr/local/man
        - user: root
        - group: root

# Install Python etc.

python_pkgs:
    pkg.installed:
        - pkgs:
            - python{{ pyver }}
            - python{{ pyver }}-dev
            - python{{ pyver }}-doc

distribute:
    cmd.run:
        - name: python{{ pyver }} /vagrant/distribute_setup.py

pip:
    cmd.run:
        - name: easy_install-{{ pyver }} pip

{% set pip = 'pip' + pyver %}
{% set pyver_ints = pyver|replace('.', '') %}
{% set piplog = '/vagrant/pip_' + pyver_ints + '.log' %}
{% set pipcache = '/vagrant/.cache/pip' %}
{% set gitcache = '/vagrant/.cache/src' %}

{{ piplog }}:
    file.absent

# Loop through pillar data and install all standard source-based packages.
# Handle them differently depending on whether they're github or pypi based.
# Some of them have post-processing steps inserted after them.

{% for pkg in pillar['pip_pkgs'] %}

{{ pkg['name'] }}:
    {% if pkg['git'] is defined %}
    # Checkout/refresh from github
    git.latest:
        - name: {{ pkg['git'] }}
        {% if pkg['rev'] is defined %}
        - rev: {{ rev }}
        {% endif %}
        - target: {{ gitcache }}/{{ pkg['name'] }}
        - force_checkout: true
        {% if pkg['name'] == 'Theano' %}
    # Remove invalid character from Theano -- temporary workaround
    file.managed:
        - name: {{ gitcache }}/{{ pkg['name'] }}/NEWS.txt
        - contents: "Dummy file"
    # Supply rc file to use correct fortran libraries
    file.managed:
        - source: salt://theanorc
        - user: vagrant
        - group: vagrant
        - mode: 655
        {% endif %}
    # Build and install from local working copy
    cmd.run:
        - name: {{ pip }} install --log "{{ piplog }}" "{{ gitcache }}/{{ pkg['name'] }}"
    {% else %}
    # Build and install from PyPI, caching downloaded package
    cmd.run:
        - name: {{ pip }} install --log "{{ piplog }}" --download-cache "{{ pipcache }}" "{{ pkg['name'] }}/{{ pkg['version'] }}"
    {% endif %}
    {% if pkg['name'] == 'ipython' %}
    # Install mathjax so we can use iPython without internet
    cmd.run:
        - name: python{{ pyver }} -c "from IPython.external.mathjax import install_mathjax; install_mathjax()"
    {% endif %}

{% endfor %}

# Upstart service configuration - start on boot

/etc/init/ipynb.conf:
    file.managed:
        - source: salt://ipynb.upstart
        - user: root
        - group: root
        - mode: 655
        - template: jinja

ipynb:
    service.running:
        - enable: True
        - require:
            - file: /etc/init/ipynb.conf

# TODO
# Move apt pkg list to pillar
# Run more test suites
# Install R
# Clipboard integration?
# Fix version numbers, so it's reproducible
# Notebook security: http://ipython.org/ipython-doc/stable/notebook/public_server.html
