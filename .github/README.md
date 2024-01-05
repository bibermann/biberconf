# Biberconf

Tools, tweaks and configs for a Bash command line environment.

Currently working on:
- Debian based systems including Ubuntu (server and desktop environments)
- Arch based systems
- X.org (Wayland is not yet tested)

Biberconf includes:
- [bash-git-prompt: An informative and fancy bash prompt for Git users](https://github.com/magicmonty/bash-git-prompt)
- [HSTR: Easily view, navigate and search your command history](https://github.com/dvorka/hstr) (slightly modified version)
- [stderred: stderr in red](https://github.com/sickill/stderred)
- Recommended settings for Git, Vim, and the tools listed above
- Some useful Bash and Git aliases/scripts

Biberconf sets all your custom configurations into version-control.

## Overview

The Biberconf repository will be placed in your home directory.
This way you can add any configuration file to version control
and at the same time profit from our base configs, 
which you are free to adopt as well.

It serves two purposes:
* First, it provides you with a sophisticated foundation 
    to productively work with the command line.
* Second, it versions your own customizations in a seperate `custom` branch
    (you are allowed to rename the branch or manage multiple branches if you like to).
    This allows you to push your personal configurations to a private repository 
    and easily resue it in other environments.

The installation scripts are designed 
to safely integrate Biberconf into your current configurations*
and automatically rebase your branch on remote updates.

*) Only a few lines, mainly include directives, are added to your current config files.

## Requirements

You need to know how to edit and save documents with `vim` and how to exit `vim`.

## Installation

```bash
# Either use curl:
bash <(curl -sS https://raw.githubusercontent.com/bibermann/biberconf/main/.biberconf/fresh-install.sh)

# Or use wget:
bash <(wget -O- https://raw.githubusercontent.com/bibermann/biberconf/main/.biberconf/fresh-install.sh)
```

If you haven't any of those tools, install `curl` and try again:

```bash
# If you have a Debian based system:
sudo apt update && sudo apt install -y curl

# If you have an Arch based system:
sudo pacman -S core/curl
```

## Update

The script fetches the latest changes, installs them and rebases your `custom` branch.

Do not fear to run this command, it is able to handle common problems or conflicts -
even a rewritten git history of the remote branch.

```bash
~/.biberconf/update.sh
```

## Deinstallation

Uninstalls all integrations, removes Biberconf from your configuration files
and prints a list of files and directories* you then may remove 
to clean your home directory from Biberconf.

```bash
~/.biberconf/uninstall.sh
```

*) You may run the command again after uninstallation, to see the list again.

## Features

### Terminal prompt

![terminal-prompt](../.biberconf/img/terminal-prompt.png)

Legend:

```bash
#      ,---------------------------------- signal name or exit code from last command
#     |                ,------------------ current virtual environment
#     |               |       ,----------- current Git branch
#     |               |      |       ,---- remote Git status
#     |               |      |      |   ,- local Git status
#     |               |      |      |  |
    INT ~/gh/testrepo myvenv master ↑2 *3+2
20:08 $ |
```

### Bash history

Within HSTR you can type keywords to filter the list and select a line with the arrow keys:

![hstr-empty](../.biberconf/img/hstr-empty.png)
![hstr-head-gi](../.biberconf/img/hstr-head-gi.png)

History logic:
- When starting a new terminal window, a snapshot of all past commands (including all commands issued in still opened terminal windows) is made. This command history then is available in HSTR.
- Each issued command is saved with the current date:
    - In the `~/.bash_history` without duplicates to better work with the `[Arrow-Up]` and `[Arrow-Down]` keys in the terminal prompt.
    - In `~/.hstr_histories/` with duplicates to give sense to the "ranking view" mode in HSTR.

Shortcuts:
- `[Ctrl] + [s]`: Start HSTR in "history view" mode.
- `[Ctrl] + [r]`: Start HSTR in "ranking view" mode.
- `[Ctrl] + [f]`: Start HSTR in "favorites view" mode.

### Available commands

- `ccat FILE [FILES...]`: Prints the file(s) with syntax highlighting.
    - Change theme in `ccat_theme.sh`.
        - Show favorite themes: `_ccat_test_selected_themes [TEST_FILE]`
        - Show all themes: `_ccat_test_all_themes [TEST_FILE]`
- `stderred COMMAND`: Executes the command, highlighting all output to stderr with red.
- More aliases:
    - `git` (language set to english)
    - `alert` (use like `sleep 10; alert` to notify you when the previous command (here `sleep 10`) has finished)
    - `l`
    - `ll`
    - `la`

#### Desktop environments only

- `open`: Shortcut for `xdg-open`

#### Debian based systems only

- `upgrade`: Upgrades your system, optionally shutting down afterwards, see `upgrade -h` for options.

### Git aliases

- `git s [ARGS...]`: Alias for `git status`.
- `git d [ARGS...]`: Like `git diff` but as minimal as possible. Perfect for an overview of all changes.
    ![git-d](../.biberconf/img/git-d.png)
- `git l [ARGS...]`: Like `git log --graph` but with pretty and compact formatting.
    ![git-l](../.biberconf/img/git-l.png)
- `git a [ARGS...]`: Auto-Log: Like `git l` but in reverse order and automatically updating after changes. That means if you run this command once in a terminal and pin it somewhere on the screen, you will always see the up-to-date git history there, starting with the youngest entry at the bottom of the terminal window.

# Recommended tools

## Graphical tools

- `gitk` (Git GUI)
- `tilix` (Terminal emulator)
- `speedcrunch` (calculator)
- `gnome-tweaks` (extended GNOME configuration)
- `dconf-editor` (advanced GNOME configuration)

<details><summary>Installation instructions (Debian)</summary>
<p>

```bash
sudo apt update
sudo apt install -y gitk tilix atom speedcrunch gnome-tweaks dconf-editor
```

</p>
</details>

<details><summary>Installation instructions (Arch)</summary>
<p>

<!--
Note: tk and tcl are required to run gitk.
-->

```bash
sudo pacman -S extra/{tk,tcl,tilix,speedcrunch,dconf-editor}
paru -S aur/archlinux-tweak-tool-git
```

</p>
</details>

## Command-line tools

- `tree` (recursive directory listing)
- `ag` ([code-searching tool](https://github.com/ggreer/the_silver_searcher))
- `jq` ([command-line JSON processor](https://stedolan.github.io/jq/))
- `cloc` (count lines of code)
- `most` (alternative to `more`)
- `mc` (Midnight Commander)
- `recode` (example: `recode latin-1..utf-8 myfile.txt`)
- `neofetch` (system information gathering)

<details><summary>Installation instructions (Debian)</summary>
<p>

```bash
sudo apt install -y tree silversearcher-ag jq cloc most mc recode neofetch
```

</p>
</details>

<details><summary>Installation instructions (Arch)</summary>
<p>

```bash
sudo pacman -S extra/{tree,the_silver_searcher,jq,cloc,most,mc,recode,neofetch}
```

</p>
</details>

## Developer's tools

- `curl`
- [`direnv`](https://direnv.net/docs/installation.html)
- [`pyenv`](https://github.com/pyenv/pyenv#installation)
- [`poetry`](https://python-poetry.org/docs/#installation)

<details><summary>Installation instructions (Debian)</summary>
<p>

```bash
sudo apt install -y \
    curl direnv \
    `# pyenv` \
        build-essential libssl-dev zlib1g-dev libbz2-dev \
        libreadline-dev libsqlite3-dev wget llvm libncurses-dev \
        xz-utils tk-dev libffi-dev liblzma-dev python-openssl \
    `# poetry` \
        python3-venv
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python

# Please re-login now.
```

</p>
</details>

<details><summary>Installation instructions (Arch)</summary>
<p>

```bash
sudo pacman -S core/curl
sudo pacman -S extra/{direnv,pyenv,python-poetry}
```

</p>
</details>
