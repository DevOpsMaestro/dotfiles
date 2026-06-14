# NERDTree Cheatsheet

Quick reference for NERDTree inside Vim. Configuration: [dot_vimrc.tmpl](https://github.com/DevOpsMaestro/dotfiles/blob/main/dot_vimrc.tmpl)

---

## Opening and Closing

| Key | Action |
|---|---|
| `Ctrl+n` | Open NERDTree |
| `Ctrl+t` | Toggle NERDTree open or closed |
| `\n` (leader + n) | Focus NERDTree without closing it |
| `q` | Close the NERDTree window |
| `A` | Maximize or restore the NERDTree window |

---

## Navigation

| Key | Action |
|---|---|
| `o` | Open the selected file, directory, or bookmark |
| `O` | Recursively open the selected directory |
| `p` | Jump to the current node's parent |
| `P` | Jump to the root node |
| `K` | Jump to the first sibling in the current directory |
| `J` | Jump to the last sibling in the current directory |
| `C` | Change the tree root to the selected directory |
| `u` | Move the tree root up one directory |
| `cd` | Change the working directory to the selected node |
| `CD` | Change the tree root to the current working directory |

---

## Opening Files

| Key | Action |
|---|---|
| `t` | Open the selected file in a new tab |
| `s` | Open the selected file in a vertical split |
| `i` | Open the selected file in a horizontal split |
| `e` | Edit the current directory |

---

## File Menu

Press `m` to open the NERDTree file menu, then press one of the following keys.

| Key | Action |
|---|---|
| `a` | Add a new file or directory |
| `m` | Move (rename) the current node |
| `d` | Delete the current node |
| `c` | Copy the current node |
| `p` | Copy the node's path to the clipboard |
| `l` | List details for the current node |

---

## Tree Management

| Key | Action |
|---|---|
| `x` | Close the parent of the current node |
| `X` | Recursively close all children of the current node |
| `R` | Refresh the tree (use when files change outside Vim) |

---

## Display Toggles

| Key | Action |
|---|---|
| `I` | Toggle hidden files |
| `F` | Toggle whether files are shown |
| `B` | Toggle the bookmark table |

---

## Help

| Key | Action |
|---|---|
| `?` | Toggle the NERDTree quick-help panel |
| `:help NERDTree` | Open the full NERDTree documentation |
