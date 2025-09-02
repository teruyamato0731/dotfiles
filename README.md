<div align="center">

# dotfiles

***My dotfiles for Ubuntu 24.04 LTS.***

[![Open in Dev Containers](https://img.shields.io/static/v1?label=Dev%20Containers&message=Open&color=blue&logo=visualstudiocode)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/teruyamato0731/dotfiles)
[![Ubuntu 24.04](https://img.shields.io/badge/Ubuntu%2024.04-orange?logo=ubuntu&logoColor=white
)](https://releases.ubuntu.com/noble/)
[![license](https://img.shields.io/github/license/teruyamato0731/dotfiles)](https://github.com/teruyamato0731/dotfiles/blob/main/LICENSE)
[![CI](https://github.com/teruyamato0731/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/teruyamato0731/dotfiles/actions/workflows/ci.yml)

</div>

## Prerequisites

- apt-get
- git
- sudo
- bash

## Install your PC

Run the following commands:

```bash
git clone https://github.com/teruyamato0731/dotfiles.git ~/dotfiles
bash ~/dotfiles/install.sh
```

Or run the following one-liner command:

```bash
DOTFILES_DIR="$HOME/dotfiles" bash <(curl -fsSL https://raw.githubusercontent.com/teruyamato0731/dotfiles/main/install.sh)
```

## Try with Dev Containers

To use Dev Containers, first install the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension for VS Code.

Then, open the command palette (Ctrl+Shift+P) and select **Dev Containers: Open Workspace in Container...**.

```bash
git clone https://github.com/teruyamato0731/dotfiles.git ~/dotfiles
code --install-extension ms-vscode-remote.remote-containers
code ~/dotfiles
```

## Try on Docker Container

You can try it on a Docker container as follows:

```bash
docker run --rm -it ubuntu:24.04 bash
apt-get update && apt-get install -y curl
DOTFILES_DIR="$HOME/dotfiles" bash <(curl -fsSL https://raw.githubusercontent.com/teruyamato0731/dotfiles/main/install.sh)
```
