# README.md

This project contains the sample docker implementation deribed from the openapi.yaml file.

The openapi.yaml file is processed by the openapi-generator-cli tool to generate the server stub code.

The openapi-generator-cli tool is modified by the author, so please refer to the following for details.

https://qiita.com/YasuhiroABE/items/b3cf17aec64ba62baf88

https://hub.docker.com/r/yasuhiroabe/my-ogc/tags

# Prerequisites

* Install podman before execute ``make gen-code``
  * If you use docker, please modify the Makefile or set the environment variable ``DOCKER_CMD=docker``

# Getting started

If you enable the SELinux, then uncomment ``DOCKER_OPT = --security-opt label=disable`` of Makefile.

```
## to run the docker container
$ make gen-code
$ cd code
$ make docker-build
$ make docker-run

## to stop the docker container
$ make docker-stop
```

