# WezTerm and Docker integration

WezTerm is installed by the <code>host</code> profile. Use that profile on a
physical Ubuntu host:

~~~bash
~/dotfiles/install.sh host
~~~

The <code>dev</code> profile installs the shared CLI environment but does not
install the host-only WezTerm package or fonts. The configuration lives in
<code>.config/wezterm</code> and is linked to
<code>~/.config/wezterm</code>.

## Window defaults

- New windows start at 150 columns by 40 rows and are maximized at startup.
- The configured font is Moralerspace Neon HW at size 12 with a 1.1 line
  height.
- The color scheme is Humanoid dark (base16).
- Scrollback is 100,000 lines, the scroll bar is enabled, and audible bells
  are disabled.
- Kitty keyboard protocol support is enabled.

## Keybindings

| Key | Action |
| --- | --- |
| <code>Ctrl-Shift-D</code> | Select a running Docker container with a fuzzy selector |
| <code>Ctrl-Shift-T</code> | Open a new tab; container tabs stay in the same container |
| <code>Ctrl-Shift-G</code> | Open lazygit in the current container, or locally outside a container |
| <code>Ctrl-Shift-W</code> | Close the current pane without confirmation |
| <code>Alt-Enter</code> | Split the current pane using the configured horizontal action |
| <code>Alt-Shift-Enter</code> | Split the current pane using the configured vertical action |
| <code>Alt-H/J/K/L</code> | Move to the left, down, up, or right pane |
| <code>Ctrl-Shift-Arrow</code> | Resize the current pane |
| <code>Alt-1</code> ... <code>Alt-9</code> | Select a tab |
| <code>Ctrl-Backspace</code> | Delete the previous word |
| <code>Ctrl-Delete</code> | Delete the next word |

## Docker tabs and panes

<code>Ctrl-Shift-D</code> lists only running containers. For a Dev Container,
the selector displays its workspace name and uses Dev Container metadata to
determine the working directory and remote user. For a Compose service, it
displays the Compose project and service; for other containers, it displays
the container name and image. The working directory is used when opening the
shell but is not included in the selector label.

After selecting a container:

1. a new tab starts a login shell in the detected working directory;
2. the selected container identity is stored in the tab's pane;
3. new tabs and splits created from that pane execute in the same container;
4. <code>Ctrl-Shift-G</code> runs <code>exec lazygit</code> in that container.

The Docker command passes <code>TERM=xterm-256color</code>,
<code>COLORTERM=truecolor</code>, and <code>TERM_PROGRAM=WezTerm</code> so
terminal applications retain their color and keyboard behavior. If the
current pane is not associated with a Docker container, the tab and split
bindings use the normal local WezTerm domain.

The host user must be able to run Docker commands. A stopped container is
removed from the selector; start it before using <code>Ctrl-Shift-D</code>.
