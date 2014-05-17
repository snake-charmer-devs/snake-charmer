#! {{ python }}

import urllib.request
from sys import argv

{% set pkgs = pillar['pip_pkgs'] %}
{# FIXME #}
{% do pkgs.append({'name': 'gensim'}) %}
{% for pkg in pkgs %}

{% if pkg['import'] is defined %}
    {% set name = pkg['import'] %}
{% else %}
    {% set name = pkg['name']|lower %}
{% endif %}

print("Checking {{ name }} is intact...")
import {{ name }}
try:
    print("Imported {{ name }} %s OK" % {{ name }}.__version__)
except AttributeError:
    print("Imported {{ name }} %s OK")

{% endfor %}

req = urllib.request.Request('{{ nb_url }}')
response = urllib.request.urlopen(req)

print("Your VM is up and running: {{ nb_url }}")

