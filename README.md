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

### Work in Docker containers from WezTerm

The WezTerm configuration discovers all running Docker containers and creates
an [ExecDomain](https://wezterm.org/config/lua/ExecDomain.html) for each one.
Dev Containers are included as normal Docker containers.

WezTerm starts in the host shell by default. To open a shell in a container,
press `Ctrl+Shift+D` and select its **Docker** domain. This refreshes the domain
list first, so containers started after WezTerm are included. The existing
new-tab and pane-split shortcuts then continue to open shells in that container:

- `Ctrl+Shift+T` — new tab
- `Alt+Enter` — horizontal split
- `Alt+Shift+Enter` — vertical split

When multiple containers are running, select the desired domain first.
Subsequent tabs and splits inherit that domain. The default shell is `/bin/sh`;
change `default_prog` in `wezterm.lua` if needed. Docker must be available to
the user running WezTerm. This is a plain `docker exec` shell and does not
replicate Dev Container-specific user or workspace settings.

<details><summary>Apply to all Dev Containers</summary>

To have these dotfiles applied automatically inside every VS Code Dev Container you open, add the following to your VS Code user settings (Open Settings → Open Settings (JSON)):

```json
{
    "dotfiles.repository": "https://github.com/teruyamato0731/dotfiles.git",
    "dotfiles.installCommand": "./install.sh",
    "dotfiles.targetPath": "~/dotfiles"
},
```

</details>

## Features

### CLI Tools and Utilities

This dotfiles repository automatically installs the following useful CLI tools and utilities:

#### Basic Tools

- **bash-completion** - Enhanced Bash completion functionality
- **git** - Version control system
- **curl** - Data transfer tool
- **unzip** - Archive extraction tool
- **tree** - Directory structure visualization
- **htop** - Interactive process viewer
- **jq** - JSON processor
- **mise** - Development tool and runtime manager

#### Enhanced Alternative Tools

- **bat** - Syntax-highlighted `cat` alternative
- **ripgrep** - Fast `grep` alternative
- **fd** - Fast `find` alternative
- **btm** - Resource monitor
- **gh** - GitHub CLI
- **yazi** - Terminal file manager

#### Development Support Tools

- **ghq** (v1.10.1) - Git repository unified management tool
- **fzf** - Fast fuzzy finder

### Custom Configurations and Aliases

#### Bash Configuration (`.bashrc.custom`)

- **Enhanced Prompt**: PS1 with Git branch and status display
- **Useful Aliases**:
    - `ls` → Enable color display
    - `grep` → Enable color display
    - `ll` → `ls -alF`
    - `cat` → `bat --paging=never`

#### Advanced fzf Integration

- **Environment Variables**: Search with preview functionality
- **Shell Functions** (`.config/shell/functions.sh`):
    - `gcd()` - Select a ghq repository with fzf and cd
    - `y()` - Launch yazi and apply its final cwd to the shell
- **Interactive Commands** (`bin/`):
    - `gsw` - Select a Git branch with fzf and switch
    - `gg` - Search GitHub repositories with fzf and execute `ghq get`
    - `bathelp` - Preview help with bat
    - `batdiff` - Display Git diff with bat
    - `rgf` - Search files with ripgrep, fzf, bat, and VS Code
    - `git wsw` - Select a Git worktree with fzf and open in VS Code
- **Key Bindings**:
    - `Ctrl+O` - Execute gcd function
    - `Ctrl+]` - Execute `git wsw`

#### Git Configuration (`.gitconfig.custom`)

- **Editor**: VS Code (`code --wait`)
- **Useful Aliases**:
    - `aliases` - Display configured aliases list
    - `amend` - Modify the latest commit
    - `graph` - Graphical log display
    - `fixup` - Select commit with fzf for fixup
    - `ss` / `sp` - stash push/pop
    - `undo` - Undo the latest commit

## After Installation

```bash
gh auth login -p ssh --web
gh auth setup-git
gh extension install nektos/gh-act
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global --add include.path '~/.gitconfig.custom'
```
