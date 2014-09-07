# DO NOT SWITCH STATE AUTO ORDERING OFF!
# We just allow Salt to apply these states in order, instead of manually
# specifying dependencies.

{% set pyver = pillar['pyver'] %}
{% set theanover = pillar['theanover'] %}
{% set pyver_ints = pyver|replace('.', '') %}
{% set piplog = '/srv/log/pip.log' %}
{% set pipcache = '/srv/cache/pip' %}
{% set gitcache = '/srv/cache/src' %}

# Fix Grub boot issue: http://serverfault.com/a/482020

/etc/default/grub:
    file.append:
        - text: GRUB_RECORDFAIL_TIMEOUT=2

update-grub:
    cmd.run

# Some scripts we'll need

/root/bin:
    file.recurse:
        - source: salt://bin
        - template: jinja
        - dir_mode: '0755'
        - file_mode: '0755'
        - context: 
                python: /usr/bin/python{{ pyver }}
                nb_url: http://localhost:88{{ pyver_ints }}/tree

# Replace apt package cache with symlink to folder shared from host

/var/cache/apt/archives:
    file.symlink:
        - target: /srv/cache/apt
        - force: true

# Install apt packages from standard repos

apt_pkgs:
    pkg.installed:
        - pkgs: 
            {{ pillar['apt_pkgs'] }}

# OpenBLAS

https://github.com/xianyi/OpenBLAS.git:
    git.latest:
        - rev: {{ pillar['openblas_rev'] }}
        - target: {{ gitcache }}/OpenBLAS
        - force_checkout: true

openblas:
    cmd.run:
        - name: make NUM_THREADS={{ pillar['blas_max_threads'] }} NO_AFFINITY=0 GEMM_MULTITHREAD_THRESHOLD=8 USE_OPENMP=1 NO_WARMUP=1 FC=gfortran && make PREFIX=/usr/local install && ldconfig
        - cwd: {{ gitcache }}/OpenBLAS

/root/.numpy-site.cfg:
    file.managed:
        - source: salt://etc/numpy-site.cfg
        - mode: 655

/home/vagrant/.numpy-site.cfg:
    file.managed:
        - source: salt://etc/numpy-site.cfg
        - user: vagrant
        - group: vagrant
        - mode: 655

# scipy won't build when this is enabled, but we may not need it
# libsuitesparse-dev:
#     pkg.installed

# Additional apt repositories

deadsnakes:
    pkgrepo.managed:
        - ppa: fkrull/deadsnakes

# FIXME the following repo is currently version-specific

cran:
    pkgrepo.managed:
        - name: deb http://cran.ma.imperial.ac.uk/bin/linux/ubuntu precise/

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
            - python{{ pyver }}-tk

{% set easy_install = 'easy_install-' ~ pyver %}
{% set pip = 'pip' ~ pyver %}

distribute:
    cmd.run:
        - name: python{{ pyver }} /root/bin/distribute_setup.py
        - unless: which {{ easy_install }}

pip:
    cmd.run:
        - name: {{ easy_install }} pip
        - unless: which {{ pip }}

{{ piplog }}:
    file.absent

# Loop through pillar data and install all standard Python packages.
# Handle them differently depending on whether they're github or pypi based.
# Some of them have post-processing steps inserted after them.

{% for pkg in pillar['pip_pkgs'] %}
{% set name = pkg['name'] %}

{% if pkg['git'] is defined %}
    {% set url = pkg['git'] %}
    {% set src = gitcache ~ '/' ~ name %}
    {% set dev_pkgs = '/home/vagrant/lib/dev-packages' %}

# Checkout/refresh from github
{{ url }}:
    git.latest:
        {% if pkg['rev'] is defined %}
        - rev: {{ pkg['rev'] }}
        {% endif %}
        - target: {{ src }}
        - force_checkout: true

    {% if name == 'Theano' %}
# Remove invalid character from Theano -- temporary workaround
{{ src }}/NEWS.txt:
    file.managed:
        - contents: "Dummy file"

# Supply rc file to use correct fortran libraries
/home/vagrant/.theanorc:
    file.managed:
        - source: salt://etc/theanorc
        - user: vagrant
        - group: vagrant
        - mode: 655
    {% endif %}

    {% if pkg.get('export', false) %}
        {% set install_from = dev_pkgs ~ '/' ~ name %}
# Copy out of cache before installing
{{ name }}_export:
    cmd.run:
        - name: git checkout-index -a -f --prefix={{ install_from }}/
        - cwd: {{ src }}
        - user: vagrant
    {% else %}
        {% set install_from = src %}
    {% endif %}

    {% if pkg['setup'] is defined %}
# Non-pip custom installation is required
{{ name }}_install:
    cmd.run:
        - name: {{ pkg['setup'] }} >> "{{ piplog }}" 2>&1
        - cwd: {{ install_from }}
    {% else %}
# Build and install from local copy via pip
{{ name }}_install:
    cmd.run:
        - name: {{ pip }} install --log "{{ piplog }}" "{{ install_from }}"
    {% endif %}

{% else %}

    {% if pkg['ver'] is defined %}
        {% set spec = name ~ pkg['ver'] %}
    {% else %}
        {% set spec = name %}
    {% endif %}

# Build and install from PyPI, caching downloaded package
{{ name }}_install:
    cmd.run:
        - name: {{ pip }} install --log "{{ piplog }}" --download-cache "{{ pipcache }}" "{{ spec }}"

{% endif %}

    {% if name == 'ipython' %}
# Install mathjax so we can use iPython without internet
local_mathjax:
    cmd.run:
        - name: python{{ pyver }} -c "from IPython.external.mathjax import install_mathjax; install_mathjax()"
    {% endif %}

{% endfor %}

# Vowpal Wabbit

https://github.com/JohnLangford/vowpal_wabbit.git:
    git.latest:
        - rev: {{ pillar['vw_rev'] }}
        - target: {{ gitcache }}/vowpal_wabbit
        - force_checkout: true

vw:
    cmd.run:
        - cwd: {{ gitcache }}/vowpal_wabbit
        - name: make

/usr/local/bin/vw:
    file.copy:
        - source: {{ gitcache }}/vowpal_wabbit/vowpalwabbit/vw
        - force: true

# Matplotlib config for use without a GUI

/home/vagrant/.config/matplotlib/matplotlibrc:
    file.managed:
        - source: salt://etc/matplotlibrc
        - makedirs: true
        - user: vagrant
        - group: vagrant
        - mode: 655

# Upstart service configuration -- start on boot

/etc/init/ipynb.conf:
    file.symlink:
        - target: /root/bin/ipynb.upstart

# Why is this even necessary dammit!
initctl reload-configuration:
    cmd.run

ipynb:
    service.running:
        - enable: True

{% if not pillar.get('slimline', false) %}

# Download NLTK sample data

nltk_data:
    cmd.run:
        - name: python{{ pyver }} -m nltk.downloader all
        - user: vagrant
        - group: vagrant

# Install dependencies for OpenCV

# Commented out for now, as it's extra bloat unless we actually need it

#opencv_deps:
#    pkg.installed:
#        - pkgs: 
#            {{ pillar['opencv_deps'] }}

{% endif %}

{% if pillar.get('run_tests', false) %}

# Run full test suite

# TODO set up runipy; currently does nothing

{% endif %}


