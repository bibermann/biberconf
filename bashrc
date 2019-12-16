# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

#****************
# optional stuff
#****************

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

#********************************************
# general stuff you would not want to change
#********************************************

if [ -f ~/.settings/bash_general.sh ]; then
    . ~/.settings/bash_general.sh
fi

#****************
# personal stuff
#****************

if [ -f ~/.settings/bash_personal.sh ]; then
    . ~/.settings/bash_personal.sh
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/bibermann/.miniconda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/bibermann/.miniconda/etc/profile.d/conda.sh" ]; then
        . "/home/bibermann/.miniconda/etc/profile.d/conda.sh"
    else
        export PATH="/home/bibermann/.miniconda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
