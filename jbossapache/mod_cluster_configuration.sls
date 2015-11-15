{%- from "apache/map.jinja" import apache with context %}

include:
  - apache

# put mod_cluster config file on server (adding mod_cluster app servers in the allow list)
add_managed_mod_cluster_configuration_file_to_apache_conf:
  file.managed:
    - group: root
    - mode: 644
    - name: {{ apache.confdir }}/mod_cluster_config.conf
    - require:
      - pkg: apache
      - cmd: semanage_mod_cluster_tcp_6666
      - cmd: semanage_mod_cluster_udp_23364
    - source: salt://jbossapache/files/mod_cluster_config.conf
    - template: jinja
    - watch_in:
      - module: apache-restart
    - user: root
    