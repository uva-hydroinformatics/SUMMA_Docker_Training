# Approach-3-Docker-for-SUMMA-and-pySUMMA
This repo contains instructions for creating a Docker image or running a pre-existing Docker image that can support the usage of SUMMA and pySUMMA simulations.

## Setup
**Ubuntu**
1. Install Docker with `sudo apt install docker.io` in the terminal.
2. Git clone or copy the files in this repository into a folder.

## Configuration files
- `Dockerfile` - A text file used by Docker that lists all the commands used to build an image. This includes commands such as those that install packages and add local files to the image. More info [here](https://docs.docker.com/engine/reference/builder/).
- `environment.yml` - A text file used by Conda that lists all of packages to be installed and creates a virtual environment. It specifies the environment name and the channels to install the packages from. More info [here](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html).

## Creating the Docker image
1. In the terminal, change directories into the folder containing the files.
2. Create the Docker image with:
`docker build .`
The command will step through the Dockerfile and output the results of each line.
3. When the build completes. Using the `docker images` command will list all the images. 
**(optional)** The created Docker image will have no name associated with it. Use `docker tag containerID yourContainerName` to rename it.
4. Run the image with:
`docker run -it -p=8888:8888 [containerNameOrID]`
This will create a container which is based off the image. It will create a bash terminal inside the container. Exit the container using the command: `exit`
    - the -it flag creates a terminal instance inside of the container.
    - the -p flag publishes the container's port 8888 to the host's port 8888. **If something is already running on port 8888 localhost, then the number needs to be changed.** 
    - the -v flag mounts the specified directories into the container so that it has access to the host's docker daemon
    - **(optional)** the --rm flag deletes the container after exiting, otherwise, it will keep running in the background. 
5. After entering the terminal, a jupyter notebook server can be launched  with the following command:
`jupyter notebook --ip=0.0.0.0 --allow-root`

## Running a pre-existing Docker image
1. An image can be found [here](https://hub.docker.com/repository/docker/davidchoi76/summa3) on DockerHub. Pull the image to your machine using:
`docker pull davidchoi76/summa3:tagname`
2. After the image finishs downloading, follow step 4 and on from the instructions above.

## Adding files to the image or container
In the event you already have a notebook or other files you want to include.
- **If creating a Docker image**
    - Just add the desired files to the directory with the Dockerfile before running `docker build .`
- **If running a pre-existing image**
    - Run `docker cp path/to/file  containerID:path/to/file` after running the image 

## Helpful commands
- List all running containers with `docker ps -a`. 
- Delete running containers with `docker container rm ContainerID`
