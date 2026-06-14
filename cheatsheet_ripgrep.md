# ripgrep Cheatsheet

Quick reference for `rg` (ripgrep), a fast recursive search tool with full Unicode support. Configuration: [run_once_install-packages.sh.tmpl](https://github.com/DevOpsMaestro/dotfiles/blob/main/run_once_install-packages.sh.tmpl)

This build is version 15.1.0 with PCRE2 10.45 (JIT enabled) and NEON SIMD acceleration. By default, ripgrep respects `.gitignore` rules and skips hidden files and binary files automatically.

---

## Basic Usage

```shell
rg PATTERN              # search the current directory tree recursively
rg PATTERN PATH         # search a specific file or directory
rg PATTERN file.txt     # search a single file
command | rg PATTERN    # filter stdin
```

---

## Patterns

ripgrep uses its own fast regex engine by default. Patterns are Unicode-aware.

### Multiple Patterns

```shell
rg -e 'foo' -e 'bar'            # match lines containing foo OR bar
rg -f patterns.txt              # read patterns from a file, one per line
```

### Literal Strings

```shell
rg -F 'foo.bar'                 # treat the pattern as a fixed string (no regex)
rg -- '-foo'                    # search for a pattern beginning with a dash
rg -e -foo                      # alternative: use -e to avoid flag confusion
```

### Word and Line Boundaries

```shell
rg -w 'error'                   # match only whole words (surrounded by word boundaries)
rg -x 'exact line text'         # match only lines where the entire line matches
```

### Case Sensitivity

| Flag | Behavior |
|---|---|
| (default) | Case-sensitive |
| `-i` / `--ignore-case` | Case-insensitive |
| `-S` / `--smart-case` | Case-insensitive when the pattern is all lowercase; case-sensitive otherwise |

```shell
rg 'Error'              # case-sensitive: matches Error but not error
rg -i 'error'           # case-insensitive: matches Error, ERROR, error
rg -S 'error'           # smart-case: pattern is all lowercase, so case-insensitive
rg -S 'Error'           # smart-case: pattern has uppercase, so case-sensitive
```

---

## PCRE2 (Advanced Regex)

Pass `-P` to enable the PCRE2 engine, which supports lookahead, lookbehind, and backreferences. This build includes PCRE2 with JIT.

```shell
rg -P '(?<=def )\w+'            # lookbehind: find function names after "def "
rg -P '(?=.*foo)(?=.*bar)'      # lookahead: lines containing both foo and bar
rg -P '(\w+) \1'                # backreference: find repeated words
rg -P '\bfoo\b(?!bar)'          # negative lookahead: "foo" not followed by "bar"
rg --engine=auto 'pattern'      # let ripgrep choose the engine automatically
```

---

## Context Lines

```shell
rg -A 3 'error'                 # show 3 lines after each match
rg -B 3 'error'                 # show 3 lines before each match
rg -C 3 'error'                 # show 3 lines before and after each match
```

---

## Filtering by File Type

ripgrep recognizes hundreds of file types. Run `rg --type-list` to see all available types and their associated glob patterns.

```shell
rg -t yaml 'replicas'           # search only YAML files
rg -t py -t js 'function'       # search Python and JavaScript files
rg -T yaml 'replicas'           # exclude YAML files from the search
rg --type-list                  # list all built-in file types
rg --type-list | grep yaml      # find the globs associated with the yaml type
```

### Custom File Types

```shell
rg --type-add 'helm:*.yaml' -t helm 'image:'   # define a custom type and use it
rg --type-add 'src:include:py,js,ts' -t src 'TODO'  # compose a type from others
```

---

## Filtering by Glob

Use `-g` to include or exclude files and directories by glob pattern. Precede a glob with `!` to exclude.

```shell
rg -g '*.yaml' 'replicas'              # search only .yaml files
rg -g '!*.yaml' 'replicas'            # exclude .yaml files
rg -g '!{node_modules,vendor}/**'     # exclude common dependency directories
rg -g 'src/**/*.ts' 'interface'       # search only TypeScript files under src/
```

---

## Hidden Files and Ignore Rules

By default, ripgrep skips hidden files (names starting with `.`) and respects `.gitignore`, `.ignore`, and `.rgignore` files.

| Flag | Effect |
|---|---|
| `-.` / `--hidden` | Include hidden files and directories |
| `--no-ignore` / `-u` | Disable all ignore-file rules |
| `-uu` | Disable ignore rules and include hidden files |
| `-uuu` | Disable ignore rules, include hidden files, and search binary files |
| `--no-ignore-vcs` | Disable only `.gitignore` rules; still respect `.ignore` and `.rgignore` |

```shell
rg -. 'secret'                  # include hidden files like .env
rg -u 'pattern'                 # ignore all .gitignore rules
rg -uu 'pattern'                # ignore rules + include hidden files
rg -uuu 'pattern'               # unrestricted: search everything including binaries
```

---

## Directory Depth

```shell
rg --max-depth 1 'pattern'      # search only the current directory, not subdirectories
rg --max-depth 2 'pattern'      # search the current directory and one level of subdirectories
```

---

## Output Modes

### Listing Files

```shell
rg -l 'pattern'                 # print only the paths of files with at least one match
rg --files-without-match 'TODO' # print files that do not contain a match
rg --files                      # list every file that would be searched (no matching)
```

### Counting Matches

```shell
rg -c 'error'                   # count the number of matching lines per file
rg --count-matches 'error'      # count every individual match per file (not just lines)
rg -c --include-zero 'error'    # include files with zero matches in the count output
```

### Only the Matching Text

```shell
rg -o 'v[0-9]+\.[0-9]+'        # print only the matched portion of each line
```

### Replacement (Display Only)

`--replace` prints the output with matches substituted. It does not modify any file.

```shell
rg -r '$1' '(\w+)@example\.com'         # extract email usernames using capture group $1
rg -r 'REDACTED' 'password=\S+'         # show where passwords appear, masked in output
rg -o -r '$1' 'image: (.+)'             # extract image names from Kubernetes manifests
```

---

## Output Formatting

```shell
rg -n 'pattern'                 # show line numbers (default when stdout is a tty)
rg -N 'pattern'                 # suppress line numbers
rg --column 'pattern'           # show column numbers as well as line numbers
rg -H 'pattern'                 # always print the file path on each line
rg -I 'pattern'                 # never print the file path
rg --no-heading 'pattern'       # print the file path as a prefix on every line (grep style)
rg --vimgrep 'pattern'          # output in file:line:col:match format for editor integration
rg --json 'pattern'             # output structured JSON Lines for programmatic use
rg -p 'pattern'                 # pretty output: color + headings + line numbers (alias)
rg --trim 'pattern'             # strip leading whitespace from each matched line
rg -M 120 'pattern'             # omit lines longer than 120 bytes; show a count instead
```

---

## Multiline Search

```shell
rg -U 'start.*end'              # match patterns that span multiple lines
rg -U '(?s)start.*end'          # multiline with dot-all so . matches newlines
```

---

## Sorting Results

Sorting always runs in a single thread and disables parallelism.

```shell
rg --sort=path 'pattern'        # sort output by file path (ascending)
rg --sortr=path 'pattern'       # sort output by file path (descending)
rg --sort=modified 'pattern'    # sort by last modification time (ascending)
rg --sortr=modified 'pattern'   # sort by last modification time (descending)
```

---

## Searching Compressed Files

```shell
rg -z 'pattern' archive.gz      # search inside gzip, bzip2, xz, LZ4, Zstd files
```

---

## Ignore Files

ripgrep respects the following ignore files, in order of precedence (highest to lowest):

| File | Location | Scope |
|---|---|---|
| `.rgignore` | Any ancestor directory | ripgrep-specific exclusions |
| `.ignore` | Any ancestor directory | General tool exclusions |
| `.gitignore` | Repository root and ancestors | VCS exclusions |
| `.git/info/exclude` | Repository root | Local VCS exclusions |
| Global gitignore | `~/.config/git/ignore` | Machine-wide exclusions |

To exclude a directory from all ripgrep searches on a machine, add the pattern to `~/.config/git/ignore`.

---

## Configuration File

ripgrep reads default flags from a configuration file if `RIPGREP_CONFIG_PATH` points to one. Set this in `~/.zshenv`:

```shell
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/config"
```

Each flag goes on its own line. Comments begin with `#`.

```
# ~/.config/ripgrep/config
--smart-case
--hidden
--glob=!.git
--glob=!node_modules
```

Pass `--no-config` to ignore the configuration file for a single invocation.

---

## Practical Recipes

```shell
# Find all TODO and FIXME comments in a repository
rg -i 'TODO|FIXME'

# Search only YAML files for a Kubernetes image tag
rg -t yaml -o 'image: (.+)' -r '$1'

# Find function definitions in Go source files
rg -t go '^func '

# Count occurrences of "error" in each log file
rg -c 'error' --sort=path /var/log/

# Search across hidden files (e.g., dotfiles)
rg -. 'SOPS_PGP_FP'

# Find files that do not have a shebang line
rg --files-without-match '^#!' -g '*.sh'

# Extract all unique IP addresses from log files
rg -o '\b\d{1,3}(\.\d{1,3}){3}\b' /var/log/ | sort -u

# Search for a pattern and show surrounding context
rg -C 5 'panic:' app.log

# Replace output for display (does not modify files)
rg -o -r 'host=$1' 'host=(\S+)'

# Use PCRE2 to find Go functions that return an error
rg -P 'func \w+\([^)]*\).*error'

# Combine with fzf for interactive search
rg --line-number '' | fzf --delimiter ':' --preview 'bat --highlight-line {2} {1}'

# Search only within a specific depth for Helm values files
rg --max-depth 3 -g 'values*.yaml' 'replicaCount'

# Find all files containing both "namespace" and "labels"
rg -l 'namespace' | xargs rg -l 'labels'

# Count total matches across a project (not per file)
rg --count-matches 'error' | awk -F: '{sum+=$2} END {print sum}'
```

---

## Quick Reference

| Flag | Purpose |
|---|---|
| `-e PATTERN` | Specify a pattern (use multiple times for OR) |
| `-f FILE` | Read patterns from a file |
| `-F` / `--fixed-strings` | Treat the pattern as a literal string |
| `-i` / `--ignore-case` | Case-insensitive matching |
| `-S` / `--smart-case` | Case-insensitive only when pattern is all lowercase |
| `-w` / `--word-regexp` | Match only whole words |
| `-x` / `--line-regexp` | Match only lines where the entire line matches |
| `-v` / `--invert-match` | Print lines that do not match |
| `-P` / `--pcre2` | Use the PCRE2 engine (lookahead, lookbehind, backreferences) |
| `-U` / `--multiline` | Allow matches to span multiple lines |
| `-t TYPE` | Restrict search to a file type (`--type-list` to list all types) |
| `-T TYPE` | Exclude a file type |
| `-g GLOB` | Include or exclude files by glob (prefix with `!` to exclude) |
| `-.` / `--hidden` | Include hidden files and directories |
| `--no-ignore` / `-u` | Disable all ignore-file rules |
| `-uu` | Disable ignore rules and include hidden files |
| `-uuu` | Fully unrestricted: ignore rules + hidden + binary |
| `--max-depth N` | Limit directory traversal depth |
| `-A N` | Show N lines after each match |
| `-B N` | Show N lines before each match |
| `-C N` | Show N lines before and after each match |
| `-l` | Print only file paths with at least one match |
| `--files-without-match` | Print file paths that contain no match |
| `--files` | List files that would be searched without searching |
| `-c` | Count matching lines per file |
| `--count-matches` | Count individual matches per file |
| `-o` | Print only the matched portion of each line |
| `-r REPLACEMENT` | Replace matches in output (does not modify files) |
| `-n` | Show line numbers |
| `--column` | Show column numbers |
| `-H` | Always print the file path |
| `-I` | Never print the file path |
| `--no-heading` | Use `file:line:match` prefix format instead of grouped headings |
| `--vimgrep` | Output in `file:line:col:match` format for editor integration |
| `--json` | Output structured JSON Lines |
| `-p` / `--pretty` | Force color + headings + line numbers |
| `--sort=path` | Sort output by file path (disables parallelism) |
| `-m N` | Limit matches to N per file |
| `-j N` | Set the number of search threads |
| `-z` / `--search-zip` | Search inside compressed files |
| `-a` / `--text` | Treat binary files as text |
| `--stats` | Print aggregate search statistics |
| `--no-config` | Ignore the `RIPGREP_CONFIG_PATH` configuration file |
| `--type-list` | List all known file types and their glob patterns |
