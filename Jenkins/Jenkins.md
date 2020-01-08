# Jenkins

## Installation (Local)

```shell
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -

sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

sudo add-apt-repository universe

sudo apt-get update

sudo apt-get install jenkins -y
```

After Installing, Go to **localhost:8080** and we will be prompted for a password. we can get the password by

```shell
sudo less /var/lib/jenkins/secrets/initialAdminPassword

----------or-----------
sudo less <PATH GIVE ON WEBSITE>
```

We now have Jenkins installed in our system.

----

## Installation (Docker)

Detailed in here

https://hub.docker.com/_/jenkins/

**Pull image**

```
docker pull jenkins
```

**Running with a volume**

```
docker run --name myjenkins -p 8080:8080 -p 50000:50000 -v /var/jenkins_home jenkins
```

Now on port 8080 

if error change port to 8081

```
docker run --name myjenkins -p 8081:8080 -p 50000:50000 -v /var/jenkins_home jenkins
```

