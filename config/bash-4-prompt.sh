#*************
# default PS1
#*************

# # set variable identifying the chroot you work in (used in the prompt below)
# if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
#     debian_chroot=$(cat /etc/debian_chroot)
# fi
#
# if [ "$color_prompt" = yes ]; then
#     PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# else
#     PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
# fi
#
# # If this is an xterm set the title to user@host:dir
# case "$TERM" in
#     xterm*|rxvt*) PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1";;
# esac

#************
# Git prompt
#************

# https://gnunn1.github.io/tilix-web/manual/vteconfig/
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
    source /etc/profile.d/vte.sh
fi

# sets window title
export PROMPT_COMMAND='echo -ne "\033]0;${PWD/#$HOME/\~}\007$(__vte_osc7)"; on_save_last_command'

# requires bash-git-prompt
#   https://github.com/magicmonty/bash-git-prompt
GIT_PROMPT_ONLY_IN_REPO=0
GIT_PROMPT_THEME=Custom
GIT_PROMPT_THEME_FILE=~/.biberconf/config/git-prompt-colors.sh
GIT_PROMPT_FETCH_REMOTE_STATUS=0
GIT_PROMPT_SHOW_UPSTREAM=0
GIT_PROMPT_VIRTUAL_ENV_AFTER_PROMPT=1
source ~/.biberconf/thirdparty/bash-git-prompt/gitprompt.sh
