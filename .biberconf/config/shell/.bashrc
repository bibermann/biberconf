# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

source ~/.biberconf/scripts/system.sh

# Argument:
# - "yes": Force using a colored prompt, if the terminal has the capability.
# - "no": Environment variable $TERM decides on using colors or not.
source ~/.biberconf/scripts/terminal-colors.sh "yes"

source ~/.biberconf/config/shell/bash.sh

source ~/.biberconf/config/ls.sh
source ~/.biberconf/config/dir.sh
source ~/.biberconf/config/grep.sh
source ~/.biberconf/config/less.sh
source ~/.biberconf/config/gcc.sh

source ~/.biberconf/config/open.sh
source ~/.biberconf/config/stderred.sh
source ~/.biberconf/config/alert.sh
source ~/.biberconf/config/ccat.sh

source ~/.biberconf/config/git/git.sh
source ~/.biberconf/config/shell/bash-git-prompt.sh
source ~/.biberconf/config/hstr.sh

source ~/.biberconf/config/pyenv.sh
source ~/.biberconf/config/direnv.sh

source ~/.biberconf/config/debian/upgrade.sh

unset with_terminal_colors  # set in scripts/terminal-colors.sh
unset color_auto_arg  # set in scripts/terminal-colors.sh
