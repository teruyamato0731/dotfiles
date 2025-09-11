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
- `git` or `curl`

</details>

Clone the repo and run the installer:

```bash
git clone https://github.com/teruyamato0731/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

Or use the one-liner:

```bash
DOTFILES_DIR="$HOME/dotfiles" bash <(curl -fsSL https://raw.githubusercontent.com/teruyamato0731/dotfiles/main/install.sh)
```

## Try with Dev Containers

To use Dev Containers, first install the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension for VS Code by running the command:

```bash
code --install-extension ms-vscode-remote.remote-containers
```

Then, open the command palette (Ctrl+Shift+P) and select **Dev Containers: Open Workspace in Container...**.

```bash
git clone https://github.com/teruyamato0731/dotfiles.git ~/dotfiles
code ~/dotfiles
```

<details><summary>Try on Docker Container</summary>

You can try it on a Docker container as follows:

```bash
docker run --rm -it ubuntu:24.04 bash
apt-get update && apt-get install -y curl
DOTFILES_DIR="$HOME/dotfiles" bash <(curl -fsSL https://raw.githubusercontent.com/teruyamato0731/dotfiles/main/install.sh)
```

</details>

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

#### Enhanced Alternative Tools
- **bat** - Syntax-highlighted `cat` alternative (creates `batcat` → `bat` symlink)
- **ripgrep** - Fast `grep` alternative
- **fd-find** - Fast `find` alternative (creates `fdfind` → `fd` symlink)
- **gh** - GitHub CLI

#### Development Support Tools
- **ghq** (v1.8.0) - Git repository unified management tool
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
- **Custom Functions**:
  - `gcd()` - Select ghq repository with fzf and cd
  - `gsw()` - Select Git branch with fzf and switch  
  - `batdiff()` - Display Git diff with bat
- **Key Bindings**:
  - `Ctrl+O` - Execute gcd function
  - `Ctrl+_` - Execute gsw function

#### Git Configuration (`.gitconfig.custom`)
- **Editor**: VS Code (`code --wait`)
- **Useful Aliases**:
  - `aliases` - Display configured aliases list
  - `amend` - Modify the latest commit
  - `graph` - Graphical log display
  - `fixup` - Select commit with fzf for fixup
  - `ss` / `sp` - stash push/pop
  - `undo` - Undo the latest commit
- **Commit Template**: Conventional Commits format
