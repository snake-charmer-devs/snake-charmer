# DO NOT SWITCH STATE AUTO ORDERING OFF!
# We just allow Salt to apply these states in order, instead of manually
# specifying dependencies.

{% set pyver = pillar['pyver'] %}
{% set theanover = pillar['theanover'] %}
{% set pyver_ints = pyver|replace('.', '') %}

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

{% set piplog = '/srv/log/pip.log' %}
{% set pipcache = '/srv/cache/pip' %}
{% set gitcache = '/srv/cache/src' %}

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

# Build and install from local working copy
{{ name }}_install:
    cmd.run:
        - name: {{ pip }} install --log "{{ piplog }}" "{{ src }}"

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

# Upstart service configuration -- start on boot

/etc/init/ipynb.conf:
    file.symlink:
        - target: /root/bin/ipynb.upstart

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

{% endif %}

# gensim pip installation appears to be broken -- temp workaround

{% set src = gitcache ~ '/gensim' %}

https://github.com/piskvorky/gensim.git:
    git.latest:
        - rev: d1c6d58b9acfec97e6c5d677c652293ae2119276
        - target: {{ src }}
        - force_checkout: true

gensim_install:
    cmd.run:
        - name: cd {{ src }} && python{{ pyver }} setup.py install

{% if pillar.get('run_tests', false) %}

# Run full test suite

run_tests:
    cmd.run:
        - name: /root/bin/run_tests python{{ pyver }} /srv/log/test_output

{% endif %}


