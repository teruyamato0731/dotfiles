# Yazi

Yazi is installed through mise and configured in
<code>.config/yazi</code>. Start it directly with <code>yazi</code>, or use
the shell wrapper:

~~~bash
y
~~~

The <code>y</code> function passes through its arguments, writes the final
working directory to a temporary file, and changes the current shell to that
directory after Yazi exits. Starting <code>yazi</code> directly does not
change the parent shell's directory.

## Display and preview

The repository configuration:

- shows hidden files;
- sorts naturally, with directories first;
- displays file sizes in the line mode;
- uses the preview ratio <code>[1, 4, 3]</code>;
- allows previews up to 1000 pixels in width and height;
- uses two-space tabs in previews;
- uses the Monokai Extended syntax theme;
- opens files with the <code>EDITOR</code> environment variable.

The header shows the current user and, when inside a Git repository, the
current branch or short commit. The status line shows the owner and group of
the hovered entry.

## Custom keybindings

| Key | Action |
| --- | --- |
| <code>Enter</code> | Enter a directory or open the hovered file |
| <code>Right</code> | Enter a directory, or focus the file preview |
| <code>Left</code> | Leave preview focus, or leave the current directory |
| <code>Esc</code> | Clear Yazi's current state |
| <code>Ctrl-Q</code> | Quit without creating a cwd file |
| <code>Ctrl-O</code> | Open the hovered item in VS Code |
| <code>1</code> ... <code>5</code> | Switch to, or create, tabs 1 through 5 |
| <code>g h</code> | Go to the home directory |
| <code>g q</code> | Go to <code>~/ghq/github.com</code> |
| <code>g r</code> | Go to the root of the current Git repository |

The right-arrow preview action changes the ratio to emphasize the preview
pane. The left-arrow action restores the normal ratio before leaving the
directory.

## Plugins

The local plugins provide the behavior used by the keybindings:

- <code>smart-enter</code> chooses enter or open based on the hovered entry.
- <code>focused-preview</code> toggles the focused preview ratio.
- <code>smart-switch</code> creates missing tabs at the current directory
  before switching to the requested tab.
- <code>git-root</code> resolves the repository root with Git and warns when
  the current directory is not inside a repository.
