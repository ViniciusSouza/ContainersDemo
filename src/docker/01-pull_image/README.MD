# Using Docker public images

In order to use a docker image in your system, we need to have the docker engine available in our environment.

[Docker for Windows](https://docs.docker.com/docker-for-windows/install/#install-docker-for-windows-desktop-app)

[Docker for Linux](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

To check open a terminal window and run

``` bash
docker version

Client: Docker Engine - Community
 Version:           18.09.0
 API version:       1.39
 Go version:        go1.10.4
 Git commit:        4d60db4
 Built:             Wed Nov  7 00:47:51 2018
 OS/Arch:           windows/amd64
 Experimental:      true

Server: Docker Engine - Community
 Engine:
  Version:          18.09.0
  API version:      1.39 (minimum version 1.12)
  Go version:       go1.10.4
  Git commit:       4d60db4
  Built:            Wed Nov  7 00:55:00 2018
  OS/Arch:          linux/amd64
  Experimental:     false
 Kubernetes:
  Version:          v1.9.10
  StackAPI:         Unknown
```

## Using Docker

``` bash
docker run -it visouza/busybox:curl sh
```

This command will look for the specified image name in your system, and if you don't have it docker will pull the image from Docker Hub, a **public** image repository for Docker Images.

To check the images available in your system run.

``` bash
docker images
```

You can also check the docker process running using.

``` bash
docker ps
```