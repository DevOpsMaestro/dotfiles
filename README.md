# DevOpsMaestro/dotfiles

Dapper Dan's dotfiles

Managed with: [`chezmoi`](https://github.com/twpayne/chezmoi)

-----

[following this guide](https://www.chezmoi.io/quick-start/#set-up-a-new-machine-with-a-single-command)

[how-to install the client](https://www.chezmoi.io/install/)

## Macbook client

```shell
brew install chezmoi
```

## Arch Linux client

```shell
pacman -S chezmoi
```

## Rough Notes

From your Second system, example:

```shell
chezmoi init https://github.com/DevOpsMaestro/dotfiles.git
```

You can install your dotfiles on new machine with a single command:

```shell
$ chezmoi init --apply https://github.com/DevOpsMaestro/dotfiles.git
```

If you use GitHub and your dotfiles repo is called dotfiles then this can be shortened to:

```shell
$ chezmoi init --apply DevOpsMaestro
```

After the initial install, you can simply run:

```shell
chezmoi status
chezmoi update -v
```

## Dealing with variances in config files

One solution is to remove the file from the local configuration. 

```shell
chezmoi forget ~/.ssh/config
```

---

<details>
  <summary>Comprehensive Guide to Using This Vim Configuration</summary>

  &nbsp;
  &nbsp;

This guide will walk you through how to use the provided Vim configuration, explaining what it does, how to get started, and how to take advantage of its features-even if you’ve never used it before.

---

### **1. First-Time Setup**

**a. Automatic Plugin Manager Installation**
- The configuration checks if [vim-plug](https://github.com/junegunn/vim-plug) (the plugin manager) is installed. If not, it downloads it automatically, so you don’t need to do anything manually here[2].
- When you first open Vim with this configuration, vim-plug will be installed if necessary.

**b. Installing Plugins**
- On your first launch, plugins may not be installed yet. The configuration will try to install missing plugins automatically.
- If you ever need to install plugins manually, run:
  ```
  :PlugInstall
  ```
- To update plugins later:
  ```
  :PlugUpdate
  ```
- To remove unused plugins:
  ```
  :PlugClean
  ```
- To see plugin changes:
  ```
  :PlugDiff
  ```

---

### **2. Key Plugins and Their Usage**

**a. Color Scheme: Catppuccin**
- The color scheme is set to “catppuccin_macchiato.” It will be applied automatically.
- If you want to change the theme, edit the relevant lines in the config.

**b. NERDTree (File Explorer)**
- Toggle NERDTree sidebar:  
  - `Ctrl+n`: Open NERDTree  
  - `Ctrl+t`: Toggle NERDTree  
  - `n` (usually `\n`): Focus NERDTree  
- NERDTree lets you browse, create, move, and delete files and folders quickly[4].
- Useful for visualizing your project structure.

**c. ALE (Asynchronous Lint Engine)**
- Provides real-time code linting and fixing for many languages[3].
- Errors and warnings show up as you type.
- To manually fix code in the current file:
  ```
  :ALEFix
  ```
- ALE is configured to lint and fix Python, YAML, Dockerfile, JSON, Terraform, and more.

**d. Airline**
- Provides a nice status/tab bar at the bottom of Vim.
- Shows file info, mode, and integrates with ALE to display linting status.

**e. Other Plugins**
- `auto-pairs`: Auto-closes brackets, quotes, etc.
- `goyo.vim`: Distraction-free writing mode (`:Goyo` command).

---

### **3. Key Mappings and Shortcuts**

**a. Window and Tab Navigation**
- Move between panes:  
  - `Ctrl+h`: Left  
  - `Ctrl+j`: Down  
  - `Ctrl+k`: Up  
  - `Ctrl+l`: Right
- Tabs:  
  - `F5`: Open new tab  
  - `F6`: Next tab  
  - `F7`: Previous tab  
  - `F8`: Open file under cursor in new tab

**b. Session Management**
- Save session:  
  - `ss` (usually `\ss`): Save current session  
- Restore session:  
  - `sr` (usually `\sr`): Reload last session

**c. Line Wrapping**
- Toggle line wrap:  
  - `F12`

---

### **4. Editing and Appearance**

- Line numbers are enabled.
- The 80th column is highlighted for code style.
- Syntax highlighting and true color support are enabled.
- Cursor line and column are highlighted for visibility.
- Search is enhanced:  
  - Case-insensitive by default, but case-sensitive if you use uppercase letters in your search.
  - Search results are highlighted as you type.

---

### **5. Indentation and Formatting**

- Tabs are set to 2 spaces (expandtab, shiftwidth=2, softtabstop=2).
- Auto-indentation is on.
- ALE will try to fix code formatting on save for supported languages.

---

### **6. Miscellaneous Features**

- Uses the system clipboard for copy/paste.
- Keeps 50 lines of command history.
- Enables wildmenu for better command-line completion.
- Disables line wrapping by default (toggle with `F12`).

---

### **7. Reloading the Configuration**

- When you save your `.vimrc`, it will automatically reload, so changes take effect immediately.

---

## **How to Get Started**

1. **Copy the configuration into your `~/.vimrc` file.**
2. **Open Vim.**  
   - The config will install vim-plug if needed and prompt to install plugins.
3. **Wait for plugin installation to finish.**
4. **Start editing!**  
   - Use the shortcuts above for navigation, session management, and file exploration.
5. **Explore Plugins:**  
   - Try toggling NERDTree (`Ctrl+t`), test ALE linting by opening a Python file, and open multiple tabs and splits.

---

## **Tips for New Users**

- If you’re new to Vim, learn basic commands first (`i` to insert, `:w` to save, `:q` to quit, `:wq` to save and quit)[1][6][7].
- Use the mappings and plugins to boost productivity, but don’t hesitate to look up Vim basics as needed.
- For more details on vim-plug, see its [usage guide][2].

---

**Summary:**  
This configuration turns Vim into a powerful, modern code editor with real-time linting, file navigation, session management, and a beautiful UI. Use the provided shortcuts and plugins to streamline your workflow, and don’t be afraid to experiment or customize further as you become more comfortable with Vim.

Citations:

[1] https://www.freecodecamp.org/news/vimrc-configuration-guide-customize-your-vim-editor/

[2] https://github.com/junegunn/vim-plug

[3] https://github.com/dmerejkowsky/vim-ale

[4] https://nickjanetakis.com/blog/i-use-nerdtree-in-vim-but-it-is-usually-not-for-opening-files

[5] https://dev.to/ethand91/my-basic-vim-setup-5hdf

[6] https://dev.to/aviavinav/vim-a-beginners-guide-from-a-beginner-b11

[7] https://www.jakewiesler.com/blog/getting-started-with-vim

[8] https://github.com/xolox/vim-session

[9] https://learnvimscriptthehardway.stevelosh.com/chapters/03.html

[10] https://hamvocke.com/blog/ansi-vim-color-scheme/

[11] https://www.tutorialspoint.com/vim/vim_navigating.htm

[12] https://askubuntu.com/questions/264258/changing-vim-editor-settings

[13] https://www.linode.com/docs/guides/writing-a-vim-plugin/

[14] https://dmerej.info/blog/post/lets-have-a-pint-of-vim-ale/

[15] https://github.com/preservim/nerdtree

[16] https://www.vim.org/scripts/script.php?script_id=2010

[17] https://vim.fandom.com/wiki/Mapping_keys_in_Vim_-_Tutorial_(Part_1)

[18] https://www.linode.com/docs/guides/vim-color-schemes/

[19] https://www.linuxfoundation.org/blog/blog/classic-sysadmin-vim-101-a-beginners-guide-to-vim

[20] https://www.reddit.com/r/vim/comments/viunvt/setting_up_good_vim_workflow_as_a_beginner/







<details>
  <summary>tmux Configuration Guide</summary>

  &nbsp;
  &nbsp;

This guide explains key features and commands for the [DevOpsMaestro tmux configuration](https://github.com/DevOpsMaestro/dotfiles/blob/main/dot_tmux.conf.tmpl), which uses **`Ctrl+Space`** as the prefix key. The configuration emphasizes efficiency, Vi-style navigation, and plugin integration[1][2].

---

### **Essential Key Bindings**  

**Prefix Key**  
- Default prefix: **`Ctrl+Space`**  

---

### **Session Management**  
- **Create new session**: `tmux new -s `  
- **Detach from session**: `Prefix + d`  
- **List sessions**: `tmux ls`  
- **Attach to session**: `tmux attach -t `  
- **Kill session**: `Prefix + x` (confirm with `y`)[1]  

---

### **Window Management**  
- **New window**: `Prefix + w`  
- **Next window**: `Prefix + n`  
- **Previous window**: `Prefix + p`  
- **Rename window**: `Prefix + ,`  
- **Close window**: `Prefix + &`  

---

### **Pane Management**  
- **Split vertically**: `Prefix + v`  
- **Split horizontally**: `Prefix + h`  
- **Switch panes**:  
  - `Prefix + Arrow Keys` (direction-based)  
  - `Prefix + o` (cycle order)  
- **Resize panes**: `Prefix + Ctrl + Arrow Keys`  
- **Kill pane**: `Prefix + x`  

---

### **Vi-Style Copy Mode**  
- **Enter copy mode**: `Prefix + [`  
- **Start selection**: `v` (Vi mode)  
- **Copy selection**: `y`  
- **Paste buffer**: `Prefix + ]`  
- **Quick copy to system clipboard**: `Ctrl+Shift+c`[2]  

---

### **Plugin Shortcuts**  
- **tmux-resurrect** (session backup):  
  - Save session: `Prefix + Ctrl+s`  
  - Restore session: `Prefix + Ctrl+r`  
- **vim-tmux-navigator** (seamless Vim/tmux navigation):  
  - Use `Ctrl+h/j/k/l` to move between Vim splits and tmux panes[2].  

---

### **Configuration & Debugging**  
- **Reload config**: `Prefix + r` (displays "Reloaded!" confirmation)  
- **List all bindings**: `Prefix + ?`  
- **Open notes file**: `Ctrl+Alt+n` (opens in split pane with `lvim`)[2]  

---

### **Advanced Features**  
- **Synchronize panes**:  
  - Enable: `Prefix + :setw synchronize-panes on`  
  - Disable: `Prefix + :setw synchronize-panes off`  
- **256-color support**: Preconfigured for terminal and Neovim compatibility[2].  

---

**Pro Tips**  
- All new splits/windows inherit the current working directory.  
- Use `Prefix + Ctrl+c`/`Ctrl+v` for cross-terminal clipboard integration[2].  
- Customize further by editing `~/.tmux.conf`.  

For the latest updates, refer to the [official cheatsheet](https://github.com/DevOpsMaestro/dotfiles/blob/main/cheatsheet_tmux.md)[1].

Citations:
[1] https://github.com/DevOpsMaestro/dotfiles/blob/main/cheatsheet_tmux.md
[2] https://github.com/akitaonrails/dotfiles/blob/main/dot_tmux.conf.tmpl
[3] https://github.com/NotHarshhaa/devops-cheatsheet/blob/master/Version-Control/GitLab.md
[4] https://github.com/signalpillar/dotfiles/blob/master/dot_tmux.conf.tmpl
[5] https://gerrit.avm99963.com/plugins/gitiles/dotfiles-external/+/b5fe60fafb87dbe165bf7f1d8655a25ccc7329db/dot_tmux.conf.tmpl

---

