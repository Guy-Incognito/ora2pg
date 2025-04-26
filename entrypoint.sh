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

    ORA_HOST_FLAG=""
    if [ -z "$ORA_HOST" ]; then
        echo "INFO: No ORA_HOST variable provided. Using value of 'ORACLE_DSN' from '$CONFIG_LOCATION'"
    else
        echo "INFO: ORA_HOST_FLAG variable detected: '$ORA_HOST'"
        ORA_HOST_FLAG=" --source $ORA_HOST "
    fi

    ORA_USER_FLAG=""
    if [ -z "$ORA_USER" ]; then
        echo "INFO: No ORA_USER variable provided. Using value of 'ORACLE_USER' from  '$CONFIG_LOCATION'"
    else
        echo "INFO: ORA_USER variable detected: '$ORA_USER'"
        ORA_USER_FLAG=" --user $ORA_USER "
    fi

    ORA_PWD_FLAG=""
    ORA_PWD_FLAG_MASKED=""
    if [ -z "$ORA_PWD" ]; then
        echo "INFO: No ORA_PWD variable provided. Using value of 'ORACLE_PWD' from  '$CONFIG_LOCATION'"
    else
        echo "INFO: ORA_PWD variable detected: '*******'"
        ORA_PWD_FLAG=" --password $ORA_PWD "
        ORA_PWD_FLAG_MASKED=" --password ******* "
    fi

    EXP_TYPE_FLAG=""
    if [ -z "$EXP_TYPE" ]; then
        echo "INFO: No EXP_TYPE variable provided. Using default value of 'EXPORT TYPE' in '$CONFIG_LOCATION'"
    else
        echo "INFO: EXP_TYPE variable detected: '$EXP_TYPE'"
        EXP_TYPE_FLAG=" -t $EXP_TYPE "
    fi

}

if [ "$1" = 'ora2pg' ]; then

    check_env
    # Set host name for oracle
    /bin/bash -c "echo '127.0.1.1 ${HOSTNAME}' >> /etc/hosts"

    if [ -n "$EXP_TYPE" ]; then
        EXP_TYPE_FLAG=" -t $EXP_TYPE "
        OUTPUT_FILE=""
        case "$EXP_TYPE" in
            TABLE)
                OUTPUT_FILE="pgschema.sql"
                ;;
            DATA)
                OUTPUT_FILE="pgdata.sql"
                ;;
            INSERT)
                OUTPUT_FILE="pginsert.sql"
                ;;
            *)
                echo "WARNING: Unrecognized EXP_TYPE '$EXP_TYPE'. Using default output in '$CONFIG_LOCATION'"
                ;;
        esac
        if [ -n "$OUTPUT_FILE" ]; then
            echo "INFO: Running ora2pg with -t $EXP_TYPE and output to $OUTPUT_FILE"
            ora2pg -c ${CONFIG_LOCATION} -b ${OUTPUT_LOCATION} -o ${OUTPUT_FILE} ${ORA_HOST_FLAG} ${ORA_USER_FLAG} ${ORA_PWD_FLAG} ${EXP_TYPE_FLAG}
        else
            ora2pg -c ${CONFIG_LOCATION} -b ${OUTPUT_LOCATION} ${ORA_HOST_FLAG} ${ORA_USER_FLAG} ${ORA_PWD_FLAG} ${EXP_TYPE_FLAG}
        fi

    elif [ -z "$2" ]; then
        echo "INFO: no args provided. Using default: '--debug -c $CONFIG_LOCATION --basedir $OUTPUT_LOCATION ${ORA_HOST_FLAG} ${ORA_USER_FLAG} ${ORA_PWD_FLAG_MASKED}'"
        ora2pg --debug -c ${CONFIG_LOCATION} --basedir ${OUTPUT_LOCATION} ${ORA_HOST_FLAG} ${ORA_USER_FLAG} ${ORA_PWD_FLAG}

    else
        echo "INFO: executing: '$@'"
        exec "$@"
    fi

    exit 0
fi

exec "$@"
