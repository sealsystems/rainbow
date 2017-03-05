# PLOSSYS rainbow

[![Build Status](https://travis-ci.org/sealsystems/rainbow.svg?branch=master)](https://travis-ci.org/sealsystems/rainbow)
[![This image on DockerHub](https://img.shields.io/docker/pulls/sealsystems/rainbow.svg)](https://hub.docker.com/r/sealsystems/rainbow/)

A Docker container to show a rainbow with the Blinkt! LED strip.

- [Dockerfile.amd64](https://github.com/sealsystems/rainbow/blob/master/Dockerfile.amd64)
- [Dockerfile.arm](https://github.com/sealsystems/rainbow/blob/master/Dockerfile.arm)

## Start locally

To run the app, type:

```
node bin/app.js
```

## Start the Docker container

To start the container, type:

```
docker run -it -v /sys:/sys -v /var/run/docker.sock:/var/run/docker.sock sealsystems/rainbow
```

## Swarm mode

### Start service

To start it in a Docker swarm, type:

```bash
docker service create --name rainbow --mount type=bind,src=/sys,dst=/sys  sealsystems/rainbow:1.0.0
```

### Scale service

```bash
docker service scale rainbow=3
```

### Rolling updates

Rolling updates are [configured at start time](https://docs.docker.com/engine/swarm/swarm-tutorial/rolling-update/) by setting `--update-delay`:

```bash
docker service create --name rainbow --update-delay 10s --mount type=bind,src=/sys,dst=/sys sealsystems/rainbow:0.1.0
```

```bash
docker service update --image sealsystems/rainbow:1.0.0 rainbow
```

### Global service

To run it on *all nodes* in a swarm cluster, type:

```bash
docker service create --name rainbow --mount type=bind,src=/sys,dst=/sys --mode global sealsystems/rainbow:1.0.0
```

## Debugging

To show debug messages, set the `DEBUG` environment variable:

```
DEBUG=app:* node bin/app.js
```
