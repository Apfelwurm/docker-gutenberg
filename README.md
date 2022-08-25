# Gutenberg office printer gateway docker image

This repository is based on the work of [KSIUJ's ](https://github.com/KSIUJ) [Gutenberg](https://github.com/KSIUJ/gutenberg) .

## Linux Container

[![linux/amd64](https://github.com/Apfelwurm/docker-gutenberg/actions/workflows/build-linux-image.yml/badge.svg?branch=main)](https://github.com/Apfelwurm/docker-gutenberg/actions/workflows/build-linux-image.yml)

### Download

```shell
docker pull apfelwurm/docker-gutenberg;
```

<!-- ### Run Self Tests

The image includes a test script that can be used to verify its contents. No changes or pull-requests will be accepted to this repository if any tests fail.

```shell
docker run -it --rm apfelwurm/docker-gutenberg ./ll-tests/test-gutenberg.sh;
``` -->

### Run Interactive Server

```shell
docker run -it --rm --net=host apfelwurm/docker-gutenberg
```

### todo

* implement tests
* isolate driver installation and implement a logic for that
