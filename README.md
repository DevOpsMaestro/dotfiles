# DevOpsMaestro/dotfiles

Dapper Dan's dotfiles, managed with [`chezmoi`](https://github.com/twpayne/chezmoi).

My chezmoi dotfiles

-----

[following this](https://www.chezmoi.io/quick-start/#set-up-a-new-machine-with-a-single-command)

[install client](https://www.chezmoi.io/install/)

Macbook client
```shell
brew install chezmoi
```

Arch Linux client
```shell
pacman -S chezmoi
```

## Rough Notes

From your Second system, example:
```shell
chezmoi init https://github.com/DevOpsMaestro/dotfiles.git

chezmoi diff

chezmoi apply -v

chezmoi edit $FILE

chezmoi merge $FILE

chezmoi update -v
```

You can install your dotfiles on new machine with a single command:
```shell
$ chezmoi init --apply https://github.com/DevOpsMaestro/dotfiles.git
```

If you use GitHub and your dotfiles repo is called dotfiles then this can be shortened to:
```shell
$ chezmoi init --apply DevOpsMaestro
```

