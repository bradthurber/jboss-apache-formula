
include:
  - apache

#### TODO: REMOVE THIS SECTION - This is handled in apache formula pillar config
# Co​mment out mod_proxy_balancer in /etc/httpd/conf/httpd.conf so it looks like this:
# #LoadModule proxy_balancer_module modules/mod_proxy_balancer.so
#comment_out_proxy_balancer_module:
#  file.comment:
#    - name: /etc/httpd/conf/httpd.conf
#    - char: '#'
#    - regex: ^LoadModule proxy_balancer_module


#### TODO We shouldn't have to do this here as modules.sls should handle it
#### but alas modules.sls fails to load apache because module is enabled
comment_out_proxy_balancer_module:
    cmd.run:
      - name: find /etc/httpd/ -name '*.conf' -type f -exec sed -i -e 's/\(^LoadModule.proxy_balancer_module\)/#\1/g' {} \;
      - onlyif: httpd -M 2> /dev/null | grep proxy_balancer_module
      - order: 225
      - require:
        - pkg: apache
      - watch_in:
        - module: apache-restart

# copy the mod_cluster *.so files to the apache server
copy_mod_cluster_natives:
  file.recurse:
    - file_mode: 755
    - makedirs: True
    - name: /etc/httpd/modules
    - source: salt://jbossapache/files/mod_cluster_natives
    - user: root

# place mod_cluster.conf file on server
configure_apache_to_load_the_mod_cluster_module:
  file.managed:
    - name: /etc/httpd/conf.d/mod_cluster.conf
    - source: salt://jbossapache/files/mod_cluster.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - file: copy_mod_cluster_natives
      - cmd: comment_out_proxy_balancer_module
    - watch_in:
      - service: apache
    