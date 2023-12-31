#!/usr/bin/env bash

if [ "$with_terminal_colors" = yes ]; then
    # enable color support of `ls`
    if [ -x /usr/bin/dircolors ]; then
        if test -r ~/.dircolors; then
            eval "$(dircolors -b ~/.dircolors)"
        else
            eval "$(dircolors -b)"
        fi
    fi
fi

#alias ll="ls$color_auto_arg -l"
#alias l="ls$color_auto_arg -lA"
alias ll="ls$color_auto_arg -alF"
alias l="ls$color_auto_arg -CF"
alias la="ls$color_auto_arg -A"
