#!/usr/bin/env bash

set -e
#set -x

#####################################################
#                                                   #
# Run this script after using `install_miniconda.sh #
#                                                   #
#####################################################

jupyterhub_sanity () {
    if [[ -z "${MINICONDA_HOME}" ]];
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
    else
        echo '


Installing Jupyterhub now...


        '
    fi
}

###### BEGINNING of JUPYTERHUB LEAPYEAR section ######

install_jupyterhub () {
    # Fixing bug in miniconda, where `npm` executable cannot be found in PATH
    #export PATH="${MINICONDA_HOME}/envs/${VENV}/bin:$PATH"

    # Install configurable HTTP proxy for reverse URL and TLS
    "${MINICONDA_HOME}"/envs/"${VENV}"/bin/npm install -g configurable-http-proxy

    # Install Jupyter Hub with SystemdSpawner
    "${MINICONDA_HOME}"/envs/"${VENV}"/bin/pip install jupyterhub-systemdspawner

    # Test later with 'dockerspawner'
    #"${MINICONDA_HOME}"/envs/"${VENV}"/bin/pip install dockerspawner
}

configure_jupyterhub() {
    # System setup of jupyterhub
    mkdir -p "${JUPYTERHUB_HOME}"/certs
    mkdir -p "${JUPYTERHUB_HOME}"/bin
    mkdir -p "${JUPYTERHUB_HOME}"/conf

    #cp "${CORE_CERT_PATH}" /opt/leapyear/jupyterhub/certs
    #cp "${LEAPYEAR_PUBLIC_KEY}" /opt/leapyear/jupyterhub/certs
    #sudo chmod 600 /opt/leapyear/jupyterhub/certs/*.crt
    #cp "${JUPYTERHUB_CONFIG_FILE}" /opt/leapyear/jupyterhub/conf

    # The script below will generate a 'jupyterhub_config.py' file if this is not found.
    # This is for debugging, but in reality I find it very tacky the idea of creating files from a script...
    cat > "${JUPYTERHUB_HOME}"/bin/start-jupyterhub.sh <<'EOF'
#!/usr/bin/env bash

#set -ex pipefail

if [[ -z "${MINICONDA_HOME}" ]];
then
    MINICONDA_HOME="/opt/leapyear/miniconda"
elif [[ -z "${JUPYTERHUB_HOME}" ]];
then
    JUPYTERHUB_HOME="${MINICONDA_HOME}/jupyterhub"
elif ! type -P "conda" >/dev/null;
    source "${MINICONDA_HOME}"/etc/profile.d/conda.sh
fi

# Activate conda environment "jupyterhub"
conda activate jupyterhub
if [ ! -f "${JUPYTERHUB_HOME}/conf/jupyterhub_config.py" ];
then
    cd "${JUPYTERHUB_HOME}/conf"
    jupyterhub --generate-config
    sed -i -e "s|#c.Spawner.default_url = ''|c.Spawner.default_url = '/lab'|g" "${JUPYTERHUB_HOME}/conf/jupyterhub_config.py"
fi
exec jupyterhub -f "${JUPYTERHUB_HOME}/conf/jupyterhub_config.py"
EOF
}

# Create some local Jupyter Hub users to login
create_test_user () {
    echo "

Creating local users for Jupyter Hub

    "
    for (( i=1; i<=5; i++ ))
    do
      TEST_USER="user"
      PASSWORD="$( date | sha256sum | base64 | head -c 32 )"
      CREDENTIALS_FILE="/tmp/credentials.txt"
      # Create the local users. Jupyterhub requires for all users to have a "home" directory
      useradd -m "${TEST_USER}${i}"
      echo "${TEST_USER}${i}:${PASSWORD}" | chpasswd
      echo "Jupyterhub '""${TEST_USER}${i}""' has been created using password '""${PASSWORD}""'" | tee -a "${CREDENTIALS_FILE}"
      sleep 1
    done
    echo "

    Local users have been created. Store this information somewhere or print the file '""${CREDENTIALS_FILE}""'.

    "
}

jupyterhub_sanity
install_jupyterhub
configure_jupyterhub
create_test_user

# Start jupyterhub in the background
bash "${JUPYTERHUB_HOME}"/bin/start-jupyterhub.sh &

###### END of JUPYTERHUB LEAPYEAR section ######
