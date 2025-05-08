# TMUX Cheatsheet

A quick cheatsheet for the config file setup from: [.tmux.conf working example](https://github.com/DevOpsMaestro/dotfiles/blob/main/dot_tmux.conf.tmpl)

| Command | Effect |
| -----: | :----- |
| **CTRL+spacebar** | *Command's Prefix* |
| Prefix, **SHIFT+I** | Reload/install plugins |
| Prefix, **c** | Create Window |
| Prefix, **n** | Next Window |
| Prefix, **l** | Last Window |
| Prefix, **w** | Window Preview and Selection |
| Prefix, **<** | Swap Window left |
| Prefix, **>** | Swap Window right |
| Prefix, **\|** | Split Window into Vertical Pane |
| Prefix, **-** | Split Window into Horizontal Pane |
| Prefix, **m** | Select Previous Pane |
| Prefix, **/** | Search|
| Prefix, **CTRL+f** | FZF Search |
| Prefix, **d** | Detach from Session |
| **tmux a** | Re-attach to session zero |
| **tmux ls** | List `tmux` sessions |
| **tmux attach -t <ID>**| Re-attach to session by <ID> from the `tmux ls` command |
