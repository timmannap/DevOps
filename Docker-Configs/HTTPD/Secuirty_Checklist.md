# List of Checks

 
The following should be considered while installation/configuration of system:

---


### Secure Certificate to identify and secure data in motion.
HTTPS is done and we only need to add the certificates to the userconfiguration/ssl folder. The Readme of docker has more info.

---

### Traffic encryption should be TSL 1.2 or above. Disable SSL and TLS 1.1
This is done in the ssl.conf file, just add the line 
```apache
SSLProtocol -all +TLSv1.2 +TLSv1.3
```

in your ssl configuration. Example ssl.conf

```apache
<VirtualHost _default_:443>
    ServerName dev1.bankbuddy.me
    SSLEngine On    

    # ADD THIS
    SSLProtocol -all +TLSv1.2 +TLSv1.3

    SSLCertificateFile /usr/local/apache2/userconfiguration/SSL/MyCertificate.crt
    SSLCertificateKeyFile /usr/local/apache2/userconfiguration/SSL/MyKey.key
    DocumentRoot /usr/local/apache2/htdocs/static/
    ErrorLog /usr/local/apache2/ssl_error.log
    CustomLog /usr/local/apache2/ssl_custom.log combined
</VirtualHost>
```

[Reference](https://tecadmin.net/enable-tls-in-modssl-and-apache/)


---


### Disable weak cipher suites and secure Diffie-Hellman for TLS
Add the following to the SSL.conf

```apache
SSLHonorCipherOrder on
SSLCipherSuite "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 EECDH+aRSA+RC4 EECDH EDH+aRSA RC4 !aNULL !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS"
```

so it becomes, ssl.conf

```apache
<VirtualHost _default_:443>
    ServerName dev1.bankbuddy.me
    SSLEngine On    
    SSLProtocol -all +TLSv1.2 +TLSv1.3
    
    # ADD
    SSLHonorCipherOrder on
    SSLCipherSuite "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 EECDH+aRSA+RC4 EECDH EDH+aRSA RC4 !aNULL !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS" 
    SSLCertificateFile /usr/local/apache2/userconfiguration/SSL/MyCertificate.crt
    SSLCertificateKeyFile /usr/local/apache2/userconfiguration/SSL/MyKey.key
    DocumentRoot /usr/local/apache2/htdocs/static/
    ErrorLog /usr/local/apache2/ssl_error.log
    CustomLog /usr/local/apache2/ssl_custom.log combined
</VirtualHost>

```


[Reference](https://help.deepsecurity.trendmicro.com/10_1/on-premise/Protection-Modules/Intrusion-Prevention/ref-disable-dh.html)


---


### Remove version from server header banner and os details shouldnt be shown

Done by default in Apache 2.4.41


---


### HTTP 1.0 protocol

Add the following rule in the main config httpd.conf near the top (After the imports). Or this can be added **BEFORE** any other rewrite rule is performed.(Like the https reroute)

```apache
RewriteEngine On
RewriteCond %{SERVER_PROTOCOL} ^HTTP/1\.0$
RewriteCond %{REQUEST_URI} !^ <404ERROR>.html $
RewriteRule ^ - [F]
```

[Reference](https://stackoverflow.com/questions/44282207/how-to-disable-http-1-0-protocol-in-apache)

---


### HTTP Methods: only enable what is required for this project.
This is easily done by the AllowMeathods Module.Change the location tag in the main HTTPD.config file.

```apache
<Location "/">
   AllowMethods GET POST OPTIONS
</Location>
```


---


### Ensure X-Frame-Options “SAMEORIGIN”; are injected to HTTP Header to prevent clickjacking attacks.
Just add the following to the main httpd.conf file anywhere.

```apache
header always set X-Frame-Options "sameorigin"
```

[Reference](https://www.keycdn.com/blog/x-frame-options)


---


### X-XSS protection should be injected to HTTP Header to mitigate Cross-Site scripting attack.
Just add the following to httpd.conf file anywhere

```apache
header always set X-XSS-Protection "1; mode=block"
```

[Reference](https://www.keycdn.com/blog/x-xss-protection)


---


### Disable directory browser listing.
edit httpd.conf and find `<Directory "/usr/local/apache2/htdocs">`
EDIT the following

```apache
Options Index FollowSymLinks
```

 **to** 

```apache
Options FollowSymLinks
```


---



### Run the services as non-privileged account.


HTTPD docker image by default runs as deamon in the container. This is due to the following line present in the httpd.conf by default:
```apache
<IfModule unixd_module>

User daemon
Group daemon

</IfModule>
```
Check using ps 
```shell
ps aux | grep httpd
```

we should get one running as root. This is needed as only then can we get port previlage and create new childs. Rest are run as deamon.

[Reference](https://serverfault.com/questions/439307/apache-running-as-root-instead-of-user-specified-in-httpd-conf)

---


### Configure ACL on configuration directory to disallow other users to get conf and bin folder information.
Again not sure if this is applicable to us as we are on a docker container, but this [guide](https://www.tecmint.com/secure-files-using-acls-in-linux/) is good.


---


### The implementation should be behind WAF.
This docker contains HTTPD with mod_security and mod_evasive installed. mod_security is the WAF.

---



### Configure Timeout value
By default, Timeout is at 300 seconds. but to change this, we need to add the following to the config anywhere.
```apache
TimeOut <TIMEREQUIRED-IN-SECONDS>
```

[Reference](http://httpd.apache.org/docs/2.0/mod/core.html#timeout)

---


### Disable Etag header

Two ways to go about it. simple solution is disable it by adding the following to the main configuration, httpd.conf. 

```apache
<IfModule mod_headers.c>
	Header unset ETag
</IfModule>

FileETag None
```

but to improve preformance, we need to set cache control headers as well. so this is a more robust way.

```apache
<IfModule mod_headers.c>
	
	Header unset ETag
	
	<filesMatch "\.(ico|jpe?g|png|gif|swf)$">
		Header set Cache-Control "max-age=2592000, public"
	</filesMatch>
	<filesMatch "\.(css)$">
		Header set Cache-Control "max-age=604800, public"
	</filesMatch>
	<filesMatch "\.(js)$">
		Header set Cache-Control "max-age=216000, private"
	</filesMatch>
	<filesMatch "\.(x?html?|php)$">
		Header set Cache-Control "max-age=420, private, must-revalidate"
	</filesMatch>
</IfModule>

FileETag None
```


[Reference-CacheHeader](https://www.keycdn.com/support/cache-control)<br>
[Reference-ETags](https://htaccessbook.com/disable-etags/)

---


### Disable Trace Request
In the Main httpd.conf file, add the following line
```apache
TraceEnable off
 ```
after this rebuild the docker and run it. This disables Trace Requests

---


### Disable Server Side Include (SSI) if not required
Do we need SSI?

[What is SSI and Disabling here](http://www.pc-freak.net/blog/disable-server-side-includes-ssi-apache-debian-gnu-linux-improve-minor-apache-performance/)

---



### HSTS Header Secure-Transport-Layer

This is again a header used for HSTS. To enable this add the following to the 3_ssl.conf

```apache
Header always set Strict-Transport-Security "max-age=63072000; includeSubDomains"
```

so it becomes,

```apache
<VirtualHost _default_:443>
    ServerName support.bankbuddy.me
    SSLEngine On
    SSLProtocol -all +TLSv1.2 +TLSv1.3
    SSLHonorCipherOrder on
    SSLCipherSuite "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 EECDH+aRSA+RC4 EECDH EDH+aRSA RC4 !aNULL !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS"

    # For HSTS 
    Header always set Strict-Transport-Security "max-age=63072000; includeSubDomains"
 
    SSLCertificateFile /usr/local/apache2/userconfiguration/SSL/cert.pem
    SSLCertificateKeyFile /usr/local/apache2/userconfiguration/SSL/privkey.pem
    SSLCACertificateFile /usr/local/apache2/userconfiguration/SSL/chain.pem
    DocumentRoot /usr/local/apache2/htdocs/static/
    ErrorLog /usr/local/apache2/ssl_error.log
    CustomLog /usr/local/apache2/ssl_custom.log combined
</VirtualHost>
```

[Reference](https://www.xolphin.com/support/Apache_FAQ/Apache_-_Configuring_HTTP_Strict_Transport_Security)


