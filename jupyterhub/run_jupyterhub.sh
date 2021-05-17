#!/usr/bin/env bash

set -e
#set -x

HERE="$( builtin cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TOP="$( builtin cd "$( dirname "${HERE}" )" && pwd )"

# Environment variables
MINICONDA_VERSION="$( cat "${TOP}"/miniconda_version.txt )"
MINICONDA_HOME="/opt/miniconda"
JUPYTERHUB_HOME="${MINICONDA_HOME}/jupyterhub"
VENV="jupyterhub"
REQUIREMENTS_FILE="${HERE}/requirements.txt"

# Container variables passed during creation
: ${CONTAINER_NAME:="jupyterhub"}
CONTAINER_BASH_COMMAND="cp /scripts/install_miniconda.sh /scripts/jupyterhub/install_jupyterhub.sh /scripts/jupyterhub/requirements.txt /tmp; \
chmod +x /tmp/install_miniconda.sh /tmp/install_jupyterhub.sh; \
/tmp/install_miniconda.sh; \
/tmp/install_jupyterhub.sh" 

# Sanity checking
if [[ ! -f "${REQUIREMENTS_FILE}" ]];
then
    echo "File in path ${REQUIREMENTS_FILE} cannot be found."
    exit 1
elif [[ -z "${MINICONDA_HOME}" ]];
then
    echo "variable MINICONDA_HOME is not defined"
    exit 1
elif [[ -z "${JUPYTERHUB_HOME}" ]];
then
    echo "variable JUPYTERHUB_HOME is not defined"
    exit 1
elif [[ -z "${VENV}" ]];
then
    echo "The virtual environment variable VENV is not defined"
    exit 1
fi


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
    -e "VENV=${VENV}" \
    --volume "${TOP}":/scripts \
    "${OPERATING_SYSTEM}" /bin/bash
}

# Source the miniconda script
. "${TOP}"/source_docker.sh
