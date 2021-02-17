# Miniconda with Jupyter Hub or Jupyter Lab

By using some of the scripts in this project users can install Miniconda in either Linux or Mac. Once Miniconda has been installed, they can later install Jupyter Hub or Jupyter Lab.
This can be done automatically using containers or manually by sourcing these scripts.

The current list of supported environments is the following:

* Miniconda, with default python 3.7 for global environment
* Jupyter Lab
* Jupyter Hub "SystemdSpawner"

## Table of contents

- [Miniconda with Jupyter Hub or Jupyter Lab](#miniconda-with-jupyter-hub-or-jupyter-lab)
  * [Table of contents](#table-of-contents)
  * [Running these applications in containers](#running-these-applications-in-containers)
  * [Installing Jupyter Hub or Lab](#installing-jupyter-hub-or-lab)
  * [Information about the files and what they do](#information-about-the-files-and-what-they-do)

## Running these applications in containers

Under the folders "jupyterhub" and "jupyterlab" a user can run the scripts `docker_jupyterhub.sh` or `docker_jupyterlab.sh` to build docker container for either of these applications.
The logic in these scripts will download all of the necessary packages listed inside `requirements.txt`. This file is unique to each application and packages can be updated or changed according to the user.


## Installing Jupyter Hub or Lab 

In the event that a user does not want to use containers to install Miniconda with Jupyter Hub or Lab, the user can do the following:

1. Install miniconda by running `bash install_miniconda.sh`
This will install the base script to run miniconda, and export the necessary variables to later use them with other scripts.

2. Install the applications Jupyter Hub or Lab
After Miniconda has been install, now you can access one of the folders `jupyterhub` or `jupyterlab` and then run the script for either of these projects:
    * For Jupyter Lab run `install_jupyterlab.sh`
    * For Jupyter Hub run `install_jupyterhub.sh`

These scripts will read either of the `requirements.txt` files from these folders. Remember to update the file with the packages that make sense to you.


## Information about the files and what they do

* `install_miniconda.sh` is the main script that allows to install Miniconda for Mac or Linux

* `miniconda_version.txt` is a file that provides the version of miniconda that is going to be installed. If this file is not present, `install_miniconda.sh` will install the version 4.9.2 by default. The version can be changed to work with any version of Miniconda that you would want.

* `source_docker.sh` is needed for the scripts starting with `docker_jupyter*.sh` to execute the logic inside the docker container. It allows the user to select different versions of an operating system for testing purposes. This must be used with the _docker_ scripts that I'm mentioning next.

* `docker_jupyterhub.sh` or `docker_jupyterlab.sh` allow the user to create a docker container for Jupyter Hub or Lab, invoking all of the files listed above plus `install_jupyterhub.sh` or `install_jupyterlab.sh` accordingly.
When either of these applications is being installed in the container, the container will use the default port(s) required for these applications; however the local host will be EXPOSING random ports instead of the default ports for these apps. 
The reason for doing this, it's so in the event that these scripts are used for testing, we can avoid collision errors in the local host running docker.  For convenience I have provided some logic to print the list of ports and how those are accesible after the scripts has been ran.
As mentioned in the bullet above, when using these scripts you can select the operating system that you want the container to be running. By default I am using **Ubuntu bionic**.
In the following section you can see how to use the scripts for docker containers, and alternatively select the operating system that you want:
    ```bash
    bash docker_jupyterhub.sh
    ```

    * In order to use another Linux OS different than Ubuntu "bionic", you can use other arguments, such as `centos:<VERSION>` , `amazonlinux:<VERSION>`, `ubuntu:<VERSION>`. For example:
    ```bash
    bash docker_jupyterhub.sh amazonlinux:2
    ````
Once either of these applications have been installed, the script executes `docker exec -it` leaving you inside the container to play around.

**NOTE:** Every time that `docker_jupyterhub.sh` or `docker_jupyterlab.sh` is executed, the script will stop and remove the previous container to avoid a name collision with Docker. If you want to have multiple environments of the same application, I recommend you to change the variable before executing the script. This can be done from your shell by simply using environment variables. For example:
    ```bash
    export CONTAINER_NAME="test-centos8" && bash docker_jupyterlab.sh centos:8
    ```

* `install_jupyterhub.sh` as part of the features mentioned above, this script will install Jupyter Hub and create 5 usernames and passwords in the host to access an multiuser environment. If you _do not_ wish to assign random users to the environment, comment out the function at the end of the script.

* `install_jupyterlab.sh` as part of the features mentioned above, this script will create also a random token to access Jupyter Lab environment and create a temporary directory that is used to stored the notebooks. These values can be overrided by simply passing environment variables from your host machine or overriding those in the script.
    * The current variables look like this:
    ```bash
    : ${TOKEN:="$( date | sha256sum | base64 | head -c 32 )"}
    : ${NOTEBOOK_DIR:="$( mktemp -d -t jupyter-dirXXXXX )"}
    ```
    So you can either pass an environment variable like this before you run the script or write them at the top the installation script to override the default values above.
    ```bash
    export TOKEN="mysuperawesometoken12345"
    export NOTEBOOK_DIR="/myhomedirectory/notebooks"
    ```
