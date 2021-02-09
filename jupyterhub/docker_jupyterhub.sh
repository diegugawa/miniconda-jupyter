#!/usr/bin/env bash

set -e
#set -x

builtin cd "$( dirname "${BASH_SOURCE[0]}" )"

# Environment variables
MINICONDA_HOME="/opt/miniconda"
MINICONDA_VERSION="$( cat $( dirname "${PWD}" )/miniconda_version.txt )"
JUPYTERHUB_HOME="${MINICONDA_HOME}/jupyterhub"
REQUIREMENTS_FILE="/scripts/jupyterhub/requirements.txt"
VENV="jupyterhub"

# Container variables passed during creation
CONTAINER_NAME="jupyterhub"
CONTAINER_BASH_COMMAND="cp /scripts/install_miniconda.sh /scripts/jupyterhub/install_jupyterhub.sh /tmp; \
chmod +x /tmp/install_miniconda.sh /tmp/install_jupyterhub.sh; \
/tmp/install_miniconda.sh; \
/tmp/install_jupyterhub.sh" 

# Run docker
run_docker () {
    docker run -dit \
    --expose 8989 -P \
    --expose 8000 -P \
    --name "${CONTAINER_NAME}" \
    --hostname "${CONTAINER_NAME}" \
    -e "MINICONDA_HOME=${MINICONDA_HOME}" \
    -e "MINICONDA_VERSION=${MINICONDA_VERSION}" \
    -e "JUPYTERHUB_HOME=${JUPYTERHUB_HOME}" \
    -e "REQUIREMENTS_FILE=${REQUIREMENTS_FILE}" \
    -e "VENV=${VENV}" \
    --volume "$(dirname "${PWD}" )":/scripts \
    "${OPERATING_SYSTEM}" /bin/bash
}

# Source the miniconda script
. "$( dirname "${PWD}" )"/source_docker.sh
