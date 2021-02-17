#!/usr/bin/env bash

set -e
#set -x

#####################################################
#                                                   #
#    Run this script after install_miniconda.sh     #
#                                                   #
#####################################################

# Confirm there are no errors before running this script
CHECK_ERRORS="$( echo $? )"
if [[ "${CHECK_ERRORS}" -ne 0  ]];
then
    echo "Some errors were encountered before running this script. Execution has been aborted.";
    exit 1;
fi

HERE="$( builtin cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TOP="$( builtin cd "$( dirname "${HERE}" )" && pwd )"

jupyterlab_sanity () {
    # Check the requirements file exists
    : ${REQUIREMENTS_FILE:="${HERE}/requirements.txt"}
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
    else
        echo '

Installing jupyterlab now...

        '
    fi
}
jupyterlab_sanity

###### BEGINNING of JUPYTERLAB section ######

# Install packages from file
"${MINICONDA_HOME}"/bin/conda create -yq -n "${VENV}" --file "${REQUIREMENTS_FILE}"

export PATH="${MINICONDA_HOME}/envs/${VENV}/bin:$PATH"
TOKEN="$( date | sha256sum | base64 | head -c 32 )"
TEMP_DIR="$( mktemp -d -t jupyter-dirXXXXX )"

echo "

Use the following token to access the environment '""${TOKEN}""'.
...and save it somewhere.

The following directory has been created to store the notebooks '""${TEMP_DIR}""'
The Notebooks in this directory will dissapear after you stop the container.

"

# Start jupyterlab in the background
"${MINICONDA_HOME}"/envs/"${VENV}"/bin/jupyter lab \
    --allow-root \
    --NotebookApp.ip=0.0.0.0 \
    --NotebookApp.token="${TOKEN}" \
    --NotebookApp.notebook_dir="${TEMP_DIR}" &

###### END of JUPYTERLAB section ######
