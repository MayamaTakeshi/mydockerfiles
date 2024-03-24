# mydockerfiles

## Overview

This repo preserves artifacts (Dockerfiles and helper scripts) to prepare docker containers for dev/testing some open source projects.

## Basic procedure to build and publish an image to dockerhub:
```
$ docker build -t base-dev-bullseye:1.0.0 .

$ docker images|grep base-dev-bu
base-dev-bullseye                      1.0.0                     b6b85fb58d4a   4 hours ago     1.99GB

$ docker tag base-dev-bullseye:1.0.0 mayamatakeshi/base-dev-bullseye:1.0.0

$ docker images|grep base-dev-bu
base-dev-bullseye                      1.0.0                     b6b85fb58d4a   4 hours ago     1.99GB
mayamatakeshi/base-dev-bullseye        1.0.0                     b6b85fb58d4a   4 hours ago     1.99GB

$ docker push mayamatakeshi/base-dev-bullseye:1.0.0
```

## Correcting a wrong tag
```
$ docker tag base-dev-bullseye:1.0.0 mayamatakehi/base-dev-bullseye:1.0.0

$ docker images|grep base-dev-bu
base-dev-bullseye                      1.0.0                     b6b85fb58d4a   4 hours ago     1.99GB
mayamatakehi/base-dev-bullseye         1.0.0                     b6b85fb58d4a   4 hours ago     1.99GB

$ docker rmi mayamatakehi/base-dev-bullseye:1.0.0
Untagged: mayamatakehi/base-dev-bullseye:1.0.0

$ docker images|grep base-dev-bu
base-dev-bullseye                      1.0.0                     b6b85fb58d4a   4 hours ago     1.99GB

$ docker tag base-dev-bullseye:1.0.0 mayamatakeshi/base-dev-bullseye:1.0.0

$ docker images|grep base-dev-bu
base-dev-bullseye                      1.0.0                     b6b85fb58d4a   4 hours ago     1.99GB
mayamatakeshi/base-dev-bullseye        1.0.0                     b6b85fb58d4a   4 hours ago     1.99GB
```
