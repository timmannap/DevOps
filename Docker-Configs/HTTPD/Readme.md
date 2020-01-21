# Apache HTTPD server Docker image.

Contains the following features

- Modsecurity
    - Owasp Rule set.
- Modevasive
- Proxy Configuration
- SSL
- Persistant Storage

## Running The image.

    docker-compose build
    docker-compose up -d

# Accesing Bash of container
Get name of container and then.

    docker exec -ti <NAME OF CONTAINER> bash


 # Configurations
 -  **rules** folder is where the rules are (Currently using OWasp ruleset)
 -  **userconfiguration** folder is persistant. Any change will be done in container in realtime. Contains all custom Configurations
 -  **userconfiguration/SSL** folder contains the keys and certificate for SSL.
 -  **htdocs** is persistant and contains all base docs.
 -  Port 80 mapped to 80 for http
 -  Port 443 mapped to 443 for https/SSL



# Custom Changes
The Following Need to be Changed when Deploying in a New Server

**custom.conf**<br>
Setting the Server Name and Changin the Redirect for HTTPS

**proxy.conf**<br>
Setting the Redirect/Proxy

all changes that are common are commented with \_\_change__ so searching for the same will lead you to common changes.

# Notes
Need Docker-compose latest version. Best way to get this is as follows
    
    sudo curl -L https://github.com/docker/compose/releases/download/1.25.1-rc1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
and 


​        

​    sudo chmod +x /usr/local/bin/docker-compose

This wasy we get the latest version of docker compose.

Make sure all commands are run with sudo.

# SSL Certification
To get the SSL certification. First stop the Docker with 

```
docker-compose down
```

Now in custom.conf comment the redirect to HTTPS for now.

```
#    Redirect permanent / https://fe-credit.bankbuddy.me/
```

run the following commands on the server with apache installed.

```
sudo apt install apache2
```

```
sudo apt install python-certbot-apache
```

Now run 

```
sudo certbot certonly --apache
```

now when asked for domain give the domain you want to do it in.

Now the keys, and the certificates are stored in the directory given after successful install

```
sudo cd /etc/letsencrypt
```

now change the permissions using

```
sudo chmod 777 -R .
```

with permission changed, go to the location of the files.

```
cd live/<DOMAINNAME>
```

Now we move the **privkey.pem cert.pem chain.pem** files from here to the docker's SSL folder.

```
cp *.pem /home/$USER/HTTPD-ReverseProxy-Docker/userconfiguration/SSL/
```

Now we have the pem files.

Change the ssl.conf file located in **userconfiguration** files to point to the correct files.

```
	SSLCertificateFile /usr/local/apache2/userconfiguration/SSL/cert.pem
    SSLCertificateKeyFile /usr/local/apache2/userconfiguration/SSL/privkey.pem
    SSLCACertificateFile /usr/local/apache2/userconfiguration/SSL/chain.pem
```

then we have to kill the apache server running so 

```
sudo lsof -i -P -n
```

now find out the pid of apahce2

and 

```
sudo kill <PID OF APACHE2>
```

this frees up the port 80

Now we can 

```
docker-compose up -d 
```

and we get the server up and running with the SSL certificate.
