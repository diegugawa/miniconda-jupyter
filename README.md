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
  * [Running Jupyter Hub or Lab in Docker](#running-jupyter-hub-or-lab-in-docker)
  * [Installing Jupyter Hub or Lab without Docker](#installing-jupyter-hub-or-lab-without-docker)
  * [Using  different operating systems](#using--different-operating-systems)
  * [Information about the files and what they do](#information-about-the-files-and-what-they-do)


## Prerequisites
* Docker 19.x or above
* Mac OS or Linux
* 10GB of free disk space


## Running Jupyter Hub or Lab in Docker

Enter one of the subfolders "jupyterhub" and "jupyterlab" for the application that you want to run:
* `run_jupyterhub.sh` to build a docker container installing Jupyter Hub.
* or `run_jupyterlab.sh` to build a docker container Jupyter Lab.
These scripts will download all of the necessary packages listed inside `requirements.txt`. This file is unique to each application and packages can be updated or changed according to the user.

When accessing the folders mentioned above, in your terminal run:
```bash
bash run_jupyterhub.sh
```
Or alternatively for Jupyter Lab run:
```bash
bash run_jupyterlab.sh
```

## Installing Jupyter Hub or Lab without Docker

> This is suggested for permanent environments, such as EC2 instances, Virtual machines, etc.

In the event that a user does not want to use containers to install Miniconda with Jupyter Hub or Lab, the user can do the following:

1. Install miniconda by running `bash install_miniconda.sh`
This will install the base script to run miniconda, and export the necessary variables to later use them with other scripts.

2. Install the applications Jupyter Hub or Lab
After Miniconda has been install, now you can access one of the folders `jupyterhub` or `jupyterlab` and then run the script for either of these projects:
    * To install Jupyter Lab run `bash install_jupyterlab.sh`
    * To install Jupyter Hub run `bash install_jupyterhub.sh`

These scripts will read either of the `requirements.txt` files from these folders. Remember to update the file with the packages that make sense to you.


## Using  different operating systems

When using these scripts with Docker, you can select the operating system that you want the container to be running. By default I am using **Ubuntu bionic**.
In the following example I'm using bash just to run the default program with Docker, and alternatively select the operating system that you want:
```bash
bash run_jupyterhub.sh
```

In order to use another Linux OS different than Ubuntu "bionic", you can use other arguments, such as `centos:<VERSION>` , `amazonlinux:<VERSION>`, `ubuntu:<VERSION>`. For example:
```bash
bash run_jupyterhub.sh amazonlinux:2
````
Once either of these applications have been installed, the script executes `docker exec -it` leaving you inside the container to play around.

**NOTE:** Every time that `run_jupyterhub.sh` or `run_jupyterlab.sh` is executed, the script will stop and remove the previous container to avoid a name collision with Docker. 
If you want to have multiple environments of the same application, I recommend you to change the name of the container before executing either of these scripts. This can be done from your shell by simply using an environment variable. For example:
```bash
export CONTAINER_NAME="test-centos8" && bash run_jupyterlab.sh centos:8
```


## Information about the files and what they do

* `install_miniconda.sh` is the main script that allows to install Miniconda for Mac or Linux

* `miniconda_version.txt` is a file that provides the version of miniconda that is going to be installed. If this file is not present when using the script above, `install_miniconda.sh` will install the version 4.9.2 by default. The version can be changed to work with any version of Miniconda that you want.

* `source_docker.sh` is needed for the scripts starting with `run_jupyter*.sh` to execute the logic inside the docker container. It allows the user to select different versions of an operating system for testing purposes. This must be used with the _docker_ scripts that I'm mentioning next. **This script cannot be used alone.**

* `run_jupyterhub.sh` or `run_jupyterlab.sh` allows the user to create a docker container for Jupyter Hub or Lab, by invoking all of the files listed above plus `install_jupyterhub.sh` or `install_jupyterlab.sh` accordingly.
When either of these applications is being installed in the container, the container will use the default port(s) required for these applications; however the local host will be EXPOSING random ports instead of the default ports for these apps. 
The reason for doing this, it's so in the event that these scripts are used for testing, we can avoid collision errors in the local host running docker.  For convenience I have provided some logic to print the list of ports and how those are accesible after the scripts has been ran.

* `install_jupyterhub.sh` as part of the features mentioned above, this script will install Jupyter Hub and create 5 usernames and passwords in the host to access an multiuser environment. If you _do not_ wish to assign random users to the environment, comment out the function at the end of the script.

* `install_jupyterlab.sh` as part of the features mentioned above, this script will create also a random token to access Jupyter Lab environment and create a temporary directory that is used to stored the notebooks. These values can be overrided by simply passing environment variables from your host machine or overriding those in the script.
    * The current variables look like this:
    ```bash
    : ${TOKEN:="$( date | sha256sum | base64 | head -c 32 )"}
    : ${NOTEBOOK_DIR:="$( mktemp -d -t jupyter-dirXXXXX )"}
    ```
    So you can either pass an environment variable like this before you run the script or write them at the top the installation script to override the default values above. If you are looking to do this with docker make sure that you pass the environment variables under the function `run_docker` inside the file `docker_jupyter<lab or hub>.sh`
    ```bash
    export TOKEN="mysuperawesometoken12345"
    export NOTEBOOK_DIR="/myhomedirectory/notebooks"
    ```

