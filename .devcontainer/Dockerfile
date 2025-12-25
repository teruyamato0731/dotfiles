FROM ubuntu:24.04

RUN rm -f /etc/apt/apt.conf.d/docker-clean

# Dependency for dotfiles installation
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get update && apt-get install -y \
  sudo \
  git \
  # For devcontainer
  curl \
  gnupg

# Grant sudo privileges to the existing 'ubuntu' user
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu

# Set the default user to 'ubuntu'
USER ubuntu
WORKDIR /home/ubuntu

CMD [ "/bin/bash" ]
