# OAuth Server
This Needs the bank folder of the OAuth Folder in order to work. This is just the basic Docker and yaml file.

Docker image of the OAUTH Server. Runs on Python 3.7-alpine Image. OAuth is a Django Application that runs on port 8000 which is mapped to 8000 on the docker image as well.
## Installing Latest Docker-Compose
Need latest Docker-compose Version for version-3 of docker-compose. Install using:
```sudo curl -L https://github.com/docker/compose/releases/download/1.25.1-rc1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose```
Followed by
```sudo chmod +x /usr/local/bin/docker-compose```

## Running the Docker
```docker-compose build```<br>
```docker-compose up -d```
## Stoping the Docker
```docker-compose down```
## Accessing Shell Inside Docker
```docker-compose exec oauth sh```

# Notes
- Python Docker image of 3.7-alpine doesn't build **PANDAS** and **NUMPY** properly, so the workaround is installing it in the OS. This means we need to make sure that **NUMPY** and **PANDAS** are not present in the requirement files. ( **FIXED**: This has been resolved. Now the requirement file can be used as is, and no need to delete anything.)
