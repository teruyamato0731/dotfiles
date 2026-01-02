FROM ubuntu:24.04 AS dev

RUN rm -f /etc/apt/apt.conf.d/docker-clean

# Dependency for dotfiles installation
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get update && apt-get install -y \
  sudo \
  git \
  # For devcontainer
  language-pack-ja \
  curl \
  gnupg

ENV LANG=ja_JP.UTF-8

# Grant sudo privileges to the existing 'ubuntu' user
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu

# Set the default user to 'ubuntu'
USER ubuntu
WORKDIR /home/ubuntu

CMD [ "/bin/bash" ]

FROM dev AS preview

COPY --chown=ubuntu:ubuntu . /home/ubuntu/dotfiles
WORKDIR /home/ubuntu/dotfiles

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  ./install.sh

CMD [ "/bin/bash" ]
