# README.md

This project contains the sample docker implementation deribed from the openapi.yaml file.

# Prerequisites

* Install podman before execute ``make gen-code``

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
