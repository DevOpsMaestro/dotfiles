# fd Cheatsheet

Quick reference for `fd`, a fast and user-friendly alternative to `find`. Configuration: [run_once_install-packages.sh.tmpl](https://github.com/DevOpsMaestro/dotfiles/blob/main/run_once_install-packages.sh.tmpl)

`fd` searches from the current directory by default. Patterns are regular expressions unless `--glob` is given. The search is case-insensitive unless the pattern contains an uppercase letter (smart case). Files and directories listed in `.gitignore`, `.ignore`, and `.fdignore` are excluded automatically.

---

## Basic Usage

```shell
fd [OPTIONS] [pattern] [path]
```

| Command | Description |
|---|---|
| `fd` | List all files in the current directory tree |
| `fd config` | Find all entries whose name contains `config` |
| `fd config ~` | Search for `config` under the home directory |
| `fd '\.yaml$'` | Match a regular expression (files ending in `.yaml`) |
| `fd -g '*.yaml'` | Match a glob pattern instead of a regular expression |
| `fd -F 'my.file'` | Treat the pattern as a fixed string (no regex) |

---

## Filtering by Type

Use `-t` to restrict results to a specific kind of filesystem entry. The flag may be given more than once to include multiple types.

| Flag | Matches |
|---|---|
| `-t f` | Regular files |
| `-t d` | Directories |
| `-t l` | Symbolic links |
| `-t x` | Executable files |
| `-t e` | Empty files or directories |
| `-t s` | Sockets |
| `-t p` | Named pipes (FIFOs) |

```shell
fd -tf deploy           # files only
fd -td config           # directories only
fd -tf -tl config       # files and symlinks
fd -tx                  # all executables in the tree
```

---

## Filtering by Extension

```shell
fd -e yaml              # all .yaml files
fd -e yaml -e yml       # .yaml and .yml files
fd deploy -e yaml       # .yaml files whose name contains "deploy"
```

---

## Filtering by Size

Format: `<sign><number><unit>` — use `+` for "at least," `-` for "at most," or no sign for an exact match.

| Unit | Meaning |
|---|---|
| `b` | Bytes |
| `k` | Kilobytes (1 000 bytes) |
| `m` | Megabytes |
| `g` | Gigabytes |
| `ki` | Kibibytes (1 024 bytes) |
| `mi` | Mebibytes |
| `gi` | Gibibytes |

```shell
fd -tf -S +100m         # files larger than 100 MB
fd -tf -S -1k           # files smaller than 1 KB
fd -tf -S 4ki           # files exactly 4 KiB
```

---

## Filtering by Modification Time

```shell
fd --changed-within 1d          # modified in the last day
fd --changed-within 2weeks      # modified in the last two weeks
fd --changed-before 2024-01-01  # modified before 1 January 2024
fd --newer 2024-06-01           # alias for --changed-within with a date
```

---

## Filtering by Owner

Format: `[user][:group]`. Prefix either side with `!` to exclude.

```shell
fd --owner john                 # files owned by john
fd --owner :staff               # files owned by the staff group
fd --owner '!root'              # files not owned by root
fd --owner john:staff           # files owned by john in the staff group
```

---

## Controlling Search Depth

```shell
fd -d 2 config          # search no deeper than 2 directories
fd --min-depth 2 config # skip the top level; start at depth 2
fd --exact-depth 3 '\.md$'  # match only at exactly depth 3
```

---

## Hidden Files and Ignored Entries

By default, `fd` skips hidden files (names starting with `.`) and entries matched by `.gitignore`, `.ignore`, or `.fdignore`.

```shell
fd -H config            # include hidden files
fd -I config            # ignore all ignore-file rules
fd -u config            # unrestricted: hidden + ignored (equivalent to -HI)
```

---

## Excluding Patterns

Use `-E` to exclude files or directories that match a glob. Multiple exclusions may be specified.

```shell
fd -E '*.pyc'                       # skip .pyc files
fd -E node_modules                  # skip the node_modules directory
fd -E '*.pyc' -E node_modules       # combine exclusions
```

To make a permanent exclusion, add the pattern to `~/.fdignore` (same syntax as `.gitignore`).

---

## Case Sensitivity

`fd` uses smart case by default: case-insensitive when the pattern is all lowercase, case-sensitive when it contains any uppercase letter.

```shell
fd config               # smart case: matches Config, CONFIG, config
fd -i Config            # force case-insensitive
fd -s Config            # force case-sensitive
```

---

## Executing Commands

Use `-x` to run a command once per result (in parallel). Use `-X` to run a command once with all results as arguments (batch mode).

| Placeholder | Expands to |
|---|---|
| `{}` | Full path |
| `{/}` | Filename only (basename) |
| `{//}` | Parent directory |
| `{.}` | Full path without extension |
| `{/.}` | Basename without extension |

```shell
# Convert every .png to .jpg (one process per file)
fd -e png -x convert {} {.}.jpg

# Open all matching files in Vim at once
fd -g 'test_*.py' -X vim

# Count lines in all Rust source files
fd -e rs -X wc -l

# Delete all .DS_Store files
fd -H -tf -g '.DS_Store' -X rm

# Show details for all YAML files (like ls -l)
fd -e yaml -l
```

---

## Output Options

```shell
fd -a config            # show absolute paths instead of relative
fd -l config            # long listing format (like ls -l)
fd -0 config            # separate results with null bytes (safe for xargs)
fd config | xargs -0    # combine with xargs using null-byte delimiter
fd --max-results 5 config   # stop after the first 5 results
fd -1 config            # stop after the first result (alias for --max-results=1)
fd -q config            # quiet mode: exit 0 if any match found, 1 if none
```

---

## Searching Multiple Paths

```shell
fd config ~/projects ~/work     # search two directories
fd --search-path ~/projects --search-path ~/work config
```

---

## Ignore Files

`fd` respects the following ignore files, in order of precedence:

| File | Location | Scope |
|---|---|---|
| `.fdignore` | Any ancestor directory | `fd`-specific exclusions |
| `.ignore` | Any ancestor directory | General tool exclusions |
| `.gitignore` | Repository root and ancestors | VCS exclusions |
| Global gitignore | `~/.config/git/ignore` | Machine-wide exclusions |

To bypass ignore files for a single search, use `-I` (no-ignore) or `-u` (unrestricted).

---

## Practical Recipes

```shell
# Find all files modified today and copy them to a backup directory
fd --changed-within 1d -tf -X cp {} ~/backup/

# Find Kubernetes YAML files anywhere under the current repo
fd -e yaml -e yml -g '*deploy*'

# Find all files larger than 50 MB under the home directory
fd -tf -S +50m ~

# Find and delete all empty directories
fd -td -te -X rmdir

# List every shell script in the repo
fd -e sh -e zsh

# Search only within a specific depth for config files
fd -d 3 -e toml

# Find files not owned by the current user
fd -tf --owner "!$(whoami)"
```

---

## Quick Reference

| Flag | Long Form | Purpose |
|---|---|---|
| `-t <type>` | `--type` | Filter by entry type |
| `-e <ext>` | `--extension` | Filter by file extension |
| `-S <size>` | `--size` | Filter by file size |
| `-d <n>` | `--max-depth` | Limit search depth |
| `-E <pat>` | `--exclude` | Exclude a glob pattern |
| `-H` | `--hidden` | Include hidden files |
| `-I` | `--no-ignore` | Ignore all ignore files |
| `-u` | `--unrestricted` | Hidden + no ignore (combines -HI) |
| `-i` | `--ignore-case` | Force case-insensitive |
| `-s` | `--case-sensitive` | Force case-sensitive |
| `-g` | `--glob` | Use glob instead of regex |
| `-F` | `--fixed-strings` | Treat pattern as literal string |
| `-a` | `--absolute-path` | Print absolute paths |
| `-l` | `--list-details` | Long listing format |
| `-0` | `--print0` | Null-byte-separated output |
| `-x <cmd>` | `--exec` | Execute command per result |
| `-X <cmd>` | `--exec-batch` | Execute command with all results |
| `-1` | `--max-results=1` | Return only the first match |
| `-q` | `--quiet` | Suppress output; use exit code only |
