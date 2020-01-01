# Biberconf

Tools, tweaks and configs for a Bash command line environment.

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
./install.sh
```

## De-Installation

```bash
cd ~/.biberconf
./uninstall.sh
```

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
