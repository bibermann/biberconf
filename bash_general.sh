#********************************************
# general stuff you would not want to change
#********************************************

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

case "$TERM" in
    # The environment hints we should have a colored terminal
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

if [ -f ~/.settings/bash_coloring.sh ]; then
    . ~/.settings/bash_coloring.sh
fi

if [ -f ~/.settings/bash_completion.sh ]; then
    . ~/.settings/bash_completion.sh
fi

if [ -f ~/.settings/bash_history.sh ]; then
    . ~/.settings/bash_history.sh
fi

if [ -f ~/.settings/bash_prompt.sh ]; then
    . ~/.settings/bash_prompt.sh
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

unset color_prompt

if [[ -d ~/.pyenv/bin ]]; then
    export PATH="/home/bibermann/.pyenv/bin:$PATH"
fi
if [ -x "$(command -v pyenv)" ]; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

if [ -x "$(command -v direnv)" ]; then
    eval "$(direnv hook bash)"
fi
