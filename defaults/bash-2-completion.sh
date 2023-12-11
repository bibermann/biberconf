#!/usr/bin/env bash

#******************
# Bash completions
#******************

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash_completion/bash_completion ]; then
    . /usr/share/bash_completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# auto completion for git aliases (see ~/.biberconf/defaults/gitconfig)
_git_lg()
{
  __gitcomp_nl "$(__git_refs)"
}
_git_alg()
{
  __gitcomp_nl "$(__git_refs)"
}
_git_df()
{
  __gitcomp_nl "$(__git_refs)"
}

#****************
# personal stuff
#****************

. ~/.biberconf/bash_completion.sh
