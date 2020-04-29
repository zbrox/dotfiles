Tmux Configuration
=====================
This is the tmux configuration I use. It is adapted (mostly small removals) from [samoshkin/tmux-config](https://github.com/samoshkin/tmux-config). So all credits to him. This readme is also a redacted version of the original.

![intro](https://user-images.githubusercontent.com/768858/33152741-ec5f1270-cfe6-11e7-9570-6d17330a83aa.gif)

Table of contents
-----------------

1. [Features](#features)
1. [Installation](#installation)
1. [General settings](#general-settings)
1. [Key bindings](#key-bindings)
1. [Status line](#status-line)
1. [Nested tmux sessions](#nested-tmux-sessions)
1. [Copy mode](#copy-mode)
1. [Clipboard integration](#clipboard-integration)
1. [Themes and customization](#themes-and-customization)

Features
---------

- support for nested tmux sessions
- local vs remote specific session configuration
- scroll and copy mode improvements
- integration with OSX or Linux clipboard (works for local, remote, and local+remote nested session scenario)
- supercharged status line
- renew tmux and shell environment (SSH_AUTH_SOCK, DISPLAY, SSH_TTY) when reattaching back to old session
- prompt to rename window right after it's created
- newly created windows and panes retain current working directory
- monitor windows for activity/silence
- highlight focused pane
- merge current session with existing one (move all windows)
- configurable visual theme/colors, with some elements borrowed from [Powerline](https://github.com/powerline/powerline)
- integration with 3rd party plugins: [tmux-sidebar](https://github.com/tmux-plugins/tmux-sidebar), [tmux-copycat](https://github.com/tmux-plugins/tmux-copycat), [tmux-open](https://github.com/tmux-plugins/tmux-open), [tmux-plugin-sysstat](https://github.com/samoshkin/tmux-plugin-sysstat)

**Status line widgets**:

- CPU, memory usage, system load average metrics
- username and hostname, current date time
- battery information in status line
- visual indicator when you press `prefix`
- visual indicator when you're in `Copy` mode
- visual indicator when pane is zoomed
- online/offline visual indicator
- toggle visibility of status line


Installation
-------------
Prerequisites:
- tmux >= "v3"
- OSX, probably Linux and FreeBSD too

The `install.sh` file is ran by my `.dotfiles` install script. It does the following:

`install.sh` script does following:
- symlinks this folder to `~/.tmux`
- symlinks tmux config file ($DOTFILES/tmux/tmux.conf) to `~/.tmux.conf` (if there's an existing .tmux.conf this will stop and complain)
- [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) will be installed at default location `~/.tmux/plugins/tpm`, unless already presemt
- required tmux plugins will be installed


General settings
----------------

- Windows and pane indexing starts from `1` rather than `0`
- Scrollback history limit is set to `20000`
- Automatic window renaming is turned off
- Aggresive resizing is on
- Message line display timeout is `1.5s`
- Mouse support in `on`

256 color palette support is turned on, make sure that your parent terminal is configured propertly. See [here](https://unix.stackexchange.com/questions/1045/getting-256-colors-to-work-in-tmux) and [there](https://github.com/tmux/tmux/wiki/FAQ)

```
# parent terminal
$ echo $TERM
xterm-256color

# jump into a tmux session
$ tmux new
$ echo $TERM
screen-256color
```

Key bindings
-----------
So `~/.tmux.conf` overrides default key bindings for many actions:

If you are an iTerm2 user check the (original tmux configuration by samoshkin)[https://github.com/samoshkin/tmux-config].

| tmux key      | Description
|---------------|--------------------------------------------------------------
| <prefix> C\-r | Reload tmux configuration from ~/\.tmux\.conf file
| <prefix> r    | Rename current window
| <prefix> R    | Rename current session
| <prefix> \_   | Split new pane horizontally
| <prefix> \|   | Split new pane vertically
| <prefix> <    | Select next pane
| <prefix> >    | Select previous pane
| <prefix> ←    | Select pane on the left
| <prefix> →    | Select pane on the right
| <prefix> ↑    | Select pane on the top
| <prefix> ↓    | Select pane on the bottom
| <prefix> C\-← | Resize pane to the left
| <prefix> C\-→ | Resize pane to the right
| <prefix> C\-↑ | Resize pane to the top
| <prefix> C\-↓ | Resize pane to the bottom
| <prefix> >    | Move to next window
| <prefix> <    | Move to previous window
| <prefix> Tab  | Switch to most recently used window
| <prefix> \\   | Swap panes back and forth with 1st pane
| <prefix> C\-o | Swap current active pane with next one
| <prefix> \+   | Toggle zoom for current pane
| <prefix> x    | Kill current pane
| <prefix> X    | Kill current window
| <prefix> C\-x | Kill other windows but current one \(with confirmation\)
| <prefix> Q    | Kill current session \(with confirmation\)
| <prefix> C\-u | Moves current session windows to another
| <prefix> d    | Detach from session
| <prefix> D    | Detach other clients except current one from session
| <prefix> C\-s | Toggle status bar visibility
| <prefix> m    | Monitor current window for activity
| <prefix> M    | Monitor current window for silence by entering silence period
| <prefix> F12  | Switch to "nested session" mode

Status line
-----------

Left part:
![status line left](https://user-images.githubusercontent.com/768858/33151594-59db6a8e-cfe1-11e7-8a36-476fe0b416b3.png)

Right part:
![status line right](https://user-images.githubusercontent.com/768858/33151608-6978de72-cfe1-11e7-829a-e303e31e8c16.png)

The left part contains only current session name.

Window tabs use Powerline arrows glyphs, so you need to install Powerline enabled font to make this work. See [Powerline docs](https://powerline.readthedocs.io/en/latest/installation.html#fonts-installation) for instructions and here is the [collection of patched fonts for powerline users](https://github.com/powerline/fonts)

The right part of status line consists of following components:

- CPU, memory usage, system load average metrics. Powered by [tmux-plugin-sysstat](https://github.com/samoshkin/tmux-plugin-sysstat) (dislaimed, that's my own development, because I haven't managed to find any good plugin with CPU and memory/swap metrics)
- username and hostname (invaluable when you SSH onto remote host)
- current date time
- battery information
- visual indicator when you press prefix key: `[^A]`.
- visual indicator when pane is zoomed: `[Z]`
- online/offline visual indicator (just pings `google.com`)

You might want to hide status bar using `<prefix> C-s` keybinding.


Nested tmux sessions
--------------------

Nested tmux sessions is usually used on a remote machine where another session of tmux is running. This mode turns off all local session keybindings and thus the remote session captures them (same <prefix> key remains, in case you modified it). To return back to the outer (local session) just press the keybinding again (<prefix> F12). Credits to [http://stahlke.org/dan/tmux-nested/](http://stahlke.org/dan/tmux-nested/) and this [Github issue](https://github.com/tmux/tmux/issues/237)

![nested sessions](https://user-images.githubusercontent.com/768858/33151636-84a0bab2-cfe1-11e7-9d5d-412525689c9b.gif)

You might notice that when key bindings are "OFF", special `[OFF]` visual indicator is shown in the status line, and status line changes its style (colored to gray).

###  Local and remote sessions

Remote session is detected by existence of `$SSH_CLIENT` variable. When session is remote, following changes are applied:
- status line is docked to bottom; so it does not stack with status line of local session
- some widgets are removed from status line: battery, date time. The idea is to economy width, so on wider screens you can open two remote tmux sessions in side-by-side panes of single window of local session.

You can apply remote-specific settings by extending `~/.tmux/.tmux.remote.conf` file.

Copy mode
----------------------
There are some tweaks to copy mode and scrolling behavior, you should be aware of.

There is a root keybinding to enter Copy mode: `M-Up`. Once in copy mode, you have several scroll controls:

- scroll by line: `M-Up`, `M-down`
- scroll by half screen: `M-PageUp`, `M-PageDown`
- scroll by whole screen: `PageUp`, `PageDown`
- scroll by mouse wheel, scroll step is changed from `5` lines to `2`

`Space` starts selection, `Enter` copies selection and exits copy mode. List all items in copy buffer using `prefix C-p`, and paste most recent item from buffer using `prexix p`.

`y` just copies selected text and is equivalent to `Enter`,  `Y` copies whole line, and `D` copies by the end of line.

Also, note, that when text is copied any trailing new lines are stripped. So, when you paste buffer in a command prompt, it will not be immediately executed.

You can also select text using the mouse. The default behavior is to copy text and immediately cancel copy mode on `MouseDragEnd` event. This is annoying, because sometimes I select text just to highlight it, but tmux drops me out of copy mode and reset scroll by the end. I've changed this behavior, so `MouseDragEnd` does not execute `copy-selection-and-cancel` action. Text is copied, but copy mode is not cancelled and selection is not cleared. You can then reset selection by mouse click.

![copy and scroll](https://user-images.githubusercontent.com/768858/33231146-e390afc8-d1f8-11e7-80ad-6977fc3a5df7.gif)

Clipboard integration
----------------------

When you copy text inside tmux, it's stored in private tmux buffer, and not shared with system clipboard. Same is true when you SSH onto remote machine, and attach to tmux session there. Copied text will be stored in remote's session buffer, and not shared/transported to your local system clipboard. And sure, if you start local tmux session, then jump into nested remote session, copied text will not land in your system clipboard either.

This is one of the major limitations of tmux, that you might just decide to give up using it. Let's explore possible solutions:

- share text with OSX clipboard using **"pbcopy"**
- share text with OSX clipboard using [reattach-to-user-namespace](https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard) wrapper to access "pbcopy" from tmux environment (seems on OSX 10.11.5 ElCapitan this is not needed, since I can still access pbcopy without this wrapper).
- share text with X selection using **"xclip"** or **"xsel"** (store text in primary and clipboard selections). Works on Linux when DISPLAY variable is set.

All solutions above are suitable for sharing tmux buffer with system clipboard for local machine scenario. They still does not address remote session scenarios. What we need is some way to transport buffer from remote machine to the clipboard on the local machine, bypassing remote system clipboard.

There are 2 workarounds to address remote scenarios.

Use **[ANSI OSC 52](https://en.wikipedia.org/wiki/ANSI_escape_code#Escape_sequences)** escape [sequence](https://blog.vucica.net/2017/07/what-are-osc-terminal-control-sequences-escape-codes.html) to talk to controlling/parent terminal and pass buffer on local machine. Terminal should properly undestand and handle OSC 52. Currently, only iTerm2 and XTerm support it. OSX Terminal, Gnome Terminal, Terminator do not.

Second workaround is really involved and consists of [local network listener and SSH remote tunneling](https://apple.stackexchange.com/a/258168):

- SSH onto target machine with remote tunneling on
    ```
    ssh -R 2222:localhost:3333  alexeys@192.168.33.100
    ```
- When text is copied inside tmux (by mouse, by keyboard by whatever configured shortcut), pipe text to network socket on remote machine
    ```
    echo "buffer" | nc localhost 2222
    ```
- Buffer will be sent thru SSH remote tunnel from port `2222` on remote machine to port `3333` on local machine.
- Setup a service on local machine (systemd service unit with socket activation), which listens on network socket on port `3333`, and pipes any input to `pbcopy` command (or `xsel`, `xclip`).

This tmux-config does its best to integrate with system clipboard, trying all solutions above in order, and falling back to OSC 52 ANSI escape sequences in case of failure. 

On OSX you might need to install `reattach-to-user-namespace` wrapper: `brew install reattach-to-user-namespace`, and make sure OSC 52 sequence handling is turned on in iTerm. (Preferences -> General -> Applications in Terminal may access clipboard).

On Linux, make sure `xclip` or `xsel` is installed. For remote scenarios, you would still need to setup network listener and use SSH remote tunneling, unless you terminal emulators supports OSC 52 sequences.





Themes and customization
------------------------

All colors related to theme are declared as variables. You can change them in `~/.tmux.conf`.

```
# This is a theme CONTRACT, you are required to define variables below
# Change values, but not remove/rename variables itself
color_dark="$color_black"
color_light="$color_white"
color_session_text="$color_blue"
color_status_text="colour245"
color_main="$color_orange"
color_secondary="$color_purple"
color_level_ok="$color_green"
color_level_warn="$color_yellow"
color_level_stress="$color_red"
color_window_off_indicator="colour088"
color_window_off_status_bg="colour238"
color_window_off_status_current_bg="colour254"
```

Note, that variables are not extracted to dedicated file, as it should be, because for some reasons, tmux does not see variable values after sourcing `theme.conf` file. Don't know why.
