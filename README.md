# Install Jupyter Lab or Jupyter Hub with Miniconda

I am using docker to run the scripts inside a container and then connect to Jupyter Hub or Jupyter Lab from my local laptop.


## Current list of supported environments

* Jupyter Lab

* Jupyter Hub "SystemdSpawner"


## Using these scripts

> Note: The script `source_docker.sh` is needed for the scripts starting with `docker_jupyter*.sh` to execute the logic inside the docker container.


### Using install Miniconda

1. The first script available in this repository is called `install_miniconda.sh`. This script allows you to install miniconda in Linux or MacOS. It uses the file "requirements.txt" to install the packages during the miniconda installation for jupyterhub or jupyterlab.
    ```bash

    Usage: `bash install_miniconda.sh`
    Use "bash install_miniconda.sh --help" for more information.

    Description: Install miniconda from source.

    Required:
    REQUIREMENTS_FILE    The file to install the packages during the miniconda installation for jupyterhub or jupyterlab
                         Default is "requirements.txt" located in the folder where this script is running IF you are running this script _on it's own_

    Optional environment variables:
    MINICONDA_VERSION    The version of miniconda that is going to be installed.
                         Default is '4.9.2'

    MINICONDA_HOME       This is the path where miniconda is going to be installed.
                         Default in "linux" is '/opt
                         Default in "MacOS" is '${HOME}' (the user''s home folder)

    VENV                 The virtual environment specific to the packages that are going to be installed
                         Default is 'myenv'
    ```

    * NOTE: As you can see, because the "requirements" file is unique to each case, the path to the file needs to be updated so the script doesn't exit during execution.


### Using Docker Jupyterhub

The script `docker_jupyterhub.sh` does the following:

1. Creates an Ubuntu "bionic" docker container, using random ports that later are provided to you once the script has finished running.
    ```bash
    bash docker_jupyterhub.sh
    ```
    * If you want to use another Linux OS different than Ubuntu "bionic", you can use other arguments, such as `centos:<VERSION>` , `amazonlinux:<VERSION>`, `ubuntu:<VERSION>` and pass them as an argument. For example:
    ```bash
    bash docker_jupyterhub.sh amazonlinux:2
    ````

2. During execution, it runs the scripts `source_docker.sh`, `install_miniconda` and eventually `install_jupyterhub.sh`. These scripts update system packages, download `miniconda` and install the appropiate packages based on the file `requirements.txt` including "Jupyter Hub".

3. As one of the last steps, it creates 5 temporary usernames and passwords that you can use to access an multiuse environment.

4. Once Jupyter Hub has been installed it executes `docker exec -it` leaving you inside the container to play around.

* Note: The container will continue running after exiting the shell.

### Using docker jupyterlab

The script `docker_jupyterlab.sh` does the following:

1. Creates an Ubuntu "bionic" docker container, using random ports that later are provided to you once the script has finished running.
    ```bash
    bash docker_jupyterlab.sh
    ```
    * If you want to use another Linux OS different than Ubuntu "bionic", you can use other arguments, such as `centos:<VERSION>` , `amazonlinux:<VERSION>`, `ubuntu:<VERSION>` and pass them as an argument. For example:
    ```bash
    bash docker_jupyterlab.sh amazonlinux:2
    ````

2. During execution, it runs the scripts `source_docker.sh`, `install_miniconda` and eventually `install_jupyterlab.sh`. These scripts update system packages, download `miniconda` and install the appropiate packages based on the file `requirements.txt` including "Jupyter Lab".

3. As one of the last steps, it creates a temporary directory as well as a random "token" that you can use to connect from the URL.

4. Once Jupyter Hub has been installed it executes `docker exec -it` leaving you inside the container to play around.

* Note: The container will continue running after exiting the shell.
