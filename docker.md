### GETTING STARTED WITH DOCKER ###
Docker is an open platform for developing, shipping, and running applications. Docker enables you to separate your applications from your infrastructure so you can deliver software quicklyBy taking advantage of Docker’s methodologies for shipping, testing, and deploying code quickly, you can significantly reduce the delay between writing code and running it in production.

- Containerization : 
    - flexible : everything can be containerized 
    - lightweight : share host kernal , more efficient than VMs
    - portable : build , run , deploy anywhere
    - loosely coupled : highly self sufficient 
    - scalabel: 
    - secure :

-  Container : a running process **isolated** from host and other containers . containers interact with there own filesystem provided by the docker image . An image has evrything to run the code or binary, runtimes, dependencies, and any other filesystem objects required.   

- Containers and VMs:
    - Container run natively on the host kernal and share the host OS , runs discrete process , taking no more memory than any other executable .
    - sVM on the other hand runs on guest OS , have access to host resources via an hypervisor. consume lot of overhead . 


- conatinerized process gives us the opportunity of moving and scaling our process around cloud and datacentres .  as we scale our applications up, we’ll want some tooling to help automate the maintenance of those applications, able to replace failed containers automatically and manage the rollout of updates and reconfigurations of those containers during their lifecycle. tools to manage these things are called **ORCHESTRATORS** and the most common examples are kubernetes and docker swarm . 


**Writing a Dockerfile**

- Writing a Dockerfile is the first step to containerizing an application. You can think of these Dockerfile commands as a step-by-step recipe on how to build up our image.

- [syntax of a Dockerfile](https://kapeli.com/cheat_sheets/Dockerfile.docset/Contents/Resources/Documents/index)

- **to build a Dockerfile :**
    - *docker build -t "image_name:version_tag" "path of Dockerfile" ( . in case when in same directory as Dockerfile)*

- **to run a container :**
    - *docker run --detach -p host_port:container_port --name alias_name image_name:version*


**some important commands :**
- docker image ls : to show all docker images
- docker ps : to show running containers 
- docker rm : to remove container

    (to get help use --help with above commands)
