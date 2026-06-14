# tmux Cheatsheet

Quick reference for this tmux configuration. Configuration: [dot_tmux.conf.tmpl](https://github.com/DevOpsMaestro/dotfiles/blob/main/dot_tmux.conf.tmpl)

The prefix key for all tmux commands is **`Ctrl+Space`**. Windows and panes are numbered from **1**. Mouse support is enabled: click to select, drag to resize, and scroll to navigate the buffer.

---

## Prefix and Plugins

| Key | Action |
|---|---|
| `Ctrl+Space` | Prefix (command key) |
| `Prefix + I` | Install or reload plugins (TPM) |
| `Prefix + r` | Reload the tmux configuration |

---

## Sessions

| Key or Command | Action |
|---|---|
| `Prefix + d` | Detach from the current session |
| `Prefix + Ctrl+s` | Save the session (tmux-resurrect) |
| `Prefix + Ctrl+r` | Restore a saved session (tmux-resurrect) |
| `tmux new -s <name>` | Create a new named session |
| `tmux ls` | List all active sessions |
| `tmux attach -t <name>` | Attach to a session by name |
| `tmux kill-session -t <name>` | Terminate a session by name |
| `tmux a` | Attach to the most recently used session |

Sessions are saved automatically every 15 minutes by tmux-continuum and restored when the tmux server starts.

---

## Windows

| Key | Action |
|---|---|
| `Prefix + c` | Create a new window |
| `Prefix + n` | Move to the next window |
| `Prefix + l` | Return to the previously used window |
| `Prefix + w` | Open the window preview and selection menu |
| `Prefix + <` | Swap the current window one position to the left |
| `Prefix + >` | Swap the current window one position to the right |

---

## Panes

| Key | Action |
|---|---|
| `Prefix + \|` | Split the current pane vertically |
| `Prefix + -` | Split the current pane horizontally |
| `Prefix + m` | Select the previously active pane |
| `Prefix + k` | Resize the current pane upward by 10 rows |
| `Prefix + j` | Resize the current pane downward by 10 rows |

---

## Synchronized Panes

Synchronized panes broadcast keystrokes to all panes at once. This is useful for running the same command across multiple SSH sessions simultaneously.

| Key | Action |
|---|---|
| `F3` | Enable synchronized panes (no prefix required) |
| `F4` | Disable synchronized panes (no prefix required) |
| `Prefix + F3` | Toggle synchronized panes |

---

## Search

| Key | Action |
|---|---|
| `Prefix + /` | Search the scrollback buffer |
| `Prefix + Ctrl+f` | FZF fuzzy search across sessions, windows, panes, and commands |

---

## Copy Mode (Vi-Style)

| Key | Action |
|---|---|
| `Prefix + [` | Enter copy mode |
| `v` | Begin text selection |
| `y` | Copy the selection to the clipboard |
| `Prefix + ]` | Paste from the buffer |
