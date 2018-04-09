#!/usr/bin/env bash

if [ "$1" = 'ora2pg' ]; then

    if [ -z "$2" ]; then
        echo "INFO: no args provided. Using default: '--debug -c /config/ora2pg.conf'"
        ora2pg --debug -c /config/ora2pg.conf

    else
        echo "INFO: executing: '$@'"
        exec "$@"

    fi

    exit 0

fi

exec "$@"