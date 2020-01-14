# Private-Docker-Repo
Private Docker Repository/Registry. Used to store local images.


## Terms
- **IP-OF-HOST**: Host-ip ip of the machine hosting the repo.
- **NAME-OF-IMAGE**: Image that is going to be pushed/pulled.


## Notes
- The repo is only used locally hence only HTTP is used and not HTTPS. Pulling an image from a HTTP link requires the machines pulling the image to have this registry added as a insecure registry.
- The images are stored in the **registry** folder that should be present in the same location as the docker-compose file. Any changes to this is reflected on the docker. Deleting the image folder here will delete the image data.
- List of Stored Images can be accessed by visiting the "http://IP-OF-HOST:50000/v2/\_catalog"
- A complete list of API's to manupilate the docker images is found at "https://docs.docker.com/registry/spec/api/"


## Setting up Clients/Machines using this registry
In order to use this Registry, we need to enable insecure registries in the machine that is going to pull and push. This can be done by editing the **/etc/docker/daemon.json** file. If the file doesn't exist, create it.
```shell
sudo vim /etc/docker/daemon.json
```
and once in the file, add the following line.
```
{
  "insecure-registries" : ["IP-OF-HOST:50000"]
}
```


## Setting up the Registry
The following command will run the Registry.
```shell
docker-compose up -d
```
This will run the Repo at IP-OF-HOST:50000.


## Pushing Images to the Registry 
For pushing at the Repo. we need to first tag the image properly for pushing and then push it. It can be done in the following way.

**For building from a Dockerfile**
```shell
docker build -t  IP-OF-HOST:50000/NAME-OF-IMAGE .
docker push IP-OF-HOST:50000/NAME-OF-IMAGE 
```

**For pushing a existing image**
```shell
docker tag NAME-OF-IMAGE IP-OF-HOST:50000/NAME-OF-IMAGE 
docker push IP-OF-HOST:50000/NAME-OF-IMAGE 
```


## Pulling an Image
Pulling an image is similar to pulling from dockerhub, we just have to append the ip in front of it.
```shell
docker pull IP-OF-HOST:50000/NAME-OF-IMAGE
```

## Deleteing Images
Images can be deleted with the help of API calls to the registry. A complete list of available end-points can be found here "https://docs.docker.com/registry/spec/api/". The command to delete the basic iamge is as follows.

First we get the digest of the image stored. To get the Digest, we need the 
- Name of Image
- Tag to be deleted.

Name of image can be found by visiting http://IP-OF-HOST:50000/v2/\_catalog

Getting Digest of image
```shell
curl -v http://localhost:50000/v2/<NAME-OF-IMAGE>/manifests/<TAG> -H 'Accept: application/vnd.docker.distribution.manifest.v2+json
```
From there copy the digest it will be like 
>sha:82j3b2ci2.....

Deleting the image
```shell
 curl -X DELETE -v http://localhost:50000/v2/<NAME-OF-IMAGE>/manifests/<DIGEST-IT-WILL-BE-LIKE-sha256:f156a3>
```

## Further Imporvements
- Use of a dedicated server that is hosted publically with a DNS name and SSL certificates. Basically making the connection HTTPS so that we dont need to add the registry.
