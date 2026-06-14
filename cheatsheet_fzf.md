# fzf Cheatsheet

Quick reference for `fzf`, an interactive fuzzy finder for the command line. Configuration: [dot_zshrc.tmpl](https://github.com/DevOpsMaestro/dotfiles/blob/main/dot_zshrc.tmpl)

This setup loads the standard Zsh shell integration from Homebrew on macOS and from system packages on Arch Linux. Shell key bindings (`Ctrl+R`, `Ctrl+T`, `Alt+C`) and fuzzy tab completion are active in every new shell session.

---

## Shell Key Bindings

These bindings are available in the Zsh prompt without invoking `fzf` directly.

| Key | Action |
|---|---|
| `Ctrl+R` | Search shell history interactively; press `Enter` to run the selected command |
| `Ctrl+T` | Paste a file or directory path from the current tree into the prompt |
| `Alt+C` | Change directory by selecting from the current tree interactively |

---

## Fuzzy Tab Completion

Type a partial path followed by `**` and press `Tab` to open an fzf selector.

```shell
vim **<Tab>              # select a file to open in Vim
cd ~/projects/**<Tab>    # select a subdirectory to enter
ssh **<Tab>              # select a host from ~/.ssh/config
kill -9 **<Tab>          # select a running process by name
unset **<Tab>            # select an environment variable to unset
export **<Tab>           # select an environment variable to export
```

The trigger string defaults to `**`. Set `FZF_COMPLETION_TRIGGER` to change it.

---

## Search Syntax

fzf uses extended search mode by default. Multiple terms separated by spaces act as AND. Use the prefixes and suffixes below to control how each term is matched.

| Token | Match Type | Example |
|---|---|---|
| `word` | Fuzzy match | `config` matches `~/.config/starship.toml` |
| `'word` | Exact match (substring) | `'config` matches only lines containing the string `config` |
| `^word` | Prefix match (anchored at start) | `^deploy` matches lines starting with `deploy` |
| `word$` | Suffix match (anchored at end) | `.yaml$` matches lines ending with `.yaml` |
| `'word'` | Exact boundary match | `'foo'` requires word boundaries around `foo` |
| `!word` | Negation (exact, exclude) | `!test` excludes lines containing `test` |
| `!^word` | Negation prefix | `!^dev` excludes lines starting with `dev` |
| `!word$` | Negation suffix | `!.log$` excludes lines ending with `.log` |
| `a \| b` | OR operator | `go$ \| rb$ \| py$` matches lines ending in go, rb, or py |

Combine terms freely:

```
^deploy !test .yaml$        # starts with "deploy", excludes "test", ends with ".yaml"
'config | 'secret            # exactly "config" or exactly "secret"
```

---

## Interactive Controls

These keys are active inside the fzf selection window.

### Navigation

| Key | Action |
|---|---|
| `Up` / `Ctrl+K` / `Ctrl+P` | Move the cursor up |
| `Down` / `Ctrl+J` / `Ctrl+N` | Move the cursor down |
| `Page Up` | Scroll up one page |
| `Page Down` | Scroll down one page |
| `Home` | Jump to the first item |
| `End` | Jump to the last item |

### Selection and Confirmation

| Key | Action |
|---|---|
| `Enter` | Confirm the current selection |
| `Esc` / `Ctrl+C` / `Ctrl+G` | Cancel and exit without selection |
| `Tab` | Select the current item and move down (multi-select mode) |
| `Shift+Tab` | Deselect the current item and move up (multi-select mode) |

### Query Editing

| Key | Action |
|---|---|
| `Ctrl+A` | Move the cursor to the start of the query |
| `Ctrl+E` | Move the cursor to the end of the query |
| `Ctrl+U` | Clear the entire query |
| `Ctrl+W` | Delete the previous word |
| `Ctrl+D` | Delete the character under the cursor |
| `Backspace` | Delete the character before the cursor |
| `Alt+Backspace` | Delete the previous word (alternative) |

### Preview Window

| Key | Action |
|---|---|
| `Shift+Up` | Scroll the preview window up |
| `Shift+Down` | Scroll the preview window down |

---

## Basic Usage

```shell
# Pass any list to fzf and capture the selected line
command | fzf

# Start with an initial query pre-filled
fzf --query "config"

# Automatically select if only one result matches the initial query
fzf --query "config" --select-1

# Exit immediately when the list is empty
fzf --exit-0

# Print the result without launching the interactive UI (filter mode)
fzf --filter "config"
```

---

## Multi-Select

Add `--multi` (or `-m`) to allow selecting more than one item at a time. Use `Tab` and `Shift+Tab` to mark items, then `Enter` to confirm all marked items.

```shell
command | fzf --multi

# Limit to at most five selections
command | fzf --multi=5
```

---

## Preview Window

The `--preview` flag runs a shell command for each highlighted item and displays the output in a side panel. The placeholder `{}` expands to the current item.

```shell
# Preview file contents with bat
fzf --preview 'bat --color=always {}'

# Preview file contents with cat, show line numbers
fzf --preview 'cat -n {}'

# Control window position and size
fzf --preview 'bat {}' --preview-window right:60%
fzf --preview 'bat {}' --preview-window down:40%
fzf --preview 'bat {}' --preview-window up:50%:wrap

# Start with the preview window hidden; toggle with a key binding
fzf --preview 'bat {}' --preview-window hidden --bind '?:toggle-preview'
```

### Preview Window Layout Options

```shell
--preview-window right:50%       # right side, 50% width (default)
--preview-window down:40%        # bottom, 40% height
--preview-window up:50%:wrap     # top, 50% height, with line wrap
--preview-window right:60%:+{2}  # scroll to the line number in field 2
```

---

## Environment Variables

Set these in `~/.zshenv` or `~/.zshrc` to apply globally.

| Variable | Purpose |
|---|---|
| `FZF_DEFAULT_COMMAND` | Command to generate the default item list when fzf reads from a TTY |
| `FZF_DEFAULT_OPTS` | Default flags applied to every fzf invocation |
| `FZF_DEFAULT_OPTS_FILE` | Path to a file containing default options (one per line) |
| `FZF_COMPLETION_TRIGGER` | The string that triggers fuzzy completion (default: `**`) |
| `FZF_COMPLETION_OPTS` | Extra fzf options applied during tab completion |
| `FZF_CTRL_T_COMMAND` | Command used by the `Ctrl+T` binding to list files |
| `FZF_CTRL_T_OPTS` | Extra fzf options for the `Ctrl+T` binding |
| `FZF_CTRL_R_OPTS` | Extra fzf options for the `Ctrl+R` history binding |
| `FZF_ALT_C_COMMAND` | Command used by the `Alt+C` binding to list directories |
| `FZF_ALT_C_OPTS` | Extra fzf options for the `Alt+C` binding |

### Recommended starting configuration

```shell
# Use fd as the default source (respects .gitignore, faster than find)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# Apply a consistent layout to every fzf invocation
export FZF_DEFAULT_OPTS='--layout=reverse --border --height=40% --cycle'

# Use fd for Ctrl+T file search
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Use fd for Alt+C directory search
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
```

---

## Custom Key Bindings

Use `--bind` to map keys to fzf actions. Bindings are comma-separated.

```shell
# Confirm with Ctrl+Y; abort with Ctrl+Q
fzf --bind 'ctrl-y:accept,ctrl-q:abort'

# Toggle the preview window with ?
fzf --bind '?:toggle-preview'

# Reload the list on Ctrl+R (useful for dynamic sources)
fzf --bind 'ctrl-r:reload(ps -ef)'

# Open the selected file in Vim directly from fzf
fzf --bind 'enter:become(vim {})'
```

---

## Scripting Options

```shell
# Pre-fill the query
fzf --query "myterm"

# Print the query string as the first line of output
fzf --print-query

# Exit after the first automatic match (use with --query)
fzf --select-1 --query "uniqueterm"

# Exit immediately when there are no items
fzf --exit-0

# Expect specific keys to terminate fzf (used to detect how the user exited)
fzf --expect=ctrl-v,ctrl-x
# $? is 0; first line of output is the key that was pressed (empty for Enter)
```

---

## Exit Codes

| Code | Meaning |
|---|---|
| `0` | A selection was made normally |
| `1` | No match found |
| `2` | An error occurred |
| `130` | Interrupted with `Ctrl+C` or `Esc` |

---

## Practical Recipes

```shell
# Open a file from the current repository (uses FZF_DEFAULT_COMMAND if set)
vim $(fzf)

# Open a file with a live content preview
vim $(fzf --preview 'bat --color=always {}')

# Interactively select a git branch to check out
git checkout $(git branch --all | fzf)

# Interactively select and show a git commit
git show $(git log --oneline | fzf | awk '{print $1}')

# Select and delete a git branch
git branch -d $(git branch | fzf)

# Kill a process interactively
kill -9 $(ps aux | fzf | awk '{print $2}')

# Select a Kubernetes pod name and stream its logs
kubectl logs -f $(kubectl get pods --all-namespaces -o wide | fzf | awk '{print $2}') -n $(kubectl get pods --all-namespaces | fzf | awk '{print $1}')

# Select a kubectl context to switch to
kubectl config use-context $(kubectl config get-contexts -o name | fzf)

# Search history and execute the selected command immediately
eval $(history | fzf --tac | sed 's/^ *[0-9]* *//')

# Interactively select files to stage with git add
git add $(git status --short | fzf --multi | awk '{print $2}')

# Find and open a recently modified file (using fd)
vim $(fd --changed-within 1d --type f | fzf --preview 'bat --color=always {}')

# Select from a list of running Docker containers
docker exec -it $(docker ps --format '{{.Names}}' | fzf) bash
```

---

## Quick Reference

| Flag | Purpose |
|---|---|
| `-e` / `--exact` | Disable fuzzy matching; require exact substring matches |
| `-i` / `--ignore-case` | Force case-insensitive matching |
| `+i` / `--no-ignore-case` | Force case-sensitive matching |
| `-m` / `--multi` | Enable multi-select with `Tab` and `Shift+Tab` |
| `--height=40%` | Display fzf in a partial window rather than full screen |
| `--layout=reverse` | Show the input at the top, results below |
| `--border` | Draw a border around the fzf window |
| `--cycle` | Allow the cursor to wrap from the last item to the first |
| `--query=STR` | Pre-fill the search query |
| `--select-1` | Auto-select when exactly one item matches |
| `--exit-0` | Exit immediately when no items are present |
| `--filter=STR` | Non-interactive filtering mode; print matches and exit |
| `--print-query` | Include the query string as the first line of output |
| `--expect=KEYS` | Comma-separated keys that can terminate fzf |
| `--preview=CMD` | Run a command to preview the highlighted item |
| `--preview-window=OPT` | Control preview window position, size, and behavior |
| `--bind=KEY:ACTION` | Bind a key or event to an fzf action |
| `--tac` | Reverse the order of input (useful for log streams) |
| `--no-sort` | Do not sort results; preserve input order |
| `--ansi` | Interpret ANSI color codes in the input |
| `--read0` | Read input items separated by null bytes |
| `--print0` | Output selections separated by null bytes |
| `--delimiter=STR` | Set the field delimiter for `--nth` and `--with-nth` |
| `--nth=N[,..]` | Restrict fuzzy matching to specific fields |
| `--with-nth=N[,..]` | Display only specific fields while matching against all |
