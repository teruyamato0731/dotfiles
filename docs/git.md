# Git configuration and helpers

The custom Git configuration is stored in
<code>.config/git/.gitconfig.custom</code>. The installer prints the include
command after setup; run it once if the file is not already included:

~~~bash
git config --global --add include.path '~/.gitconfig.custom'
~~~

Verify the include with:

~~~bash
git config --global --get-all include.path
~~~

## Defaults

- Git uses <code>code --wait</code> as its editor.
- New branches are automatically configured to track their remote when
  pushed.
- Git's normal pager is delta with dark colors, line numbers, hyperlinks, and
  <code>n</code>/<code>N</code> navigation between diff sections.
- Merge conflicts use the <code>zdiff3</code> conflict style.

## Aliases

| Command | Action |
| --- | --- |
| <code>git aliases</code> | Print the configured aliases in a sorted list |
| <code>git b</code> | List branches without the pager |
| <code>git graph</code> | Show all branches, tags, remotes, and the commit graph |
| <code>git pp</code> | Pull with pruning |
| <code>git rpull</code> | Pull with rebase |
| <code>git ss</code> / <code>git sp</code> | Stash push including untracked files / pop |
| <code>git fixup [COMMIT]</code> | Select a recent commit with fzf and create a fixup commit |
| <code>git rb [COMMIT]</code> | Select a rebase target with fzf and start an autosquashing interactive rebase |
| <code>git fpush</code> | Push with force-with-lease |
| <code>git undo</code> | Reset HEAD to its parent with mixed reset |
| <code>git linetotal</code> | Count lines in tracked files |

The <code>git amend</code> command is provided by the
<code>bin/git-amend</code> helper. It opens a fzf list of changed files,
supports staging from the selector, and then amends the latest commit without
changing its message.

## Worktrees

<code>git wsw</code> is provided by <code>bin/git-wsw</code>. It:

1. fetches and lists remote branches with fzf;
2. ignores symbolic HEAD entries and branches containing <code>archive</code>
   or <code>wip</code>;
3. creates a sibling directory named
   <code>&lt;repository&gt;.worktrees/&lt;branch-with-slashes-replaced&gt;</code>;
4. opens the worktree in VS Code.

If the worktree already exists, the command opens it without creating a
second copy. The helper expects GitHub-style <code>origin</code> remotes,
<code>fd</code>, fzf, and the <code>code</code> command.

## lazygit and delta

The <code>lg</code> alias starts lazygit. Its UI-specific settings and pager
choices are described in the [lazygit guide](lazygit.md). Terminal
<code>git diff</code> continues to use delta directly.
