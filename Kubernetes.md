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