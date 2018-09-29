# ora2pg Docker 

## Tags and Dockerfile links

* 18.2 (https://github.com/Guy-Incognito/ora2pg-docker/blob/18.2/Dockerfile) Uses Version 18.2: https://github.com/darold/ora2pg/releases/tag/v18.2
* 19.0 (https://github.com/Guy-Incognito/ora2pg-docker/blob/19.0/Dockerfile) Uses Version 19.0: https://github.com/darold/ora2pg/releases/tag/v19.0

## Introduction

This container can be used to migrate from Oracle to PostgreSQL utilizing the tool ora2pg.

Documentation: https://ora2pg.darold.net/documentation.html

Thanks to Gilles Darold for this awsome tool!!


## How to build

```
docker build . -t ora2pg

```

## How to run

## Usage:

The container accepts 2 mounted folders

* "/config" (read only) --> mount your folder containing the "ora2pg.conf" file here (an example configuration is provided under https://raw.githubusercontent.com/Guy-Incognito/ora2pg-docker/master/config/ora2pg.conf)
* "/data" --> mount the folder where all output should be written to here

Run the container with:

```
docker run  \
    --name ora2pg \
    -it \
    -v /path/to/local/config:/config \
    -v /path/to/local/data:/data \
    georgmoser/ora2pg
```


If no arguments are passed, the default run will be:
```
ora2pg --debug -c /config/ora2pg.conf
```


Custom arguments may be passed to the ora2pg call using:
```
docker run  \
    --name ora2pg \
    -it \
    -v /path/to/local/config:/config \
    -v /path/to/local/data:/data \
    georgmoser/ora2pg \
    ora2pg [[ARG1..ARGN]]
```

Furthermore the config file location (inside the container) can be passed via an environment variable:

```
docker run  \
    --name ora2pg \
    -e CONFIG_LOCATION=/config/myconfigfile.conf  \
    -it \
    -v /path/to/local/config:/config \
    -v /path/to/local/data:/data \
    georgmoser/ora2pg 
```