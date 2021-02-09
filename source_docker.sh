#!/usr/bin/env bash

set -e
#set -x

#
# THIS SCRIPT IS NOT MEANT TO RUN ALONE. IT SHOULD BE SOURCE.
#

OPERATING_SYSTEM="$1"

docker_sanity () {
    # set default version of miniconda
    : "${MINICONDA_VERSION:="$( cat 'miniconda_version.txt' )"}"
    if [[ "${MINICONDA_VERSION}" == *"No such file or directory"* ]];
    then
        MINICONDA_VERSION="4.9.2"
    fi
    # Set a default operating system if the argument was not passed
    if [[ -z "${OPERATING_SYSTEM}" ]];
    then
      OPERATING_SYSTEM='ubuntu:bionic'
      echo "No operating system was selected. Using '""${OPERATING_SYSTEM}""' as default."
    fi

    # Check that docker exist
    if ! type -P "docker" >/dev/null;
    then
      echo "'docker' service is not installed or properly configured in this host.";
      exit 1
    fi

    # Check 'run_docker' function
    CHECK_RUN_DOCKER="$( declare -f run_docker > /dev/null; echo $? )"
    if [[ "${CHECK_RUN_DOCKER}" -ne 0  ]];
    then
      echo "The function 'run_docker' cannot be found. Check that you are sourcing this file correctly";
      exit 1;
    fi
}

# Check if the docker container is running
start_container () {
    if [ "$( docker ps -a --format '{{.Names}}' | grep -i "${CONTAINER_NAME}" 2>/dev/null )" == "${CONTAINER_NAME}" ];
    then
      echo "Stopping the container: "; docker stop "${CONTAINER_NAME}";
      echo "Removing the container: "; docker rm "${CONTAINER_NAME}";
      echo "Creating and running the new container ID: "; run_docker;
    else
      echo "Creating and running the new container ID: "; run_docker;
    fi
}

# Install jupyterhub from script
install_application () {
    docker exec "${CONTAINER_NAME}" /bin/bash -c "${CONTAINER_BASH_COMMAND}"
}

# List the ports being exposed in the container
container_ports () {
    PORTS="$( docker port "${CONTAINER_NAME}" | awk '{ print $1 "-" $3 }' )"
    for p in ${PORTS};
    do
      CONTAINER_PORT="$( echo "${p}" | cut -d "-" -f 1 )"
      HOST_PORT="$( echo "${p}" | cut -d "-" -f 2 )"
      echo "

NOTICE: The port ${CONTAINER_PORT} from the container '""${CONTAINER_NAME}""' is accessible from the URL http://${HOST_PORT} in your local host.
      "
    done
}

execute_container () {
    echo "


Installation has been completed. Entering the container shell..


    "
    docker exec -it "${CONTAINER_NAME}" /bin/bash
}

docker_sanity
start_container
install_application
container_ports
execute_container

# Don't forget to let the user know that this container is still running
echo "


ATTENTION: The container '""${CONTAINER_NAME}""' is still running.


     "
