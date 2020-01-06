#***********************
# history configuration
#***********************

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth  # ignorespace # ignoreboth # ignoredups:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# disable XON/XOFF flow control to free C-q and C-s
stty -ixon

hstr_sessions_root=/dev/shm/hstr_sessions
hstr_histories_root=~/.hstr_histories
mkdir -p $hstr_sessions_root
hstr_session_file=$(mktemp -p $hstr_sessions_root)
hstr_history_file=~/.hstr_histories/$(date -u +%Y-%m-%d_%H-%M-%S)_$BASHPID
cat ~/.hstr_histories/* > $hstr_session_file
export HISTTIMEFORMAT='%F %T '
HISTORY_LAST_COMMAND=
HISTORY_IS_FIRST_COMMAND=1
on_save_last_command() {
    if [[ "$HISTORY_IS_FIRST_COMMAND" == "1" ]]; then
        HISTORY_IS_FIRST_COMMAND=0
        HISTORY_LAST_COMMAND=$(HISTTIMEFORMAT="" history 1 | sed 's/^ *[0-9]* *//')
        return
    fi
    local cmd=$(HISTTIMEFORMAT="" history 1 | sed 's/^ *[0-9]* *//')
    if [[ $cmd == $HISTORY_LAST_COMMAND ]] || [[ -z $cmd ]]; then
        return
    fi
    HISTORY_LAST_COMMAND="$cmd"
    local date_string=$(date +%s)
    echo "#$date_string" >> $hstr_history_file
    echo "#$date_string" >> $hstr_session_file
    echo "$cmd" >> $hstr_history_file
    echo "$cmd" >> $hstr_session_file
}
on_bash_exit() {
    rm $hstr_session_file
}
trap on_bash_exit EXIT

on_ctrl_c_for_hstr() {
    :
}

run_hstr() {
    if [[ "$1" != "-r" ]]; then
        local HSTR_CONFIG=$HSTR_CONFIG,raw-history-view
    else
        shift
    fi
    if [[ "$1" != "-f" ]]; then
        local separator=--
    else
        local separator=
    fi
    local offset=${READLINE_POINT}
    trap on_ctrl_c_for_hstr INT
    { READLINE_LINE=$(</dev/tty HISTFILE="$hstr_session_file" HSTR_CONFIG="$HSTR_CONFIG" HSTR_IS_SUBSHELL=1 hstr "$@" $separator ${READLINE_LINE:0:offset} 2>&1 1>&$hstrout); } {hstrout}>&1
    trap - INT
    exec {hstrout}>&-
}

export HSTR_CONFIG=hicolor,prompt-bottom,help-on-opposite-side,hide-basic-help,blacklist
#if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a HISTFILE='$hstr_session_file' hstr -- \C-j"'; fi
if [[ $- =~ .*i.* ]]; then bind -x '"\C-s": "run_hstr"'; fi
#if [[ $- =~ .*i.* ]]; then bind '"\C-xk": "\C-a hstr -k \C-j"'; fi

if [[ $- =~ .*i.* ]]; then bind -x '"\C-r": "run_hstr -r"'; fi
if [[ $- =~ .*i.* ]]; then bind -x '"\C-f": "run_hstr -f"'; fi
export HSTR_PROMPT="      $ "
