#****************************
# Bash aliases and functions
#****************************

#alias ll='ls -l'
#alias l='ls -lA'
alias ll='ls -alF'
alias l='ls -CF'
alias la='ls -A'

alias grep='grep -n'
alias fgrep='fgrep -n'
alias egrep='egrep -n'

alias git='LANGUAGE=en_US.UTF-8 git'
alias prettyjson='python -m json.tool'

# requires stderred
#   https://github.com/sickill/stderred
alias stderred="LD_PRELOAD=$HOME/.biberconf/thirdparty/stderred/build/libstderred.so\${LD_PRELOAD:+:\$LD_PRELOAD}"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

__ccat_test_themes() {
    local sample="$1"; shift
    clear; for theme in "$@"; do echo -e "\n\033[1;37m$theme\033[0m"; highlight -O xterm256 -s $theme -- $sample; done
}

_ccat_test_all_themes() {
    local sample="${1-$HOME/.biberconf/samples/fibonacci.py}"
    __ccat_test_themes $sample $(for f in $(cd /usr/share/highlight/themes; ls *); do echo ${f%.*}; done)
}

_ccat_test_selected_themes() {
    local sample="${1-$HOME/.biberconf/samples/fibonacci.py}"
    __ccat_test_themes $sample andes bluegreen dante darkslategray denim edit-godot edit-vim-dark ekvoli leo lucretia moria nightshimmer orion pablo zmrok
}

ccat() {
    # requires highlight
    #   sudo apt install highlight
    for f in "$@"; do
        # print filename (if we have to print multiple files)
        if [[ $# -ne 1 ]]; then echo -e "\033[1;37m$f\033[0m"; fi
        # print file contents with syntax highlighting
        highlight -O xterm256 --force -s "$CCAT_THEME" -- "$f"
    done
}

pss() {
    # requires pss
    #   https://github.com/eliben/pss
    local cmd=()
    for i in $PSS_IGNORE; do cmd+=(--ignore-dir "$i"); done
    python3 ~/.biberconf/thirdparty/pss "${cmd[@]}" "$@"
}

#****************
# personal stuff
#****************

. ~/.biberconf/config/pss_ignore.sh
. ~/.biberconf/pss_ignore.sh

. ~/.biberconf/config/ccat_theme.sh
. ~/.biberconf/ccat_theme.sh

. ~/.biberconf/bash_aliases.sh
