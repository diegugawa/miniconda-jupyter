#!/usr/bin/env bash

set -e
#set -x

builtin cd "$( dirname "${BASH_SOURCE[0]}" )"

# Environment variables
MINICONDA_HOME="/opt/miniconda"
MINICONDA_VERSION="$( cat $( dirname "${PWD}" )/miniconda_version.txt )"
REQUIREMENTS_FILE="/scripts/jupyterlab/requirements.txt"
VENV="jupyterlab"

# Container variables passed during creation
CONTAINER_NAME="jupyterlab"
CONTAINER_BASH_COMMAND="cp /scripts/install_miniconda.sh /scripts/jupyterlab/install_jupyterlab.sh /tmp; \
chmod +x /tmp/install_miniconda.sh /tmp/install_jupyterlab.sh; \
/tmp/install_miniconda.sh; \
/tmp/install_jupyterlab.sh" 

# Some sanity
: ${REQUIREMENTS_FILE:="requirements.txt"}
if [[ ! -f "${REQUIREMENTS_FILE}" ]];
then
    echo "File in path ${REQUIREMENTS_FILE} cannot be found."
    exit 1
elif [[ -z "${MINICONDA_HOME}" ]];
then
    echo "variable MINICONDA_HOME is not defined"
    exit 1
elif [[ -z "${VENV}" ]];
then
    echo "The virtual environment variable VENV is not defined"
    exit 1
fi
}

# Run docker
run_docker () {
    docker run -dit \
    --expose 8888 -P \
    --name "${CONTAINER_NAME}" \
    --hostname "${CONTAINER_NAME}" \
    -e "MINICONDA_HOME=${MINICONDA_HOME}" \
    -e "MINICONDA_VERSION=${MINICONDA_VERSION}" \
    -e "REQUIREMENTS_FILE=${REQUIREMENTS_FILE}" \
    -e "VENV=${VENV}" \
    --volume "$(dirname "${PWD}" )":/scripts \
    "${OPERATING_SYSTEM}" /bin/bash
}

# Source the miniconda script
. "$( dirname "${PWD}" )"/source_docker.sh
