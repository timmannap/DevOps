# OAuth Server
- Docker image of the OAuth Server.
- Runs on Python 3.7-slim-buster Image.
- OAuth is a Django Application that runs on port 8000 which is mapped to 8000 on the docker image as well.


## Installing Latest Docker-Compose
Need latest Docker-compose Version for version-3 of docker-compose. Install using:

```shell
sudo curl -L https://github.com/docker/compose/releases/download/1.25.1-rc1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
```

Followed by

```shell
sudo chmod +x /usr/local/bin/docker-compose
```


## Running the Docker

```shell
docker-compose build
```
```shell
docker-compose up -d
```
## Stoping the Docker
```shell
docker-compose down
```
## Accessing Shell Inside Docker
```docker-compose exec oauth sh```

