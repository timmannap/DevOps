## GETTING STARTED WITH KUBERNETES 

kubernetes (K8s) is an open source system for automating deployment , scaling, and management of containerized applications. It groups containers that make up an application into logical units for easy management and discovery.

- kubernetes's 6 layers of abstraction :

    - Deployment
    - ReplicaSet
    - Pod
    - Node Cluster
    - Node Processes
    - Docker Container

**In short " Deployments create and manage ReplicaSets, which create and manage Pods, which run on Nodes, which have a container runtime, which run the app code you put in your Docker image. "**

1. Deployment : Deployments allow you to update a running app without downtime. Deployments also specify a strategy to restart Pods when they die.

2. ReplicaSet : The Deployment creates a ReplicaSet that will ensure your app has the desired number of Pods. ReplicaSets will create and scale Pods based on the triggers you specify in your Deployment.

3. Pods : The Pod is the basic building block of Kubernetes. A Pod contains a group of one or more containers. Pods handle Volumes, Secrets, and configuration for containers. Pods live on Worker Nodes.

4. K8 Cluster : Cluster consists of a Cluster Master and Worker Nodes. [image](https://miro.medium.com/max/754/1*gT5K52iFTJf6SDhwWBaClQ.png)

    - Worker Node : node is an abstraction of either a physical machine or a VM , one or more pods run on a single worker node . 
        - *A Pod is never split between two Nodes — a Pod’s contents are always located and scheduled together on the same Node.*

    - Cluster master : Tell all other nodes what to do

5. Node processes :
    - Master Components : 
        - API Server — Exposes the K8s API. It’s the frontend for Kubernetes control. (aka. kube-apiserver) Think hub.
        -   etcd — Distributed key-value store for Cluster state data. Think Cluster info.
        -   Scheduler — Selects the Nodes for new Pods. Good guide here. (aka kube-scheduler) Think matcher.
        -   kube-controller-manager —Process that runs controllers to handle Cluster background tasks. Think Cluster controller.
        -   cloud-controller-manager — Runs controllers that interact with cloud providers. Think cloud interface.

    - Worker Node subcomponents:
        - kubelet: Worker Node brain.
        - kube-proxy: traffic cop.
        - container-runtime: Docker.    

6. Docker Container: where the app code lives.


*Here are the 7 additional high-level K8s API objects to know:*

    - StatefulSet: Like a ReplicaSet for stateful processes. Think state.
    - DaemonSet: One automatic Pod per Node. Think monitor.
    - Job: Run a container to completion. Think batch.
    - CronJob: Repeated Job. Think time.
    - Service: Access point for Pods. Think access point.
    - Volume: Holds data. Think disk.
    - PersistentVolume, PersistentVolumeClaim: System for allocating storage. Think storage claim.

[for better understanding of K8 basics read this !](https://towardsdatascience.com/key-kubernetes-concepts-62939f4bc08e)

[For Best understanding of Kubernetes through comic pls read here !](https://cloud.google.com/kubernetes-engine/kubernetes-comic/)

**Networking in K8**

Every Pod gets its own IP address. This means you do not need to explicitly create links between Pods and you almost never need to deal with mapping container ports to host ports.

    -   pods on a node can communicate with all pods on all nodes without NAT
    -   agents on a node (e.g. system daemons, kubelet) can communicate with all pods on that node
    -   pods in the host network of a node can communicate with all pods on all nodes without NAT 

Kubernetes IP addresses exist at the Pod scope - containers within a Pod share their network namespaces - including their IP address. This means that containers within a Pod can all reach each other’s ports on localhost. This also means that containers within a Pod must coordinate port usage . This is called the **IP-per-pod** model.  

Networking Problems :


    Container-to-Container networking
    Pod-to-Pod networking
    Pod-to-Service networking
    Internet-to-Service networking


[**For detailed understanding of networking in kubernetes**](https://sookocheff.com/post/kubernetes/understanding-kubernetes-networking-model/)




## GETTING INTO DETAILS :

### KUBERNETES NOTES :

- The Kubernetes Master is a collection of three processes that run on a single node in your cluster, which is designated as the master node. Those processes are: 
    - kube-apiserver
    - kube-controller-manager
    - kube-scheduler.

- Each individual non-master node in your cluster runs two processes:
    - kubelet, which communicates with the Kubernetes Master.
    - kube-proxy, a network proxy which reflects Kubernetes networking services on each node.

The basic Kubernetes objects include:

    Pod
    Service
    Volume
    Namespace

Kubernetes also contains higher-level abstractions that rely on Controllers to build upon the basic objects, and provide additional functionality and convenience features. These include:

    Deployment
    DaemonSet
    StatefulSet
    ReplicaSet
    Job

Kubernetes provides you with:

-   Service discovery and load balancing

        Kubernetes can expose a container using the DNS name or using their own IP address. If traffic to a container is high, Kubernetes is able to load         balance and distribute the network traffic so that the deployment is stable.
    
-   Storage orchestration

        Kubernetes allows you to automatically mount a storage system of your choice, such as local storages, public cloud providers, and more.
        Automated rollouts and rollbacks
        You can describe the desired state for your deployed containers using Kubernetes, and it can change the actual state to the desired state at a controlled rate. For example, you can automate Kubernetes to create new containers for your deployment, remove existing containers and adopt all their resources to the new container.

-   Automatic bin packing

        You provide Kubernetes with a cluster of nodes that it can use to run containerized tasks. You tell Kubernetes how much CPU and memory (RAM) each container needs. Kubernetes can fit containers onto your nodes to make the best use of your resources.
    
-   Self-healing

        Kubernetes restarts containers that fail, replaces containers, kills containers that don’t respond to your user-defined health check, and doesn’t advertise them to clients until they are ready to serve.
    
-   Secret and configuration management

        Kubernetes lets you store and manage sensitive information, such as passwords, OAuth tokens, and SSH keys. You can deploy and update secrets and application configuration without rebuilding your container images, and without exposing secrets in your stack configuration.    

**Basic Architecture :** 

[Architecture Daigram ](https://d33wubrfki0l68.cloudfront.net/817bfdd83a524fed7342e77a26df18c87266b8f4/3da7c/images/docs/components-of-kubernetes.png)


### Kubernetes Objects :

1. Names :
-   Each object in your cluster has a Name that is unique for that type of resource. Every Kubernetes object also has a UID that is unique across your whole cluster.

    eg , 

        apiVersion: v1
        kind: Pod
        metadata:
        name: nginx-demo
        spec:
        containers:
        - name: nginx
            image: nginx:1.7.9
            ports:
            - containerPort: 80

2. Namespaces : 
-   Namespaces are intended for use in environments with many users spread across multiple teams, or projects. Namespaces provide a scope for names. Names of resources need to be unique within a namespace, but not across namespaces. Namespaces can not be nested inside one another and each Kubernetes resource can only be in one namespace.

-   Namespaces are a way to divide cluster resources between multiple users

        To set the namespace for a current request, use the --namespace flag.

-   we can create our own namespace :

        Create a new YAML file called my-namespace.yaml with the contents:

        apiVersion: v1
        kind: Namespace
        metadata:
        name: <insert-namespace-name-here>

        Then run:

        kubectl create -f ./my-namespace.yaml

        Alternatively, you can create namespace using below command:

        kubectl create namespace <insert-namespace-name-here>

-   Delete a namespace with

        kubectl delete namespaces <insert-some-namespace-name>       



#### Cluster Architecture :

**Nodes**

-   A node is a worker machine in Kubernetes, previously known as a minion. A node may be a VM or physical machine, depending on the cluster. Each node contains the services necessary to run pods and is managed by the master components. The services on a node include the container runtime, kubelet and kube-proxy. 
