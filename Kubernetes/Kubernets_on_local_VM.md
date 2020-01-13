# Kubernetes on a locally hosted Cluster of VM

The set up is as follows

- 2 Ubuntu Servers VM on a host using Virtual Box
- Have NAT interface
  - For internet
- Also a HOST-ONLY interface
  - For communication with outerworld/clustering.
- Recommended 2 Cores and 2 GB Ram for running Kubeadm

# Installation

## 1. Server Setup

Setting up the server is straightforward. Go with the defaults and don't change anything (unless its needed and you know what your are doing). Naming of the server/Setting the user name of the server is up to you. After installing the server reboot the system.

### Update system

```
sudo apt update && sudo apt upgrade
```

This makes sure our server is up-to-date and ensures better stability.

Do these for both the servers.

## 2. Environment Setup

### Network

Lets re-define the Host name for our nodes to better reflect their roles. in the master node,

**Master**

```
sudo hostnamectl set-hostname "k8s-master"
exec bash
```

**Worker**

```
sudo hostnamectl set-hostname "k8s-worker-node1"
exec bash
```

Thus we have the host name set for both. Please do note the names can be anything, but change of this involved change in the Hosts file as well. So do take care of that.

​	

Now, Ensure the Servers can ping each other. (Get the IP of both servers and ssh into them from the host for easy of use.)

```
ifconfig
```

Gets the IP.



Now if we are able to ping both the server, we need to add hosts to our host file. This can be done by

```
sudo nano /etc/hosts
```

and 

```
192.168.99.102     k8s-master
192.168.99.103     k8s-worker-node1
```

perform this in **Both the Systems**.



With the Host name set, we can actually ping to test if its done easily.

**Master**

```
ping k8s-worker-node1
```

**Slave**

```
ping k8s-master
```

if it pings, we are done with the networking aspect of it successfully.

---

### Docker

We need to install docker on **Both the system** in order to run our container. this can be done by normal user using sudo but running as root is better as server sometimes doesn't start when doing normal sudo.

**Run the following on both the systems**

```
sudo -i
```

to go root and 

```
apt-get install docker.io -y
```

And then to start the Docker

```
systemctl start docker
systemctl enable docker
```

---

### Kubernetes





