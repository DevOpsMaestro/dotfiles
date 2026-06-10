# TMUX Cheatsheet

> Quick reference for this tmux configuration. Config: [dot_tmux.conf.tmpl](https://github.com/DevOpsMaestro/dotfiles/blob/main/dot_tmux.conf.tmpl)
>
> **Prefix** = `CTRL+Space` — Windows and panes are numbered from **1**. Mouse support is enabled (click to select, drag to resize, scroll to scroll).

## Prefix & Plugins

| Key | Action |
| ---: | :--- |
| **CTRL+Space** | Prefix (command key) |
| Prefix, **I** | Install / reload plugins (TPM) |
| Prefix, **r** | Reload tmux config |

## Windows

| Key | Action |
| ---: | :--- |
| Prefix, **c** | Create new window (prompts for name) |
| Prefix, **n** | Next window |
| Prefix, **l** | Last (previously used) window |
| Prefix, **w** | Window preview and selection |
| Prefix, **<** | Swap window left |
| Prefix, **>** | Swap window right |

## Panes

| Key | Action |
| ---: | :--- |
| Prefix, **\|** | Split into vertical pane |
| Prefix, **-** | Split into horizontal pane |
| Prefix, **m** | Select previous pane |
| Prefix, **k** | Resize pane up 10 rows |
| Prefix, **j** | Resize pane down 10 rows |

## Synchronize Panes

Broadcast keystrokes to all panes simultaneously — useful for running the same command across multiple SSH sessions.

| Key | Action |
| ---: | :--- |
| **F3** | Synchronize panes ON (no prefix) |
| **F4** | Synchronize panes OFF (no prefix) |
| Prefix, **F3** | Toggle synchronize panes |

## Search

| Key | Action |
| ---: | :--- |
| Prefix, **/** | Search scrollback buffer |
| Prefix, **CTRL+f** | FZF fuzzy search (sessions, windows, panes, commands) |

## Sessions

| Key | Action |
| ---: | :--- |
| Prefix, **d** | Detach from current session |
| Prefix, **CTRL+s** | Save session (tmux-resurrect) |
| Prefix, **CTRL+r** | Restore session (tmux-resurrect) |

> Sessions auto-save every **15 minutes** via tmux-continuum and restore automatically on tmux server start.

## CLI Commands

| Command | Action |
| ---: | :--- |
| **tmux ls** | List all sessions |
| **tmux a** | Re-attach to most recently used session |
| **tmux attach -t \<ID\>** | Re-attach to a specific session by ID |
| **tmux new -s \<name\>** | Create a new named session |
| **tmux kill-session -t \<ID\>** | Kill a session by ID |

---
