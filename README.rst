================
jboss-apache-formula
================

A pseudo-salt formula that extends the public salt apache formula 
https://github.com/saltstack-formulas/apache-formula with pieces
that are useful for running on JBoss (i.e. we are in the Apache 2.2. dark ages).

Hopefully we will gradually integrate this functionality into the
share public salt formula over time and this formula can go away entirely.

At the moment, this pseudo-formula has no map.jina and no init.sls instead
relying on the extended apache formula

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

All other states (unless otherwise mentioned) are meant to be run on any/all jbosseap servers
	
Available states
================

.. contents::
    :local:

``jbossapache.config``
------------

Configures apache 2.2 for JBoss. This will do the following:
* replace the out of the box httpd.conf with a salt managed version
* move all of the LoadModule code to /etc/httpd/conf.modules.d which is more apache 2.4-like
* ensure an /etc/httpd/vhosts.d folder exists to store vhost config info (again apache 2.4-like).

``jbossapache.mod_cluster_configuration``
------------

Configures the web server mod_cluster module with the ip addresses of the app servers

``jbossapache.mod_cluster_module``
------------

This should be run on all apache servers in the cluster. It should not be run on the 
jboss server unless it is also acting as an apache server.
Copies the mod_cluster apache module files to the httpd server modules directory
Creates a conf.d file to load the modules
