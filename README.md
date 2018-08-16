# ora2pg Docker 

## Introduction

This container can be used to migrate from Oracle to PostgreSQL utilizing the tool ora2pg.

Uses Version 18.2: https://github.com/darold/ora2pg/releases/tag/v18.2

Documentation: https://ora2pg.darold.net/documentation.html

Thanks to Gilles Darold for this awsome tool!!


## How to build

```
docker build . -t ora2pg

```

## How to run

## Usage:

The container accepts 2 mounted folders

* "/config" (read only) --> mount your folder containing the "ora2pg.conf" file here (an example configuration is provided under ./config/ora2pg.conf)
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
