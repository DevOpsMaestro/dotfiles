# Chezmoi Cheatsheet

Reference guide for managing dotfiles with [chezmoi](https://github.com/twpayne/chezmoi).

---

## Key Concepts

| Term | Description |
|---|---|
| **Source directory** | `~/.local/share/chezmoi` — where chezmoi stores its managed copies of files. This directory is a Git repository. |
| **Target file** | The actual dotfile deployed on the system (e.g. `~/.zshrc`). |
| **Template** | A source file ending in `.tmpl` that uses Go template syntax (`{{ }}`) to insert machine-specific values at apply time. |
| **Encrypted file** | A source file prefixed with `private_` that chezmoi encrypts using GPG before storing and decrypts when applying. |
| **One-time script** | A source file prefixed with `run_once_` that chezmoi executes only once per machine, tracked by a checksum. |

### Source File Naming Conventions

| Prefix or Suffix | Meaning |
|---|---|
| `dot_` | Deploys as a dotfile (e.g. `dot_zshrc` → `~/.zshrc`) |
| `private_` | File is GPG-encrypted in the source |
| `run_once_` | Script runs once; re-runs only if the file content changes |
| `.tmpl` | File is a Go template; variables are resolved at apply time |
| `dot_config/` | Deploys to `~/.config/` |

---

## Installing on a New Machine

### macOS

```shell
brew install chezmoi
```

### Arch Linux

```shell
pacman -S chezmoi
```

### Initialize and apply all dotfiles in one command

```shell
chezmoi init --apply DevOpsMaestro
```

Chezmoi will prompt for template variables (email, GPG key, GitHub username, fortress lab username) before writing any files.

To initialize without applying immediately:

```shell
chezmoi init https://github.com/DevOpsMaestro/dotfiles.git
chezmoi diff    # review what will change
chezmoi apply   # apply when ready
```

---

## Workflow A — Edit the Source File Directly

Use this approach when editing configuration that has no sensitive local state. Open the source file, make changes, then commit.

### Step 1 — Open the source file in your editor

```shell
vim ~/.local/share/chezmoi/dot_zshrc.tmpl
```

All source files live under `~/.local/share/chezmoi/`. The filename uses chezmoi's naming convention (e.g. `dot_` prefix, `.tmpl` suffix).

### Step 2 — Verify the change looks correct before applying

```shell
chezmoi diff
```

This shows exactly what will change in the target files when the source is applied.

### Step 3 — Apply the change to the live system

```shell
chezmoi apply
```

Or apply only one specific file:

```shell
chezmoi apply ~/.zshrc
```

### Step 4 — Reload the shell if a shell config was changed

```shell
source ~/.zshrc
```

### Step 5 — Commit and push to the remote repository

```shell
czp "describe what changed"
```

`czp` is a shell function defined in `~/.zshrc` that runs `git add .`, `git commit`, and `git push` inside the chezmoi source directory. Omitting the message defaults to `chore: update dotfiles`.

---

## Workflow B — Edit the Local File and Sync to Chezmoi

Use this approach when it is more convenient to edit the deployed file directly (e.g. after testing a change live in the shell).

### Step 1 — Edit the live dotfile as normal

```shell
vim ~/.zshrc
```

### Step 2 — Pull the change back into the chezmoi source directory

```shell
chezmoi re-add ~/.zshrc
```

`re-add` copies the current state of the local file into the chezmoi source, overwriting the previous source version. If the source file is a template (`dot_zshrc.tmpl`), chezmoi will warn that re-adding will remove the template attribute. Answer **no** to that prompt, then use `chezmoi edit` instead (see below).

### Step 3 — Commit and push

```shell
czp "describe what changed"
```

---

## Editing a Template File via the Source

When a source file is a template (`.tmpl`), do not use `chezmoi re-add` — it will strip the template markers. Use `chezmoi edit` instead, which opens the source template directly:

```shell
chezmoi edit ~/.zshrc
```

After saving, apply and push as normal:

```shell
chezmoi apply ~/.zshrc
czp "describe what changed"
```

---

## Checking Status and Reviewing Changes

### Show which source files differ from the deployed files

```shell
chezmoi status
```

Output codes: `M` = modified, `A` = added, `D` = deleted, `R` = renamed.

### Show a line-by-line diff of all pending changes

```shell
chezmoi diff
```

### Show the diff for one specific file

```shell
chezmoi diff ~/.zshrc
```

### Run chezmoi git commands from anywhere

```shell
chezmoi git -- status
chezmoi git -- log --oneline -10
chezmoi git -- diff
```

---

## Pulling Updates from the Remote Repository

To fetch the latest commits from the remote and apply all changes to the live system:

```shell
chezmoi update -v
```

This is equivalent to running `git pull` inside the source directory followed by `chezmoi apply`.

---

## Template Variables

Template variables are values prompted during `chezmoi init` and stored in `~/.config/chezmoi/chezmoi.toml` under `[data]`.

### View all current template variable values

```shell
chezmoi data
```

### Edit the chezmoi config file directly

```shell
chezmoi edit-config
```

### Regenerate the config file from the source template

Run this after modifying `.chezmoi.toml.tmpl` in the source directory:

```shell
chezmoi init
```

---

## Working with Encrypted Files

Files prefixed with `private_` in the source directory are GPG-encrypted. The GPG key fingerprint set in `chezmoi.toml` under `gpg.recipient` must exist in the local keyring.

### View an encrypted file without applying it

```shell
chezmoi cat ~/.ssh/config
```

### Edit an encrypted file

```shell
chezmoi edit ~/.ssh/config
```

If the GPG key is missing, chezmoi will fail to decrypt with an error similar to:

```
gpg: decryption failed: No secret key
```

Refer to `cheatsheet_gpg.md` for the full key restoration procedure.

---

## Stopping Chezmoi from Managing a File

```shell
chezmoi forget ~/.ssh/config
```

This removes the file from the chezmoi source without deleting the live file. Chezmoi will no longer track or modify it.

---

## Adding a New File to Chezmoi

```shell
chezmoi add ~/.config/someapp/config.toml
```

For sensitive files that should be GPG-encrypted:

```shell
chezmoi add --encrypt ~/.config/someapp/secrets.toml
```

---

## Quick Reference — Most Used Commands

| Command | Action |
|---|---|
| `chezmoi status` | Show which managed files differ from the source |
| `chezmoi diff` | Show a line-by-line diff of all pending changes |
| `chezmoi apply` | Apply all source changes to the live system |
| `chezmoi apply ~/.zshrc` | Apply one specific file |
| `chezmoi re-add ~/.zshrc` | Pull a locally edited file back into the source |
| `chezmoi edit ~/.zshrc` | Open the source template for a file |
| `chezmoi update -v` | Pull from remote and apply all changes |
| `chezmoi add <file>` | Begin tracking a new file |
| `chezmoi forget <file>` | Stop tracking a file |
| `chezmoi data` | Show all template variable values |
| `chezmoi init` | Regenerate the config file from the template |
| `chezmoi cd` | Open a shell inside the source directory |
| `czp "message"` | Stage, commit, and push all source changes |

---

## Source Directory Layout for This Setup

```
~/.local/share/chezmoi/
├── .chezmoi.toml.tmpl          # config template (prompts for variables on init)
├── .chezmoiignore              # files chezmoi will not manage
├── dot_gitconfig.tmpl          # ~/.gitconfig
├── dot_zshrc.tmpl              # ~/.zshrc
├── dot_zshenv.tmpl             # ~/.zshenv
├── dot_vimrc.tmpl              # ~/.vimrc
├── dot_tmux.conf.tmpl          # ~/.tmux.conf
├── dot_config/
│   └── starship.toml.tmpl      # ~/.config/starship.toml
├── private_dot_ssh/
│   └── private_config.tmpl     # ~/.ssh/config (GPG-encrypted)
├── private_dot_gnupg/          # ~/.gnupg/ (GPG-encrypted)
├── run_once_install-packages.sh.tmpl   # runs once per machine
├── cheatsheet_gpg.md
├── cheatsheet_nerdtree.md
├── cheatsheet_tmux.md
└── cheatsheet_chezmoi.md
```
