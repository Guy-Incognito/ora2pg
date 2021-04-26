# ora2pg Docker 

## Tags and Dockerfile links

* 18.2 [Dockerfile](https://github.com/Guy-Incognito/ora2pg/blob/18.2/Dockerfile) Uses ora2pg version [18.2](https://github.com/darold/ora2pg/releases/tag/v18.2)
* 19.0 [Dockerfile](https://github.com/Guy-Incognito/ora2pg/blob/19.0/Dockerfile) Uses ora2pg version [19.0](https://github.com/darold/ora2pg/releases/tag/v19.0)
* 19.1 [Dockerfile](https://github.com/Guy-Incognito/ora2pg/blob/19.1/Dockerfile) Uses ora2pg version [19.1](https://github.com/darold/ora2pg/releases/tag/v19.1)
* 20.0 [Dockerfile](https://github.com/Guy-Incognito/ora2pg/blob/20.0/Dockerfile) Uses ora2pg version [20.0](https://github.com/darold/ora2pg/releases/tag/v20.0)
* 21.0 [Dockerfile](https://github.com/Guy-Incognito/ora2pg/blob/21.0/Dockerfile) Uses ora2pg version [21.0](https://github.com/darold/ora2pg/releases/tag/v21.0)
* 21.1 [Dockerfile](https://github.com/Guy-Incognito/ora2pg/blob/21.1/Dockerfile) Uses ora2pg version [21.1](https://github.com/darold/ora2pg/releases/tag/v21.1)

## Introduction

This container can be used to migrate from Oracle to PostgreSQL utilizing the tool ora2pg.

Documentation: https://ora2pg.darold.net/documentation.html

Thanks to Gilles Darold for this awesome tool!!


## How to build

```
docker build . -t ora2pg

```

## How to run

## Usage:

The container accepts 2 mounted folders

* "/config" (read only) --> mount your folder containing the "ora2pg.conf" file here (example configuration: [ora2pg.conf](https://raw.githubusercontent.com/Guy-Incognito/ora2pg/master/config/ora2pg.conf)
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

Furthermore the 

* CONFIG_LOCATION: ora2pg config file location (inside the container) 
* OUTPUT_LOCATION: output directory of dump (inside the container) 
* ORA_HOST: Oracle datasource; the same as `ORACLE_DSN` in ora2pg.conf; if no value provided, ORACLE_DSN will be used.
* ORA_USER: Oracle user; the same as `ORACLE_USER` in ora2pg.conf; if no value provided, ORACLE_USER will be used.
* ORA_PWD: Oracle password; the same as `ORACLE_PWD` in ora2pg.conf; if no value provided, ORACLE_PWD will be used.

can be passed via environment variables:
```shell script
docker run  \
    --name ora2pg \
    -e CONFIG_LOCATION=/config/myconfigfile.conf  \
    -e OUTPUT_LOCATION=/data/myfolder  \
    -e ORA_HOST=dbi:Oracle:host=mydb.mydom.fr;sid=SIDNAME;port=1521  \
    -e ORA_USER=system  \
    -e ORA_PWD=secret  \
    -it \
    -v /path/to/local/config:/config \
    -v /path/to/local/data:/data \
    georgmoser/ora2pg 
```
or with a docker-compose:

```yaml
version: '3.3'
services:
  ora2pg:
    container_name: ora2pg
    environment:
      - CONFIG_LOCATION: "/config/myconfigfile.conf"
      - OUTPUT_LOCATION: "/data/myfolder"
      - ORA_HOST: "dbi:Oracle:host=mydb.mydom.fr;sid=SIDNAME;port=1521"
      - ORA_USER: "system"
      - ORA_PWD: "secret"
    volumes:
      - '/path/to/local/config:/config'
      - '/path/to/local/data:/data'
    image: georgmoser/ora2pg
```

