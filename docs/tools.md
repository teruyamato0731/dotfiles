# CLI tools and common workflows

The installer provides a small Ubuntu base system and uses mise for the
versioned command-line tools. The shared tool list is defined in
<code>.config/mise/config.toml</code>, so both the <code>dev</code> and
<code>host</code> profiles receive the same development tools. The
<code>host</code> profile adds physical-host components such as fonts, tio,
and WezTerm.

## Tool groups

The main groups installed by this repository are:

| Group | Tools |
| --- | --- |
| Ubuntu packages | bash-completion, zsh, git, curl, gpg, file, unzip, 7zip, tree, htop, jq, build-essential, cmake, libgtest-dev, and ccache |
| File and text tools | eza, bat, ripgrep (<code>rg</code>), fd, bottom (<code>btm</code>), and jq |
| GitHub and repository tools | GitHub CLI (<code>gh</code>), ghq, delta, lazygit, act, and fzf |
| Development tools | mise, uv, edit, and Starship |
| Terminal file management | Yazi |

Versions are pinned in the mise configuration. Use <code>mise ls</code> to
inspect the active versions and <code>mise which COMMAND</code> to locate the
binary selected by mise.

## Shell aliases

The shared aliases are available in Bash and zsh:

| Alias | Expansion | Use |
| --- | --- | --- |
| <code>ls</code> | <code>eza --group-directories-first --icons</code> | Colored directory listing |
| <code>ll</code> | <code>ls -l --git</code> | Long listing with Git status |
| <code>la</code> | <code>ls -la --git</code> | Long listing including hidden files |
| <code>lt</code> | <code>ls -l --tree --git</code> | Tree listing with Git status |
| <code>grep</code> | <code>grep --color=auto</code> | Colored grep output |
| <code>cat</code> | <code>bat --paging=never</code> | Syntax-highlighted file output without a pager |
| <code>lg</code> | <code>lazygit</code> | Start lazygit |

The default editor environment is <code>edit</code>. Git itself is configured
to use <code>code --wait</code>; see the [Git guide](git.md) for the
distinction.

## Repository and search workflows

The following commands and shell functions are available after shell setup.

### Shell functions

The functions <code>gcd</code> and <code>y</code> are defined in
<code>.config/shell/functions.sh</code> and sourced by Bash and zsh:

| Command | Usage |
| --- | --- |
| <code>gcd [QUERY]</code> | Select a ghq repository with fzf and change to it. Press <code>Ctrl-O</code> in the selector to open the repository in VS Code. |
| <code>y [ARGS...]</code> | Start Yazi and apply its final directory to the current shell; see the [Yazi guide](yazi.md). |

### Commands under <code>~/dotfiles/bin</code>

These commands are available through the mise-managed PATH:

| Command | Usage |
| --- | --- |
| <code>gg [QUERY]</code> | Search the authenticated user's GitHub repositories and clone the selected repository with ghq. Run <code>gh auth login</code> first. |
| <code>gsw [QUERY]</code> | Select a local or remote branch and switch to it. Press <code>Ctrl-Q</code> to create a new branch from the current query. |
| <code>git wsw [QUERY]</code> | Select a remote branch, create a sibling worktree, and open it in VS Code. Existing worktrees are reused. |
| <code>rgf [QUERY...]</code> | Interactively search files with ripgrep and fzf, preview the selected line with bat, and press <code>Ctrl-O</code> to open it in VS Code. |
| <code>bathelp COMMAND [ARG...]</code> | Render a command's help output with bat. |
| <code>batdiff</code> | Show the current Git diff through bat. |
| <code>cab USERNAME</code> | Generate a GitHub Co-Authored-By trailer for a user. |

The fzf selectors use a reverse layout and previews by default. The
keybindings shared with the shell are documented in
[Bash, zsh, and fzf](shell.md).

## Standalone tools

The remaining tools keep their upstream command-line interfaces:

- Use <code>gh</code> for GitHub operations and authentication.
- Use <code>ghq list</code> and <code>ghq get</code> for repository management.
- Use <code>btm</code> for an interactive resource monitor.
- Use <code>uv</code> for Python environments and package execution.
- Use <code>act</code> to run GitHub Actions locally when Docker access is
  available.
- Use <code>yazi</code> or the <code>y</code> wrapper for terminal file
  management.

The more specialized configuration is documented separately:
[Git](git.md), [lazygit](lazygit.md), [Yazi](yazi.md), and
[WezTerm](wezterm.md).
