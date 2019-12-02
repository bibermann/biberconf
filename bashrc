# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth  # ignorespace # ignoreboth # ignoredups:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# fineshift

# https://gnunn1.github.io/tilix-web/manual/vteconfig/
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
    source /etc/profile.d/vte.sh
fi

# sets window title
export PROMPT_COMMAND='echo -ne "\033]0;${PWD/#$HOME/\~}\007$(__vte_osc7)"; on_save_last_command'

GIT_PROMPT_ONLY_IN_REPO=0
GIT_PROMPT_THEME=Custom
GIT_PROMPT_THEME_FILE=~/.settings/git-prompt-colors.sh
GIT_PROMPT_FETCH_REMOTE_STATUS=0
GIT_PROMPT_SHOW_UPSTREAM=0
GIT_PROMPT_VIRTUAL_ENV_AFTER_PROMPT=1
source ~/tools/bash-git-prompt/gitprompt.sh

#source ~/tools/git-prompt.sh
#export GIT_PS1_SHOWCOLORHINTS=true
#export GIT_PS1_SHOWDIRTYSTATE=true
#export GIT_PS1_SHOWUNTRACKEDFILES=true
#export GIT_PS1_SHOWUPSTREAM="auto"

##PS1='\[\e[1;30m\]${debian_chroot:+($debian_chroot)}\u@\h:\[\e[m\]\w\[\e[1;30m\] $(__git_ps1)\[\e[m\]\[\e[1;31m\]\$\[\e[m\] '
#PS1_cdark='\[\e[0;30m\]'
#PS1_clight='\[\e[1;30m\]'
#PS1_cend='\[\e[m\]'
#PS1_user='${debian_chroot:+($debian_chroot)}\u@\h'
#PS1_path='\w'
#PS1_conda='$(basename "$CONDA_PREFIX")'
#PS1_prompt='\[\e[1;31m\]\$\[\e[m\]'
#function prompt_command {
#    PS1_git=`__git_ps1`
#
#    PS1=''
#    if ! [ -z "$PS1_conda" ]; then
#        if ! [ -z "$PS1" ]; then PS1+=' '; fi
#        PS1+="($PS1_clight$PS1_conda$PS1_cend)"
#    fi
#    if ! [ -z "$PS1_git" ]; then
#        if ! [ -z "$PS1" ]; then PS1+=' '; fi
#        PS1+="($PS1_git)"
#    fi
#    if ! [ -z "$PS1" ]; then PS1+=' '; fi
#    PS1+="$PS1_path $PS1_cdark$PS1_user$PS1_cend\n$PS1_prompt"
#
#    export PS1=$PS1
#}
##export PROMPT_COMMAND=prompt_command
##export PROMPT_COMMAND='__git_ps1 "\w" "\n\\\$ "'

# auto completion for git aliases (see ~/.gitconfig)
_git_df ()
{
  __gitcomp_nl "$(__git_refs)"
}

export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'

export PATH="$PATH:$HOME/tools/dircmp:$HOME/tools/bin"

export SUPERTOLL_ROOT="$HOME/amb/supertoll/tc-supertoll"
export SUPERTOLL_BINARY_DIR="$SUPERTOLL_ROOT/build-release/bin"
export PYTHONPATH="$SUPERTOLL_ROOT/Tools/Python:$SUPERTOLL_ROOT/Applications/ZE/Tools/Manager:$PYTHONPATH"
export PATH="$PATH:$SUPERTOLL_BINARY_DIR:$SUPERTOLL_ROOT/Tools:$SUPERTOLL_BINARY_DIR:$SUPERTOLL_ROOT/Applications/ZE/Tools/Manager"

alias git='LANGUAGE=en_US.UTF-8 git'
#alias stderred="LD_PRELOAD=$HOME/tools/stderred/build/libstderred.so\${LD_PRELOAD:+:\$LD_PRELOAD}"
alias cls='echo -en "\ec"'
alias prettyjson='python -m json.tool'

export PATH=/usr/local/texlive/2017/bin/x86_64-linux:$PATH
export INFOPATH=$INFOPATH:/usr/local/texlive/2017/texmf-dist/doc/info
export MANPATH=$MANPATH:/usr/local/texlive/2017/texmf-dist/doc/man
export STREETMATCHER_HOME=/home/bibermann/amb/streetmatcher

#export ORACLE_HOME="/u01/app/oracle/product/11.2.0/xe"
export ORACLE_HOME="$STREETMATCHER_HOME/oracle/xe"

# Add $ORACLE_HOME/lib to library search path.
# NOTE: We need to add /lib/x86_64-linux-gnu before or export LD_PRELOAD=/lib/x86_64-linux-gnu/libexpat.so
#  because the problem is we get f.ex. when executing vim: symbol lookup error: /usr/lib/x86_64-linux-gnu/libpython3.6m.so.1.0: undefined symbol: XML_SetHashSalt
#  because with ldd we see libexpat.so.1 is choosen from /home/bibermann/amb/streetmatcher/oracle/xe/lib/libexpat.so.1
#  because LD_LIBRARY_PATH has a higher priority as system paths
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/lib/x86_64-linux-gnu:$ORACLE_HOME/lib

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
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

export PATH="/home/bibermann/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

eval "$(direnv hook bash)"

# HSTR configuration

stty stop ''

hstr_sessions_root=/dev/shm/hstr_sessions
hstr_histories_root=~/.hstr_histories
mkdir -p $hstr_sessions_root
hstr_session_file=$(mktemp -p $hstr_sessions_root)
hstr_history_file=~/.hstr_histories/$(date -u +%Y-%m-%d_%H-%M-%S)_$BASHPID
cat ~/.hstr_histories/* > $hstr_session_file
export HISTTIMEFORMAT='%F %T '
last_command=
is_first_command=1
on_save_last_command() {
    if [[ "$is_first_command" == "1" ]]; then
        is_first_command=0
        last_command=$(HISTTIMEFORMAT="" history 1 | sed 's/^ *[0-9]* *//')
        return
    fi
    command=$(HISTTIMEFORMAT="" history 1 | sed 's/^ *[0-9]* *//')
    if [[ $command == $last_command ]] || [[ -z $command ]]; then
        return
    fi
    last_command=$command
    date_string=$(date +%s)
    echo "#$date_string" >> $hstr_history_file
    echo "#$date_string" >> $hstr_session_file
    echo "$command" >> $hstr_history_file
    echo "$command" >> $hstr_session_file
}
on_bash_exit() {
    rm $hstr_session_file
}
trap on_bash_exit EXIT

export HSTR_CONFIG=hicolor,raw-history-view
if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a HISTFILE='$hstr_session_file' hstr -- \C-j"'; fi
#if [[ $- =~ .*i.* ]]; then bind '"\C-xk": "\C-a hstr -k \C-j"'; fi

if [[ $- =~ .*i.* ]]; then bind '"\C-s": "\C-a HISTFILE='$hstr_session_file' hstr -f -- \C-j"'; fi
export HSTR_PROMPT="      $ "
