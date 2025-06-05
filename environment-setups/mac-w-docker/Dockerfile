FROM osrf/ros:humble-desktop-full

# Install additional packages
RUN apt-get update && apt-get install -y \
  nano \
  vim \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Fixes for running GUI applications like rviz2
# resolve GPG error: signatures were invalid
RUN rm -f /etc/apt/sources.list.d/ros2.list && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros2-latest-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/ros2-latest-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu jammy main" > /etc/apt/sources.list.d/ros2.list
# to fix libGL error: failed to load driver: swrast when running rviz2
RUN apt-get update && apt-get install -y \
  libgl1-mesa-glx \ 
  libgl1-mesa-dri \
  # for debugging and development
  x11-apps \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy configuration files
COPY config/ /site_config/

# Create a non-root user
ARG USERNAME=ros
ARG USER_UID=501
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
  && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
  && mkdir /home/$USERNAME/.config && chown $USER_UID:$USER_GID /home/$USERNAME/.config

# Set up sudo privileges for the new user
RUN apt-get update \
  && apt-get install -y sudo \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
  && chmod 0440 /etc/sudoers.d/$USERNAME \
  && rm -rf /var/lib/apt/lists/*

# Copy the entrypoint and bashrc scripts so we have 
# our container's environment set up correctly  
COPY entrypoint.sh /entrypoint.sh
COPY bashrc /home/${USERNAME}/.bashrc

# Set up entrypoint and default command
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
CMD ["bash"]