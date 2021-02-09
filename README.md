# Troubleshooting scripts for Miniconda

I am using docker to run the scripts inside a container and then connect to jupyter hub from my local laptop.

## Current list of supported tests using Docker

* Miniconda tests with docker

* Jupyter Hub "SystemdSpawner"

## Using the scripts

> Note: The script `source_docker.sh` is needed for the scripts starting with `docker_jupyter...sh` to execute the logic inside the docker container.

### Using install Miniconda

1. The first script available in this repository is called `install_miniconda.sh`. This script allows you to install miniconda in Linux or MacOS. It uses the file "requirements.txt" to install the packages during the miniconda installation for jupyterhub or jupyterlab.
    ```bash
    Required:
    REQUIREMENTS_FILE    The file to install the packages during the miniconda installation for jupyterhub or jupyterlab
                         Default is "requirements.txt" loaded in the folder that this script is running.

    Optional environment variables:
    MINICONDA_VERSION    The version of miniconda that is going to be installed.
                         Default is '4.9.2'

    MINICONDA_HOME       This is the path where miniconda is going to be installed.
                         Default in "linux" is '/opt
                         Default in "MacOS" is '${HOME}' (the user''s home folder)

    VENV                 The virtual environment specific to the packages that are going to be installed
                         Default is 'myenv'
    ```

    * As you can see inside the script, these are the default values for the variables listed above. Because the "requirement file" is unique to the tests that you are hoping to run, the path to the file needs to be updated so the script doesn't exit during execution.


### Using Docker Jupyterhub

1. The script `docker_jupyterhub.sh` does the following:

    1. Creates an Ubuntu "bionic" docker container by default. But it can additionally work in other operating systems, such as CentOS, and Amazon Linux if an argument for another image is passed during the bash execution.
    * Optional arguments: `centos:<VERSION>` , `amazonlinux:<VERSION>`, `ubuntu:<VERSION>`
    * For example:
    ```bash
    bash docker_jupyterhub.sh amazonlinux:2
    ````

    2. Sources the script `source_docker.sh` doing a lot of the docker magic.

    3. After the script above has been sourced, it runs the scripts `install_miniconda` and eventually `install_jupyterhub.sh`. These scripts update system packages, downloads `miniconda` and install the appropiate packages based on the file `requirements.txt` including "Jupyter Hub".

    4. Once it has downloaded all of the packages, it executes `docker exec -it` leaving you inside the container to play around.

### Using docker jupyterlab

1. The script `docker_jupyterlab.sh` does the following:

    1. Creates an Ubuntu "bionic" docker container by default. But it can additionally work in other operating systems, such as CentOS, and Amazon Linux if an argument for another image is passed during the bash execution.
    * Optional arguments: `centos:<VERSION>` , `amazonlinux:<VERSION>`, `ubuntu:<VERSION>`
    * For example:
    ```bash
    bash docker_jupyterlab.sh amazonlinux:2
    ````

    2. Sources the script `source_docker.sh` doing a lot of the docker magic.

    3. After the script above has been sourced, it runs the scripts `install_miniconda` and eventually `install_jupyterlab.sh`. This script update system packages, downloads `miniconda` and install the appropiate packages based on the file `requirements.txt`.

    4. Once it has downloaded all of the packages, it executes `docker exec -it` leaving you inside the container to play around.


