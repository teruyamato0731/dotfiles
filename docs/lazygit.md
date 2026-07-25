# lazygit

Start lazygit with either command:

~~~bash
lazygit
lg
~~~

The <code>lg</code> alias is defined by mise and is available in Bash and
zsh. No lazygit keybindings are replaced by this repository, so the standard
in-app help remains available with <code>?</code>.

## UI settings

The configuration in <code>.config/lazygit/config.yml</code>:

| Setting | Effect |
| --- | --- |
| <code>language: ja</code> | Uses Japanese UI text |
| <code>nerdFontsVersion: 3</code> | Uses Nerd Font v3 glyph mappings |
| <code>showNumstatInFilesView: true</code> | Shows added and removed line counts in the files view |
| <code>showDivergenceFromBaseBranch: arrowAndNumber</code> | Shows both direction and count of branch divergence |
| <code>showWholeGraph: true</code> | Keeps the complete commit graph in the log |

## Git pagers

Two custom pagers are configured:

| Mode | Command |
| --- | --- |
| Normal | <code>delta --dark --paging=never</code> |
| Side-by-side | <code>delta --dark --paging=never --side-by-side</code> |

Both modes use dark colors and let lazygit own the paging lifecycle. Select
the pager using lazygit's pager action; the available action and key are
shown in the in-app key hints for the installed version.

The delta binary is managed by mise. If a pager fails, verify it with
<code>mise which delta</code> and check that the custom Git configuration is
included as described in the [Git guide](git.md).
