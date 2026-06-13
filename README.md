# DevOpsMaestro — Dotfiles

Personal system configuration files for macOS and Arch Linux, managed with [chezmoi](https://github.com/twpayne/chezmoi). Templates handle differences between machines through prompted variables, keeping sensitive values out of version control.

---

## Managed Configuration Files

| Source File | Deployed To | Purpose |
|---|---|---|
| `.chezmoi.toml.tmpl` | `~/.config/chezmoi/chezmoi.toml` | chezmoi settings and template variables |
| `dot_gitconfig.tmpl` | `~/.gitconfig` | Git identity, signing, aliases, and tools |
| `dot_zshrc.tmpl` | `~/.zshrc` | Zsh shell configuration and aliases |
| `dot_zshenv.tmpl` | `~/.zshenv` | Zsh environment variables (loaded for all sessions) |
| `dot_vimrc.tmpl` | `~/.vimrc` | Vim editor configuration and plugins |
| `dot_tmux.conf.tmpl` | `~/.tmux.conf` | tmux multiplexer configuration |
| `dot_config/starship.toml.tmpl` | `~/.config/starship.toml` | Starship prompt (Catppuccin Mocha theme) |
| `private_dot_ssh/private_config.tmpl` | `~/.ssh/config` | SSH host definitions and key assignments |
| `private_dot_gnupg/` | `~/.gnupg/` | GPG agent configuration |
| `run_once_install-packages.sh.tmpl` | — | One-time package installation script |

---

## Prerequisites

The following tools must be installed before running `chezmoi init`:

- **chezmoi** — dotfiles manager
- **GPG** — used for encrypting private files and signing Git commits
- A GPG key pair associated with the email address used during setup

---

## Installation

### macOS

```shell
brew install chezmoi
```

### Arch Linux

```shell
pacman -S chezmoi
```

---

## Deploying to a New Machine

Initialize and apply all dotfiles in a single command:

```shell
chezmoi init --apply DevOpsMaestro
```

`chezmoi init` will prompt for the following values before writing any files:

| Prompt | Example Value | Used In |
|---|---|---|
| `email` | `user@example.com` | Git config, GPG key |
| `gpg key` | `412D990A41E880F4645E3E3E5AA9018FE9C21542` | Git signing key, chezmoi GPG recipient |
| `github username` | `DevOpsMaestro` | Git config |
| `fortress lab username` | `goldenleg` | SSH config host block |

To initialize without applying immediately:

```shell
chezmoi init https://github.com/DevOpsMaestro/dotfiles.git
```

Then review and apply when ready:

```shell
chezmoi diff
chezmoi apply
```

---

## Daily Workflow

### Check for differences between local files and the chezmoi source

```shell
chezmoi status
```

### Pull updates from the remote repository and apply them

```shell
chezmoi update -v
```

### Sync a locally edited dotfile back into the chezmoi source

```shell
chezmoi re-add ~/.zshrc
```

### Commit and push changes to the remote repository

```shell
chezmoi git -- add .
chezmoi git -- commit -m "describe what changed"
chezmoi git -- push
```

### Stop tracking a file

```shell
chezmoi forget ~/.ssh/config
```

---

## Vim Configuration

<details>
  <summary>Key bindings and plugin reference</summary>

&nbsp;

The Vim configuration uses [vim-plug](https://github.com/junegunn/vim-plug) as its plugin manager. If vim-plug is not present on first launch, it is downloaded automatically. Plugins are installed on the first run.

To manage plugins manually:

| Command | Action |
|---|---|
| `:PlugInstall` | Install all plugins |
| `:PlugUpdate` | Update all plugins |
| `:PlugClean` | Remove unused plugins |

### Color Scheme

Catppuccin Macchiato is applied automatically.

### Window and Pane Navigation

| Key | Action |
|---|---|
| `Ctrl+h` | Move to left pane |
| `Ctrl+j` | Move to lower pane |
| `Ctrl+k` | Move to upper pane |
| `Ctrl+l` | Move to right pane |

### Tab Management

| Key | Action |
|---|---|
| `F5` | Open new tab |
| `F6` | Next tab |
| `F7` | Previous tab |
| `F8` | Open file under cursor in new tab |

### Session Management

| Key | Action |
|---|---|
| `\ss` | Save current session |
| `\sr` | Restore last session |

### File Explorer — NERDTree

| Key | Action |
|---|---|
| `Ctrl+n` | Open NERDTree |
| `Ctrl+t` | Toggle NERDTree |

### Linting — ALE

ALE (Asynchronous Lint Engine) provides real-time error checking for Python, YAML, JSON, Dockerfile, Terraform, and other formats. Errors appear inline as the file is edited. To fix the current file manually:

```
:ALEFix
```

### Editor Defaults

- Tab width: 2 spaces
- Line numbers: enabled
- Column 80 marker: enabled
- System clipboard integration: enabled
- Line wrap: disabled by default; toggle with `F12`
- Search: case-insensitive unless uppercase letters are used

</details>

[NERDTree Cheatsheet](https://github.com/DevOpsMaestro/dotfiles/blob/main/cheatsheet_nerdtree.md)

---

## tmux Configuration

<details>
  <summary>Key bindings and plugin reference</summary>

&nbsp;

The prefix key for all tmux commands is **`Ctrl+Space`**.

### Session Management

| Command | Action |
|---|---|
| `tmux new -s <name>` | Create a named session |
| `tmux ls` | List active sessions |
| `tmux attach -t <name>` | Attach to a session |
| `Prefix + d` | Detach from the current session |

### Window Management

| Key | Action |
|---|---|
| `Prefix + w` | Create a new window |
| `Prefix + n` | Move to the next window |
| `Prefix + p` | Move to the previous window |
| `Prefix + ,` | Rename the current window |
| `Prefix + &` | Close the current window |

### Pane Management

| Key | Action |
|---|---|
| `Prefix + v` | Split pane vertically |
| `Prefix + h` | Split pane horizontally |
| `Prefix + Arrow Keys` | Move between panes |
| `Prefix + Ctrl + Arrow Keys` | Resize the current pane |
| `Prefix + x` | Close the current pane |

### Vi-Style Copy Mode

| Key | Action |
|---|---|
| `Prefix + [` | Enter copy mode |
| `v` | Begin text selection |
| `y` | Copy selection to clipboard |
| `Prefix + ]` | Paste from buffer |

### Plugins

**tmux-resurrect** — saves and restores sessions across system restarts.

| Key | Action |
|---|---|
| `Prefix + Ctrl+s` | Save current session |
| `Prefix + Ctrl+r` | Restore saved session |

**vim-tmux-navigator** — enables unified navigation between Vim splits and tmux panes using `Ctrl+h/j/k/l`.

### Other Bindings

| Key | Action |
|---|---|
| `Prefix + r` | Reload the tmux configuration |
| `Prefix + ?` | List all active key bindings |

</details>

[tmux Cheatsheet](https://github.com/DevOpsMaestro/dotfiles/blob/main/cheatsheet_tmux.md)

---

## Starship Prompt

The prompt uses the [Catppuccin Mocha](https://catppuccin.com/) color palette and requires a [Nerd Font](https://www.nerdfonts.com/) to render all icons correctly. FiraCode Nerd Font Mono is the recommended choice.

Prompt modules enabled: username, hostname, directory, git branch, git status, Kubernetes context, shell indicator, command duration, battery, and time.

---

## GPG Setup

Private files (SSH config, GPG config) are encrypted using the GPG key whose fingerprint is provided during `chezmoi init`. The key must exist in the local GPG keyring before running `chezmoi apply` on a new machine.

To import an existing key on a new machine:

```shell
gpg --import private-key.asc
```

To verify the key is present:

```shell
gpg --list-secret-keys --keyid-format long
```
