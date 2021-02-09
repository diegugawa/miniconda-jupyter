#!/usr/bin/env bash

set -e
#set -x


helpme () {
    USAGE='

Usage: Use "bash install_miniconda.sh --help" for more information.
Combinations: bash install_miniconda.sh

Install miniconda from source.
This script also can be sourced from other files from this repository or it can run on its own.
It uses the file "requirements.txt" to install the packages during the miniconda installation for jupyterhub or jupyterlab. 

Required:
REQUIREMENTS_FILE    The file to install the packages during the miniconda installation for jupyterhub or jupyterlab 
                     Default is "requirements.txt" loaded in the folder that this script is running.
		     
Optional environment variables:
MINICONDA_VERSION    The version of miniconda that is going to be installed.
                     Default is '4.9.2'

MINICONDA_HOME       This is the path where miniconda is going to be installed.
                     Default in "linux" is '/opt'
		     Default in "MacOS" is '${HOME}' (the user''s home folder)

VENV                 The virtual environment specific to the packages that are going to be installed
                     Default is 'myenv'

'
    echo "${USAGE}"
}

# Show the usage
if [[ "$1" == '--help' ]]; then
    helpme
    exit 0
elif [[ "$1" != '--help' ]]; then
    echo "ERROR: Type '--help' to see how to use this script"
    helpme
    exit 1
fi

miniconda_sanity () {
    # set default variables
    : ${MINICONDA_VERSION:='4.9.2'}
    : ${VENV:='myenv'}
    # Check the requirements file exists
    : ${REQUIREMENTS_FILE:="$( dirname "${BASH_SOURCE[0]}" )/requirements.txt"}
    if [[ ! -f "${REQUIREMENTS_FILE}" ]];
    then
        echo "File in path ${REQUIREMENTS_FILE} cannot be found."
        helpme
	exit 1
    fi
}

# Announce this is running
announcement() {
  echo '


Executing installation script. This is going to take a while.
Stay back and relax...


'
}

# Install miniconda
install_miniconda() {
    # DO NOT USER ANACONDA REPO, IT HAS ISSUES. Use only "continuum" which is recommended by Jupyter.
    curl -L https://repo.continuum.io/miniconda/"${MINICONDA_INSTALLER}" \
    -o /tmp/"${MINICONDA_INSTALLER}"
    chmod +x "/tmp/${MINICONDA_INSTALLER}"
    bash /tmp/"${MINICONDA_INSTALLER}" -f -b -p "${MINICONDA_HOME}"
    export PATH="${MINICONDA_HOME}/bin:$PATH"

    # Set the conda-forge channel at the top https://conda-forge.org/
    "${MINICONDA_HOME}"/bin/conda config --system --add channels conda-forge
    "${MINICONDA_HOME}"/bin/conda config --system --set auto_update_conda false
    "${MINICONDA_HOME}"/bin/conda config --system --set show_channel_urls true
    "${MINICONDA_HOME}"/bin/conda config --system --set channel_priority strict

    # Install packages from file
    "${MINICONDA_HOME}"/bin/conda create -yq -n "${VENV}" --file "${REQUIREMENTS_FILE}"

    # Source environment
    source "${MINICONDA_HOME}"/bin/activate
}

# Confirm the operating system before installing miniconda
main () {
    MACHINE_TYPE="$( uname -s )"
    case "${MACHINE_TYPE}" in
        Darwin* )
            : ${MINICONDA_HOME:="${HOME}"}
            miniconda_sanity
            MINICONDA_INSTALLER="Miniconda3-py38_${MINICONDA_VERSION}-MacOSX-x86_64.sh"
            announcement
            install_miniconda
            ;;
        Linux*)
            : ${MINICONDA_HOME:='/opt'}
            miniconda_sanity
            MINICONDA_INSTALLER="Miniconda3-py38_${MINICONDA_VERSION}-Linux-x86_64.sh"
            LINUX_TYPE="$( cat /etc/os-release | grep -i 'ID_LIKE' )"
            case "${LINUX_TYPE}" in
                # Centos and Red Hat
                'ID_LIKE="rhel fedora"' )
                    yum -y upgrade
                    announcement
                    install_miniconda
                    ;;
                # Amazon
                'ID_LIKE="centos rhel fedora"' )
                    yum -y upgrade
                    announcement
                    install_miniconda
                    ;;
                # Ubuntu
                'ID_LIKE=debian' )
                    apt -y update
                    apt -y install curl
                    announcement
                    install_miniconda
                    ;;
                # Other Linux distros
                * )
                    echo "This OS is currently not supported. Exiting Miniconda installation."
                    exit 1
                    ;;
            esac
            ;;
        *)
            echo "This OS is currently not supported. Exiting Miniconda installation."
            exit 1
            ;;
    esac
}

main

