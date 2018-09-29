#!/usr/bin/env bash

if [ "$1" = 'ora2pg' ]; then
    if [ -z "$2" ]; then
        if [ -z "$CONFIG_LOCATION" ]; then
            echo "INFO: No CONFIG_LOCATION variable provided"
            echo "INFO: no args provided. Using default: '--debug -c /config/ora2pg.conf'"
            ora2pg --debug -c /config/ora2pg.conf
        else
            echo "INFO: CONFIG_LOCATION variable detected... executing '--debug -c $CONFIG_LOCATION'"
            ora2pg --debug -c $CONFIG_LOCATION
        fi
    else
        echo "INFO: executing: '$@'"
        exec "$@"
    fi
    exit 0
fi

exec "$@"