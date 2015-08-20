{% from "apache/map.jinja" import apache with context %}

include:
  - apache

{{ apache.vhostdir }}:
  file.directory:
    - require:
      - pkg: apache
    - watch_in:
      - service: apache
      
/etc/httpd/conf.modules.d:
  file.directory:
    - require:
      - pkg: apache
    - watch_in:
      - service: apache    

/etc/httpd/conf.modules.d/00-base.conf:
  file.managed:
    - replace: false
    - require:
      - file: /etc/httpd/conf.modules.d
      - pkg: apache
    - source:
      - salt://jbossapache/files/{{ salt['grains.get']('os_family') }}/2.2/conf.modules.d/00-base.conf
    - template: jinja
    - watch_in:
      - service: apache   

/etc/httpd/conf.modules.d/00-dav.conf:
  file.managed:
    - replace: false
    - require:
      - file: /etc/httpd/conf.modules.d
      - pkg: apache
    - source:
      - salt://jbossapache/files/{{ salt['grains.get']('os_family') }}/2.2/conf.modules.d/00-dav.conf
    - template: jinja    
    - watch_in:
      - service: apache
      
/etc/httpd/conf.modules.d/00-proxy.conf:
  file.managed:
    - replace: false
    - require:
      - file: /etc/httpd/conf.modules.d
      - pkg: apache
    - source:
      - salt://jbossapache/files/{{ salt['grains.get']('os_family') }}/2.2/conf.modules.d/00-proxy.conf
    - template: jinja    
    - watch_in:
      - service: apache
      
/etc/httpd/conf.modules.d/01-cgi.conf:
  file.managed:
    - replace: false
    - require:
      - file: /etc/httpd/conf.modules.d
      - pkg: apache
    - source:
      - salt://jbossapache/files/{{ salt['grains.get']('os_family') }}/2.2/conf.modules.d/01-cgi.conf
    - template: jinja    
    - watch_in:
      - service: apache
      
{{ apache.configfile }}:
  file.managed:
    - template: jinja
    - source:
      - salt://jbossapache/files/{{ salt['grains.get']('os_family') }}/2.2/apache.config.jinja
    - require:
      - pkg: apache
    - watch_in:
      - service: apache
      
include_vhostd_config_dir_in_apache_config:
  file.managed:
    - group: root
    - mode: 644
    - name: {{ apache.confdir }}/z_include_vhostd.conf
    - require:
      - pkg: apache
    - source: salt://jbossapache/files/z_include_vhostd.conf.jinja
    - template: jinja
    - watch_in:
      - service: apache
    - user: root

/etc/httpd/conf.d/welcome.conf:
  file.absent:
    - require:
      - pkg: apache
    - watch_in:
      - service: apache

name_virtual_host_config:
  file.managed:
    - group: root
    - mode: 644
    - name: {{ apache.confdir }}/name_virtual_host.conf
    - require:
      - pkg: apache
    - source: salt://jbossapache/files/name_virtual_host.conf.jinja
    - template: jinja
    - watch_in:
      - service: apache
    - user: root  
    
set_apache_servername:
  file.managed:
    - group: root
    - mode: 644
    - name: {{ apache.confdir }}/servername.conf
    - require:
      - pkg: apache
    - source: salt://jbossapache/files/servername.conf.jinja
    - template: jinja
    - watch_in:
      - service: apache
    - user: root  
