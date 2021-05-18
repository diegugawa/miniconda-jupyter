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

###### BEGINNING of JUPYTERLAB section ######

install_jupyterlab () {
    # Install packages from file
    "${MINICONDA_HOME}"/bin/conda create -yq -n "${VENV}" --file "${REQUIREMENTS_FILE}"

    export PATH="${MINICONDA_HOME}/envs/${VENV}/bin:$PATH"
    : ${TOKEN:="$( date | sha256sum | base64 | head -c 32 )"}
    : ${NOTEBOOK_DIR:="$( mktemp -d -t jupyter-dirXXXXX )"}

    echo "

Use the following token to access the environment '""${TOKEN}""'.
...and save it somewhere.

The following directory has been created to store the notebooks '""${NOTEBOOK_DIR}""'
If you are running this in a container, the Notebooks in this directory will dissapear after you stop the container.

    "
}

jupyterlab_startupscript () {
    # Create a file to start jupyter lab
    cat > "${MINICONDA_HOME}"/envs/"${VENV}"/bin/start-jupyterlab.sh <<EOF
#!/usr/bin/env bash

#set -ex pipefail

source "${MINICONDA_HOME}"/etc/profile.d/conda.sh

# Activate conda environment
conda activate jupyterlab

# Start jupyterlab
${MINICONDA_HOME}/envs/${VENV}/bin/jupyter lab \
  --allow-root \
  --NotebookApp.ip=0.0.0.0 \
  --NotebookApp.token="${TOKEN}" \
  --NotebookApp.notebook_dir="${NOTEBOOK_DIR}"

echo "Starting Jupyter Lab"
EOF
}

jupyterlab_sanity
install_jupyterlab
jupyterlab_startupscript

# Start jupyterlab in the background
chmod a+x "${MINICONDA_HOME}"/envs/"${VENV}"/bin/start-jupyterlab.sh
nohup "${MINICONDA_HOME}"/envs/"${VENV}"/bin/start-jupyterlab.sh >> /tmp/jupyterlab_audit.log 2>&1 &

###### END of JUPYTERLAB section ######
