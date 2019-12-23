# Testing

As we provide functionality for installing programs, working in GUIs etc, we resort to manual testing inside a docker container. On your machine, perform the following steps to create the docker test container, which is running Ubuntu 18.04.


## Set up docker
On Ubuntu, perform these steps to install docker

```
sudo apt install docker.io
sudo groupadd docker  # If group docker was not created automatically
sudo usermod -aG docker $USER  # Requires log out and re-log in to take effect
```

## Build and run the test container
Build the docker container from the `Dockerfile` in this directory. The user in the docker is called `testuser` and has sudo password `a`.

```
cd ~/.dotfiles/test
docker image build -t test-ubuntu:1.0 .
docker container run -it test-ubuntu:1.0
```
