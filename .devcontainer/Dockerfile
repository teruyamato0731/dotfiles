FROM ubuntu:24.04

# Dependency for dotfiles installation
RUN apt-get update && apt-get install -y \
  sudo \
  git \
  # For devcontainer
  curl \
  gnupg \
  && rm -rf /var/lib/apt/lists/*

# Grant sudo privileges to the existing 'ubuntu' user
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu

# Set the default user to 'ubuntu'
USER ubuntu
WORKDIR /home/ubuntu

CMD [ "/bin/bash" ]
