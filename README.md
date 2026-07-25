<div align="center">

# dotfiles

***My dotfiles for Ubuntu 24.04 LTS.***

[![Open in Dev Containers](https://img.shields.io/static/v1?label=Dev%20Containers&message=Open&color=blue&logo=visualstudiocode)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/teruyamato0731/dotfiles)
[![Ubuntu 24.04](https://img.shields.io/badge/Ubuntu%2024.04-orange?logo=ubuntu&logoColor=white
)](https://releases.ubuntu.com/noble/)
[![license](https://img.shields.io/github/license/teruyamato0731/dotfiles)](https://github.com/teruyamato0731/dotfiles/blob/main/LICENSE)
[![CI](https://github.com/teruyamato0731/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/teruyamato0731/dotfiles/actions/workflows/ci.yml)

</div>

## Installation

<details><summary>Prerequisites</summary>

- `bash`
- `sudo`
- `apt-get`
- `git` or `wget` or `curl`

```bash
sudo apt-get update
sudo apt-get install -y git
```

</details>

Clone this repository and run the installation script:

```bash
git clone https://github.com/teruyamato0731/dotfiles.git ~/dotfiles
~/dotfiles/install.sh host
```

Or use curl:

```bash
curl -fsSL https://raw.githubusercontent.com/teruyamato0731/dotfiles/main/install.sh | bash -s -- host
```

Or use wget:

```bash
wget -qO- https://raw.githubusercontent.com/teruyamato0731/dotfiles/main/install.sh | bash -s -- host
```

<details><summary>Profiles</summary>

The installation profile defaults to `dev`, which installs the CLI-focused development environment. Use the `host` profile on a physical Ubuntu host to also install fonts and `tio`:

```bash
~/dotfiles/install.sh dev
~/dotfiles/install.sh host
```

When piping the script to Bash, pass the profile after `bash -s --`, for example:

```bash
curl -fsSL https://raw.githubusercontent.com/teruyamato0731/dotfiles/main/install.sh | bash -s -- dev
wget -qO- https://raw.githubusercontent.com/teruyamato0731/dotfiles/main/install.sh | bash -s -- host
```

</details>

## Try on Docker

You can try these dotfiles in a Docker container without installing them on your host system:

```bash
docker run --rm -it ghcr.io/teruyamato0731/dotfiles:latest bash
```

## Try on Dev Containers

To use Dev Containers, first install the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension for VS Code by running the command:

```bash
code --install-extension ms-vscode-remote.remote-containers
```

Then, open the command palette (Ctrl+Shift+P) and select **Dev Containers: Open Workspace in Container...**.

```bash
git clone https://github.com/teruyamato0731/dotfiles.git ~/dotfiles
code ~/dotfiles
```

<details><summary>Apply to all Dev Containers</summary>

To have these dotfiles applied automatically inside every VS Code Dev
Container you open, add the following to your VS Code user settings (Open
Settings → Open Settings (JSON)):

~~~json
{
    "dotfiles.repository": "https://github.com/teruyamato0731/dotfiles.git",
    "dotfiles.installCommand": "./install.sh",
    "dotfiles.targetPath": "~/dotfiles"
},
~~~

</details>

### WezTerm and Docker

The Docker tab, pane, and container-selection workflow is documented in
[WezTerm and Docker integration](docs/wezterm.md).

## Features

The installer configures a shared CLI-focused environment with mise and
shell integrations for Bash and zsh. Detailed usage is organized by
workflow:

- [CLI tools and common workflows](docs/tools.md)
- [Bash, zsh, and fzf](docs/shell.md)
- [Git configuration and helpers](docs/git.md)
- [WezTerm and Docker integration](docs/wezterm.md)
- [Yazi](docs/yazi.md)
- [lazygit](docs/lazygit.md)
- [zsh configuration details](docs/zsh.md)

See the [documentation index](docs/README.md) for the complete guide list.

## After Installation

```bash
gh auth login -p ssh --web
gh auth setup-git
gh extension install nektos/gh-act
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global --add include.path '~/.gitconfig.custom'
```
