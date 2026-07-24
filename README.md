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

### WezTerm Docker

`Ctrl+Shift+D` で起動中の Docker / Dev Container を選択できます。
選択したコンテナは、新しいタブとペイン分割にも引き継がれます。

- `Ctrl+Shift+T` — 新しいタブ
- `Alt+Enter` / `Alt+Shift+Enter` — ペイン分割

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
- **Zsh Completion**: [fzf-tab](https://github.com/Aloxaf/fzf-tab) replaces the
  standard completion selection menu while retaining Zsh compsys and fzf's
  `Ctrl+R`, `Ctrl+T`, and `Alt+C` bindings.
    - mise bootstraps fzf-tab v1.3.0 at
      `d7e0234614dbe5369fdd760907d12c0e05a4dccc`.
    - Its explicit `--height=70%`, reverse layout, and border match the
      standard fzf geometry without inheriting all `FZF_DEFAULT_OPTS`.
    - `Tab`/`Shift+Tab` move through candidates, `Ctrl+Space` toggles
      multi-selection, `[`/`]` switch completion groups, and `/` continues
      directory completion.
    - `cd` previews use `eza --tree --level=2 --icons`; `cat`/`bat` file
      candidates use the same `bat` preview as fzf's `**<Tab>` completion.
      `export`/`unset` preview the focused variable's value.
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
