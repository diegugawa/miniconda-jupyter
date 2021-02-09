# Troubleshooting scripts for Miniconda

>Notice: These scripts should not be used for production or shared with our customers.
Because the goal is to document the steps during the creation process or to test the leapyear client and other functionalities particular to our stack, I recommend using this only for troubleshooting.

I am using docker to run the scripts inside a container and then connect to jupyter hub from my local laptop.

## Current list of supported tests using Docker

* Miniconda tests with docker

* Jupyter Hub "SystemdSpawner"

## Using the scripts

* If you wish to run end-to-end tests with the components listed above, run any of the scripts starting with `docker_*.sh`
    * For example, if you wish to test `jupyterhub` run the script `docker_jupyterhub.sh`

* If you want to install Miniconda in any environment _without docker_ just run the script `install_miniconda.sh`. This script however requires the a few environment variables. If you don't want to use environment variables you can add the variables by editing the script in your local machine.
    * The list of variables needed to run this script is the following:
    ```bash
    MINICONDA_VERSION="4.9.2"
    MINICONDA_HOME="/opt/lycra"
    MINICONDA_PATH="${MINICONDA_HOME}/miniconda"
    REQUIREMENTS_FILE="/scripts/requirements.txt"
    VENV="lycra"
    ```
    * As you can see inside the script, these are the default values for the variables listed above. Because the "requirement file" is unique to the tests that you are hoping to run, the path to the file needs to be updated so the script doesn't exit during execution.


### Using docker jupyterhub script

1. The script `docker_jupyterhub.sh` does the following:

    1. Creates an Ubuntu "bionic" docker container by default. But it can additionally work in other operating systems, such as CentOS, and Amazon Linux if an argument for another image is passed during the bash execution.
    * Optional arguments: `centos:<VERSION>` , `amazonlinux:<VERSION>`, `ubuntu:<VERSION>`
    * For example:
    ```bash
    bash docker_jupyterhub.sh amazonlinux:2
    ````

    2. Sources the script `execute_docker.sh` doing a lot of the docker magic.

    3. After the script above has been sourced, it runs the scripts `install_miniconda` and everntually `install_jupyterhub.sh`. These scripts update system packages, downloads `miniconda` and installs the appropiate python packages based on the file `requirements.txt` including "Jupyter Hub".

    4. Once it has downloaded all of the packages, it executes `docker exec -it` leaving you inside the container to play around.

### Using docker miniconda script

1. The script `docker_miniconda.sh` does the following:

    1. Creates an Ubuntu "bionic" docker container by default. But it can additionally work in other operating systems, such as CentOS, and Amazon Linux if an argument for another image is passed during the bash execution.
    * Optional arguments: `centos:<VERSION>` , `amazonlinux:<VERSION>`, `ubuntu:<VERSION>`
    * For example:
    ```bash
    bash docker_miniconda.sh amazonlinux:2
    ````

    2. Sources the script `execute_docker.sh` doing a lot of the docker magic.

    3. After the script above has been sourced, it runs the scripts `install_miniconda`. This script update system packages, downloads `miniconda` and installs the appropiate python packages based on the file `requirements.txt`.

    4. Once it has downloaded all of the packages, it executes `docker exec -it` leaving you inside the container to play around.


