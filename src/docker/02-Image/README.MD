# Building your own Image

Docker allow us to build our own image by using a recipe (Dockerfile)

To show the power of this feature we will build a apache image, using a public image as base and adding our configuration to it.

That sample show a amazing feature about Docker, wich is the layering system to build image.

``` Dockerfile
FROM httpd:2.4 as base
EXPOSE 80

FROM base as htmldocs
COPY ./html /usr/local/apache2/htdocs/
```

To build our image we are going to use the *docker build*

``` bash
docker build -t visouza/httpd:demo .

Sending build context to Docker daemon   5.12kB
Step 1/4 : FROM httpd AS base
latest: Pulling from library/httpd
a5a6f2f73cd8: Pull complete
ac13924397e3: Pull complete
91b81769f14a: Pull complete
fec7170426de: Pull complete
992c7790d5f3: Pull complete
Digest: sha256:9753aabc6b0b8cd0a39733ec13b7aad59e51069ce96d63c6617746272752738e
Status: Downloaded newer image for httpd:latest
 ---> 2a51bb06dc8b
Step 2/4 : EXPOSE 80
 ---> Running in ef4473be535f
Removing intermediate container ef4473be535f
 ---> 4419de9499b4
Step 3/4 : FROM base as htmldocs
 ---> 4419de9499b4
Step 4/4 : COPY ./html /usr/local/apache2/htdocs/
 ---> 43adff5be064
Successfully built 43adff5be064
Successfully tagged visouza/httpd:demo
SECURITY WARNING: You are building a Docker image from Windows against a non-Windows Docker host. All files and directories added to build context will have '-rwxr-xr-x' permissions. It is recommended to double check and reset permissions for sensitive files and directories.
```

Now we have to execute the image, using.

``` bash
docker run -d -p 7000:80 visouza/httpd:demo
```

![Sample page](./images/web-sample.png)

## Pushing the image

Now that we have tested our image, we can push it to a Container Registry and our case the Docker Container Registry [Docker Hub](https://hub.docker.com/)

First we need to have an account, go to sign up if you don't have one.

At your terminal type

``` bash
docker login
```

Enter your user and password.

Before pushing the image we have to be sure that we are using the right name.

To use Docker Hub our image have to be in this format.

``` MD
<docker hub user>/<image name>:<tag>
```

In our case.

``` MD
docker push visouza/httpd:demo

The push refers to repository [docker.io/visouza/httpd]
d4ae6187d389: Pushed
026f9bea4fc4: **Mounted from library/httpd**
de926190eb0b: **Mounted from library/httpd**
920e7ca5de49: **Mounted from library/httpd**
143e72edeb6d: **Mounted from library/httpd**
ef68f6734aa4: **Mounted from library/httpd**
demo: digest: sha256:dd87c8e10b4f3f6e8f8f045072c98750f3ca8aaaae092c81a3b6e4d60accfc21 size: 1574
```
