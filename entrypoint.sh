#!/usr/bin/env bash

function check_env {
    if [ -z "$CONFIG_LOCATION" ]; then
        echo "INFO: No CONFIG_LOCATION variable provided. Using default '/config/ora2pg.conf'"
        export CONFIG_LOCATION=/config/ora2pg.conf
    else
        echo "INFO: CONFIG_LOCATION variable detected: '$CONFIG_LOCATION'"
    fi

    if [ -z "$OUTPUT_LOCATION" ]; then
        echo "INFO: No OUTPUT_LOCATION variable provided. Using default '/data'"
        export OUTPUT_LOCATION=/data
    else
        echo "INFO: OUTPUT_LOCATION variable detected: '$OUTPUT_LOCATION'"
        mkdir -p ${OUTPUT_LOCATION}
    fi
}

if [ "$1" = 'ora2pg' ]; then

    check_env

    if [ -z "$2" ]; then
        echo "INFO: no args provided. Using default: '--debug -c $CONFIG_LOCATION --basedir $OUTPUT_LOCATION'"
        ora2pg --debug -c ${CONFIG_LOCATION} --basedir ${OUTPUT_LOCATION}
    else
        echo "INFO: executing: '$@'"
        exec "$@"
    fi
    exit 0
fi

exec "$@"