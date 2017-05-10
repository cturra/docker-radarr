#!/bin/bash

# grab global variables
source vars

DOCKER=$(which docker)

# function to check if container is running
function check_container() {
  $DOCKER ps --filter "name=${CONTAINER_NAME}" --format "{{.ID}}"
}

# function to start new docker container
function start_container() {
  $DOCKER run --name=${CONTAINER_NAME}                         \
              --restart=always                                 \
              --detach=true                                    \
              --volume=/etc/localtime:/etc/localtime:ro        \
              --volume=${EXT_CONFIG_DIR}:${INT_CONFIG_DIR}     \
              --volume=${EXT_MEDIA_DIR}:${INT_MEDIA_DIR}       \
              --volume=${EXT_DOWNLOAD_DIR}:${INT_DOWNLOAD_DIR} \
              --publish=7878:7878                              \
              ${IMAGE_NAME}:latest > /dev/null
}

# check if docker container with same name is already running.
if [ "$(check_container)" != "" ]; then
  # container found...
  # 1) rename existing container
  $DOCKER rename ${CONTAINER_NAME} "${CONTAINER_NAME}_orig" > /dev/null 2>&1
  # 2) stop exiting container
  $DOCKER stop "${CONTAINER_NAME}_orig" > /dev/null 2>&1
  # 3) start new container
  start_container
  # 4) remover existing container
  if [ "$(check_container)" != "" ]; then
    $DOCKER rm "${CONTAINER_NAME}_orig" > /dev/null 2>&1
  fi

  # finally, lets clean up old docker images
  $DOCKER rmi $($DOCKER images -q ${IMAGE_NAME}) > /dev/null 2>&1

# no docker container found. start a new one.
else
  start_container
fi
