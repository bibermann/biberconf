#!/usr/bin/env bash

#*************************
# Activate colored output
#*************************

if [ "$color_prompt" = yes ]; then
    # colored GCC warnings and errors
    #export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

    # enable color support of ls and also add handy aliases
    if [ -x /usr/bin/dircolors ]; then
        if test -r ~/.dircolors; then
            eval "$(dircolors -b ~/.dircolors)"
        else
            eval "$(dircolors -b)"
        fi

        alias ls='ls --color=auto'
        alias dir='dir --color=auto'
        alias vdir='vdir --color=auto'
    fi

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
