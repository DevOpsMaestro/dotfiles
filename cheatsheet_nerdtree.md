# NERDTree Cheatsheet

> Quick reference for NERDTree inside Vim. Config: [dot_vimrc.tmpl](https://github.com/DevOpsMaestro/dotfiles/blob/main/dot_vimrc.tmpl)

## Opening & Closing

| Key | Action |
| ---: | :--- |
| **CTRL+n** | Open NERDTree |
| **CTRL+t** | Toggle NERDTree open/closed |
| **\n** (leader+n) | Focus NERDTree (without closing it) |
| **q** | Close NERDTree window |
| **A** | Zoom NERDTree window (maximize / minimize) |

## Navigation

| Key | Action |
| ---: | :--- |
| **o** | Open file, directory, or bookmark |
| **O** | Recursively open selected directory |
| **p** | Jump to current node's parent |
| **P** | Jump to root node |
| **K** | Jump to first sibling in current directory |
| **J** | Jump to last sibling in current directory |
| **C** | Change tree root to selected directory |
| **u** | Move tree root up one directory |
| **cd** | Change CWD to selected node's directory |
| **CD** | Change tree root to CWD |

## Opening Files

| Key | Action |
| ---: | :--- |
| **t** | Open selected file in a new tab |
| **s** | Open selected file in a vertical split |
| **i** | Open selected file in a horizontal split |
| **e** | Edit the current directory |

## File Menu (m)

Press **m** to open the NERDTree menu, then:

| Key | Action |
| ---: | :--- |
| **a** | Add a new file or directory node |
| **m** | Move (rename) the current node |
| **d** | Delete the current node |
| **c** | Copy the current node |
| **p** | Copy the node's path to clipboard |
| **l** | List the current node |

## Tree Management

| Key | Action |
| ---: | :--- |
| **x** | Close current node's parent |
| **X** | Recursively close all children of current node |
| **R** | Refresh the tree (useful when files change outside Vim) |

## Display Toggles

| Key | Action |
| ---: | :--- |
| **I** | Toggle hidden files |
| **F** | Toggle whether files are displayed |
| **B** | Toggle the bookmark table |

## Help

| Key | Action |
| ---: | :--- |
| **?** | Toggle NERDTree quick help |
| **:help NERDTree** | Full NERDTree documentation |

---
