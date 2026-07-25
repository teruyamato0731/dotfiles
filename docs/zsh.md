# zsh configuration

The zsh configuration is split into small files under
<code>.config/zsh</code>. mise links the directory to
<code>~/.config/zsh</code> and links the repository's
<code>.config/zsh/.zshenv</code> to <code>~/.zshenv</code>.

## Startup order

| File | Responsibility |
| --- | --- |
| <code>~/.zshenv</code> | Sets <code>ZDOTDIR</code> to the XDG zsh directory and disables Ubuntu's global compinit |
| <code>~/.config/zsh/.zprofile</code> | Adds <code>~/.local/bin</code> and activates mise for login shells |
| <code>~/.config/zsh/.zshrc</code> | Sources every matching file under <code>zshrc.d</code> in lexical order |

The split keeps the zsh environment source of truth in one place while
allowing interactive concerns to be changed independently.

## Interactive modules

| File | Configuration |
| --- | --- |
| <code>10-history.zsh</code> | Stores history under XDG state, shares history, ignores duplicate entries, and keeps 10,000 entries |
| <code>20-completion.zsh</code> | Loads mise-generated completions, compinit, case-flexible matching, and fzf-tab previews |
| <code>30-zle.zsh</code> | Sets emacs-style editing, history search arrows, word movement, and word deletion |
| <code>40-environment.zsh</code> | Adds <code>~/.local/bin</code> and activates mise |
| <code>50-integrations.zsh</code> | Loads fzf, fzf-tab, and the shared shell functions |
| <code>60-keybindings.zsh</code> | Adds the repository's directory and worktree widgets |
| <code>80-prompt.zsh</code> | Starts Starship when it is installed |
| <code>90-plugins.zsh</code> | Loads autosuggestions first and syntax highlighting last |

The plugin repositories and revisions are pinned in
<code>.config/mise/config.toml</code>; they are bootstrapped automatically.

## Keybindings

| Key | Action |
| --- | --- |
| <code>Ctrl-O</code> | Run the <code>gcd</code> repository selector |
| <code>Ctrl-]</code> | Run <code>git wsw</code> |
| <code>Ctrl-X Ctrl-Y</code> | Launch Yazi and apply its final directory |
| <code>Ctrl-W</code> | Delete the previous word |
| <code>Alt-D</code> | Delete the next word |
| <code>Ctrl-Left</code> / <code>Ctrl-Right</code> | Move one word backward or forward |

After a ZLE widget returns, the prompt is reset so that output from the
interactive command does not corrupt the current prompt.

## Completion and history

Completion files generated during bootstrap are stored under
<code>~/.local/share/zsh/site-functions</code>. The completion menu supports
case-flexible matching and separator-aware matching for names containing
dots, underscores, and hyphens.

fzf-tab previews files with bat, directories with eza, and exported variables
with their current values. Press <code>[</code> or <code>]</code> to switch
completion groups.

History is stored under <code>~/.local/state/zsh/history</code> by default.
If <code>XDG_STATE_HOME</code> is set, zsh uses that directory instead.

If the completion cache becomes stale, close the shell and remove the
generated file at <code>~/.cache/zsh/zcompdump</code> by default before
starting zsh again. If <code>XDG_CACHE_HOME</code> is set, the cache follows
that directory instead.
