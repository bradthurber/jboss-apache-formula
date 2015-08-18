{%- from "jbossapache/map.jinja" import jbossapache with context %}

## make selinux happy - if it is enabled
 
# if selinux is not disabled and 6666 is not already allowed then allow 6666
semanage_mod_cluster_tcp_6666:
  cmd.run:
    - name: semanage port -a -t http_port_t -p tcp 6666
    - user: root
    - onlyif: sestatus |grep 'Current mode'|grep -v disabled && semanage port -l | grep -w http_port_t|grep -w tcp|grep -v ' 6666'

# if selinux is not disabled and 23364 is not already allowed then allow 23364
semanage_mod_cluster_udp_23364:
  cmd.run:
    - name: semanage port -a -t http_port_t -p udp 23364
    - user: root
    - onlyif: sestatus |grep 'Current mode'|grep -v disabled && semanage port -l | grep -w http_port_t|grep -w udp|grep -v ' 23364'

{% if grains['selinux']['enabled'] == True %}     
sesetbool_httpd_can_network_connect_1:
  selinux.boolean:
    - name: httpd_can_network_connect
    - value: True
    - persist: True
{% endif %}

# put mod_cluster config file on server (adding mod_cluster app servers in the allow list)
add_managed_mod_cluster_configuration_file_to_apache_conf:
  file.managed:
    - group: root
    - mode: 644
    - name: /etc/httpd/conf.d/mod_cluster_config.conf
    - require:
      - pkg: apache
      - cmd: semanage_mod_cluster_tcp_6666
      - cmd: semanage_mod_cluster_udp_23364
    - source: salt://jbossapache/files/mod_cluster_config.conf
    - template: jinja
    - watch_in:
      - service: apache
    - user: root
    