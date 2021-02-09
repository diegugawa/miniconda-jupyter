#!/usr/bin/env bash

set -e
#set -x

# Environment variables
MINICONDA_HOME="/opt/leapyear/miniconda"
MINICONDA_VERSION="$( cat 'miniconda_version.txt' )"
REQUIREMENTS_FILE="/scripts/miniconda/requirements.txt"
VENV="jupyterlab"

# Container variables passed during creation
CONTAINER_NAME="jupyterlab"
CONTAINER_BASH_COMMAND="cp /scripts/install_miniconda.sh /tmp; chmod +x /tmp/install_miniconda.sh; /tmp/install_miniconda.sh"

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
    --volume "${PWD}":/scripts \
    "${OPERATING_SYSTEM}" /bin/bash
}

# Source the miniconda script
. execute_docker.sh
