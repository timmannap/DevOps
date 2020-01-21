#! /bin/sh

# Create a errorlog 
touch modsecurity_error.log
touch modsec_audit.log
# Overwriting our conf file to existing.
mv httpd.conf ./conf/httpd.conf

# Modules
mv mod_security2.so ./modules/
mv mod_evasive24.so ./modules/

# Setting up Rules for OWASP

mv crs-setup.conf.example /etc/modsecurity/crs-setup.conf
mv rules/ /etc/modsecurity/

