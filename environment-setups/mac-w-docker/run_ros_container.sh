#!/bin/bash

# Allow local XQuartz connections
xhost - 127.0.0.1
xhost + 127.0.0.1

# -e QT_DEBUG_PLUGINS=1: required for resolving "Could not lod the Qt platform plugin"
docker run -it --rm \
    -e DISPLAY=host.docker.internal:0 \
    -e QT_DEBUG_PLUGINS=1 \
    --platform=linux/amd64 \
    --name ros_humble_exp \
    --user root --network=host \
    --ipc=host \
    ros2-humble:dev