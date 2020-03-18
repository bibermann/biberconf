# Biberconf

Tools, tweaks and configs for a Bash command line environment.

Currently working on Debian based systems including Ubuntu (server and desktop environments).

Biberconf includes:
- [bash-git-prompt: An informative and fancy bash prompt for Git users](https://github.com/magicmonty/bash-git-prompt) (slightly modified version)
- [HSTR: Easily view, navigate and search your command history](https://github.com/dvorka/hstr) (slightly modified version)
- [pss: A power-tool for searching inside source code files](https://github.com/eliben/pss)
- [stderred: stderr in red](https://github.com/sickill/stderred)
- Recommended settings for Git, Vim, and the tools listed above
- Some useful Bash and Git aliases/scripts

Biberconf sets all your custom configurations into version-control.

## Overview

Biberconf will sit under `~/.biberconf/` and all the basic system configurations will get symlinked into this repository.

It serves two purposes:
* First, it provides you with a sophisticated foundation to productively work with the command line.
* Second, it versions your own customizations in a seperate `custom` branch (you are allowed to rename the branch or manage multiple branches if you like to). This allows you to push your personal configurations to a private repository and easily resue it in other environments.

The `install_or_update.sh` script is designed to safely integrate your current configurations into your customized repository and automatically rebases your branch on remote updates.

Before replacing any configuration files with symlinks, a backup gets comitted into your custom branch for each file. At any time you can uninstall or re-install Biberconf. When uninstalling, your previous configuration files are restored.

## Requirements

You have to install and configure Git (please adjust the name and the email):

```bash
sudo apt update && sudo apt install git
git config --global user.name "John Doe"
git config --global user.email "johndoe@example.com"
```

## Installation

```bash
git clone https://github.com/bibermann/biberconf.git ~/.biberconf
cd ~/.biberconf
./install_or_update.sh
```

## Update

The script fetches the latest changes, installs them and rebases your `custom` branch.

Do not fear to run this command, it is able to handle common problems or conflicts - even a rewritten git history of the remote branch.

```bash
cd ~/.biberconf
./install_or_update.sh
```

## Deinstallation

Uninstalls all integrations and restores the configuration files under `user-backup/`.

```bash
cd ~/.biberconf
./uninstall.sh
```

## Features

### Terminal prompt

![terminal-prompt](img/terminal-prompt.png)

Legend:

```bash
#      ,------------------------------------ signal name or exit code from last command
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

![hstr-empty](img/hstr-empty.png)
![hstr-head-gi](img/hstr-head-gi.png)

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

- `upgrade`: Upgrades your system, optionally shutting down afterwards, see `upgrade -h` for options.
- `open`: Shortcut for `xdg-open`
- `ccat FILE [FILES...]`: Prints the file(s) with syntax highlighting.
    - Change theme in `ccat_theme.sh`.
        - Show favorite themes: `_ccat_test_selected_themes [TEST_FILE]`
        - Show all themes: `_ccat_test_all_themes [TEST_FILE]`
- `stderred COMMAND`: Executes the command, highlighting all output to stderr with red.
- `pss ARGS...`: Runs `pss` ignoring directories listed in `pss_ignore.sh`.
- `prettyjson`: Shortcut for `python -m json.tool`
- More aliases:
    - `git` (language set to english)
    - `alert` (use like `sleep 10; alert` to notify you when the previous command (here `sleep 10`) has finished)
    - `l`
    - `ll`
    - `la`

### Git aliases

- `git s [ARGS...]`: Alias for `git status`.
- `git d [ARGS...]`: Like `git diff` but as minimal as possible. Perfect for an overview of all changes.
    ![git-d](img/git-d.png)
- `git l [ARGS...]`: Like `git log --graph` but with pretty and compact formatting.
    ![git-l](img/git-l.png)
- `git a [ARGS...]`: Auto-Log: Like `git l` but in reverse order and automatically updating after changes. That means if you run this command once in a terminal and pin it somewhere on the screen, you will always see the up-to-date git history there, starting with the youngest entry at the bottom of the terminal window.

# Recommended tools

```bash
# Graphical tools
sudo apt install gitk  # Git GUI
sudo apt install tilix  # Terminal emulator
sudo apt install atom  # text editor
sudo apt install speedcrunch  # calculator
sudo apt install gnome-tweak-tool  # extended GNOME configuration
sudo apt install dconf-editor  # advanced GNOME configuration

# Command-line tools
sudo apt install tree  # recursive directory listing
sudo apt install silversearcher-ag  # code-searching tool https://github.com/ggreer/the_silver_searcher
sudo apt install jq  # command-line JSON processor https://stedolan.github.io/jq/
sudo apt install cloc  # count lines of code
sudo apt install most  # alternative to `more`
sudo apt install mc  # Midnight Commander
sudo apt install recode  # example: `recode latin-1..utf-8 myfile.txt`
sudo apt install neofetch  # system information gathering

# Add-ons
sudo apt install git-lfs  # Git extension for versioning large files
```
