{%- from "apache/map.jinja" import apache with context %}

include:
  - apache

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
