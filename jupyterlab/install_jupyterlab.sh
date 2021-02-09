#!/usr/bin/env bash

set -e
set -x

#####################################################
#                                                   #
# Run this script after using `install_miniconda.sh #
#                                                   #
#####################################################

# Confirm there are no errors before running this script
CHECK_ERRORS="$( echo $? )"
if [[ "${CHECK_ERRORS}" -ne 0  ]];
then
    echo "Some errors were encountered before running this script. Execution has been aborted.";
    exit 1;
fi

jupyterlab_sanity () {
    if [[ -z "${MINICONDA_HOME}" ]];
    then
        echo "variable MINICONDA_HOME is not defined"
        exit 1
    elif [[ -z "${VENV}" ]];
    then
        echo "The virtual environment variable VENV is not defined"
        exit 1
    else
        echo '


Installing jupyterlab now...


        '
    fi
}

###### BEGINNING of jupyterlab section ######
jupyterlab_sanity

export PATH="${MINICONDA_HOME}/envs/${VENV}/bin:$PATH"
TOKEN='TBnHTcjM9b1WNp7YVrKDQNWNj&j5'

# Start jupyterlab in the background
jupyter lab --ip=0.0.0.0 --allow-root --token="${TOKEN}" &

echo "Using token ${TOKEN}"

###### END of jupyterlab section ######
