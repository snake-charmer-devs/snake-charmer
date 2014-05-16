#! {{ python }}

import urllib.request
from sys import argv

{% for pkg in pillar['pip_pkgs'] %}
{% if pkg['import'] is defined %}
print("Checking {{ pkg['import'] }} is intact...")
import {{ pkg['import'] }}
{% else %}
print("Checking {{ pkg['name']|lower }} is intact...")
import {{ pkg['name']|lower }}
{% endif %}
print("OK")
{% endfor %}

req = urllib.request.Request('{{ nb_url }}')
response = urllib.request.urlopen(req)

print("Your VM is up and running: {{ nb_url }}")

