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
    - source:
      - salt://jbossapache/files/{{ salt['grains.get']('os_family') }}/2.2/conf.modules.d/00-base.conf
      - require:
      - pkg: apache

    - template: jinja
    - watch_in:
      - service: apache   

/etc/httpd/conf.modules.d/00-dav.conf:
  file.managed:
    - replace: false
    - source:
      - salt://jbossapache/files/{{ salt['grains.get']('os_family') }}/2.2/conf.modules.d/00-dav.conf
      - require:
      - pkg: apache
    - template: jinja    
    - watch_in:
      - service: apache
      
/etc/httpd/conf.modules.d/00-proxy.conf:
  file.managed:
    - replace: false
    - source:
      - salt://jbossapache/files/{{ salt['grains.get']('os_family') }}/2.2/conf.modules.d/00-proxy.conf
      - require:
      - pkg: apache
    - template: jinja    
    - watch_in:
      - service: apache
      
/etc/httpd/conf.modules.d/01-cgi.conf:
  file.managed:
    - source:
      - salt://jbossapache/files/{{ salt['grains.get']('os_family') }}/2.2/conf.modules.d/01-cgi.conf
      - require:
      - pkg: apache
    - replace: false
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

