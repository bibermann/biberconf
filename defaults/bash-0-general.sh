#********************************************
# general stuff you would not want to change
#********************************************

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

case "$TERM" in
    # The environment hints us that we should have a colored terminal
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ -z "$color_prompt" ] && [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi
unset force_color_prompt

. ~/.biberconf/defaults/bash-1-coloring.sh
. ~/.biberconf/defaults/bash-2-completion.sh
. ~/.biberconf/defaults/bash-3-history.sh
. ~/.biberconf/defaults/bash-4-prompt.sh
. ~/.biberconf/defaults/bash-5-aliases.sh

unset color_prompt

#***************
# pyenv support
#***************

if [[ -d ~/.pyenv/bin ]]; then
    export PATH="$HOME/.pyenv/bin:$PATH"
fi

if [ -x "$(command -v pyenv)" ]; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

#****************
# direnv support
#****************

if [ -x "$(command -v direnv)" ]; then
    eval "$(direnv hook bash)"
fi
