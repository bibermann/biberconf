# Biberconf

Tools, tweaks and configs for a Bash command line environment.

Biberconf includes:
- [bash-git-prompt: An informative and fancy bash prompt for Git users](https://github.com/magicmonty/bash-git-prompt) (slightly modified version)
- [HSTR: Easily view, navigate and search your command history](https://github.com/dvorka/hstr) (slightly modified version)
- [pss: A power-tool for searching inside source code files](https://github.com/eliben/pss)
- [stderred: stderr in red](https://github.com/sickill/stderred)
- Recommended settings for Git, Vim, and the tools listed above
- Some useful Bash and Git aliases/scripts

Biberconf sets all your custom configurations into version-control.

## Requirements

Tested on Ubuntu.

```bash
sudo apt install vim meld kdiff3
sudo apt install highlight # for `ccat`
sudo apt install build-essential cmake # for `stderred`
sudo apt install automake gcc make libncursesw5-dev libreadline-dev # for `hstr`
```

## Installation

```bash
git clone https://github.com/bibermann/biberconf.git ~/.biberconf
cd ~/.biberconf
./install_or_update.sh
```

## Update

The script fetches the latest changes, installs them and rebases your `custom` branch.

```bash
cd ~/.biberconf
./install_or_update.sh
```

## Deinstallation

```bash
cd ~/.biberconf
./uninstall.sh
```

## Features

### Terminal prompt

![terminal-prompt](img/terminal-prompt.png)

Legend:

```bash
#    ,------------------------------------ signal name or exit code from last command
#   |                  ,------------------ current virtual environment
#   |                 |       ,----------- current Git branch
#   |                 |      |       ,---- remote Git status
#   |                 |      |      |   ,- local Git status
#   |                 |      |      |  |
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
- `[Ctrl] + [r]`: Start HSTR in "favorites view" mode.

### Available commands

- `ccat FILE [FILES...]`: Prints the file(s) with syntax highlighting.
    - Change theme in `ccat_theme.sh`.
        - Present favorite themes: `_ccat_test_selected_themes [TEST_FILE]`
        - Present all themes: `_ccat_test_all_themes [TEST_FILE]`
- `stderred COMMAND`: Executes the command, highlighting all output to stderr with red.
- `pss ARGS...`: Runs `pss` ignoring directories listed in `pss_ignore.sh`.
- `prettyjson`: Shortcut for `python -m json.tool`
- More aliases:
    - `git` (language set to english)
    - `alert` (see `config/bash-5-aliases.sh`)
    - `l`
    - `ll`
    - `la`

### Git aliases

- `git df [ARGS...]`: Like `git diff` but as minimal as possible. Perfect for an overview of all changes.
    ![git-df](img/git-df.png)
- `git lg [ARGS...]`: Like `git log --graph` but with pretty and compact formatting.
    ![git-lg](img/git-lg.png)
- `git alg [ARGS...]`: Auto-Log: Like `git lg` but in reverse order and automatically updating after changes. That means if you run this command once in a terminal and pin it somewhere on the screen, you will always see the up-to-date git history there, starting with the youngest entry at the bottom of the terminal window.

# Recommended tools

```bash
# Graphical tools
sudo apt install gitk # Git GUI
sudo apt install tilix # Terminal emulator
sudo apt install atom # text editor
sudo apt install speedcrunch # calculator
sudo apt install gnome-tweak-tool # extended GNOME configuration
sudo apt install dconf-editor # sophisticated GNOME configuration

# Command-line tools
sudo apt install tree # recursive directory listing
sudo apt install silversearcher-ag # code-searching tool https://github.com/ggreer/the_silver_searcher
sudo apt install jq # command-line JSON processor https://stedolan.github.io/jq/
sudo apt install cloc # count lines of code
sudo apt install most # alternative to `more`
sudo apt install mc # Midnight Commander
sudo apt install recode # example: `recode latin-1..utf-8 myfile.txt`
sudo apt install neofetch # system information gathering

# Add-ons
sudo apt install git-lfs # Git extension for versioning large files
```
