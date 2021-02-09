#!/usr/bin/env bash

set -e
#set -x

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

###### BEGINNING of JUPYTERLAB section ######
jupyterlab_sanity

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
