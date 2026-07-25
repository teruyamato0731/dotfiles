# Bash, zsh, and fzf

The repository shares interactive helpers between Bash and zsh. mise manages
the symlinks and adds <code>~/dotfiles/bin</code> to PATH.

## Bash

The installer links <code>~/.bashrc.custom</code> to
<code>.config/bash/.bashrc.custom</code>. The file:

- activates mise;
- configures a prompt with the shortened ghq path and Git branch/status;
- loads fzf's Bash integration and fd-based completion;
- loads the shared functions from <code>.config/shell/functions.sh</code>;
- installs the custom widgets listed below.

### Bash keybindings

| Key | Action |
| --- | --- |
| <code>Ctrl-O</code> | Run <code>gcd</code> to select a ghq repository |
| <code>Ctrl-]</code> | Run <code>git wsw</code> to select a worktree |
| <code>Ctrl-X Ctrl-Y</code> | Run <code>y</code> and follow Yazi's final directory |

These widgets are Bash's <code>bind -x</code> bindings, so they can change the
current shell directory. The same actions are exposed as zsh ZLE widgets.

## Shared functions

The functions in <code>.config/shell/functions.sh</code> are sourced by both
shells:

- <code>gcd</code> previews repository READMEs with bat and directory trees
  with eza.
- <code>y</code> creates a temporary cwd file, launches Yazi, and changes the
  current shell directory when Yazi exits in a different directory.
- On WSL, <code>BROWSER</code> points to the Windows browser and
  <code>open</code> delegates to <code>explorer.exe</code>.

Use <code>exec bash</code> or <code>exec zsh</code> after changing a shell
configuration file to start a fresh interactive shell.

## fzf integration

fzf uses fd for candidate generation and bat/eza for previews:

| Variable | Value or purpose |
| --- | --- |
| <code>FZF_DEFAULT_COMMAND</code> | Files from fd, including hidden files except <code>.git</code> |
| <code>FZF_CTRL_T_COMMAND</code> | Files from fd, including hidden files except <code>.git</code> |
| <code>FZF_ALT_C_COMMAND</code> | Directories from fd, including hidden directories except <code>.git</code> |
| <code>FZF_DEFAULT_OPTS</code> | 70% height, reverse layout, and a border |
| <code>FZF_CTRL_T_OPTS</code> | Preview files with bat or directories with eza |
| <code>FZF_ALT_C_OPTS</code> | Preview directory trees with eza |

In zsh, fzf-tab supplies completion menus with the same reverse layout and
previews for files, directories, <code>cat</code>/<code>bat</code>,
<code>export</code>, and <code>unset</code>. Completion matching is
case-flexible and treats separators such as dots, underscores, and hyphens
helpfully.

For the individual interactive commands, see
[CLI tools and common workflows](tools.md).
