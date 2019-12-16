#****************************
# Bash aliases and functions
#****************************

#alias ll='ls -l'
#alias l='ls -lA'
alias ll='ls -alF'
alias l='ls -CF'
alias la='ls -A'

alias git='LANGUAGE=en_US.UTF-8 git'
alias cls='echo -en "\ec"'
alias prettyjson='python -m json.tool'

alias stderred="LD_PRELOAD=$HOME/tools/stderred/build/libstderred.so\${LD_PRELOAD:+:\$LD_PRELOAD}"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Note: requires alias for "git lg" in your .gitconfig
# TODO: make "14" configurable by argument
alias auto-git-log='while true; do find `git rev-parse --show-toplevel`/.git/{HEAD,refs/} | entr -cd git lg -n14; done'

__this_script_dir() {
    # https://stackoverflow.com/a/246128/704821

    local SOURCE="${BASH_SOURCE[0]}"
    while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
        local DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
        local SOURCE="$(readlink "$SOURCE")"
        [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    local DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
    echo $DIR
}

__ccat_test_themes() {
    local sample="$1"; shift
    clear; for theme in "$@"; do echo -e "\n\033[1;37m$theme\033[0m"; highlight -O xterm256 -s $theme -- $sample; done
}

_ccat_test_all_themes() {
    local sample="${1-$(__this_script_dir)/samples/fibonacci.py}"
    __ccat_test_themes $sample $(for f in $(cd /usr/share/highlight/themes; ls *); do echo ${f%.*}; done)
}

_ccat_test_selected_themes() {
    local sample="${1-$(__this_script_dir)/samples/fibonacci.py}"
    __ccat_test_themes $sample andes bluegreen dante darkslategray denim edit-godot edit-vim-dark ekvoli leo lucretia moria nightshimmer orion pablo zmrok
}

ccat() {
    # requires highlight
    #   sudo apt install highlight
    local theme="ekvoli"

    for f in "$@"; do
        # print filename (if we have to print multiple files)
        if [[ $# -ne 1 ]]; then echo -e "\033[1;37m$f\033[0m"; fi
        # print file contents with syntax highlighting
        highlight -O xterm256 --force -s "$theme" -- "$f"
    done
}

pss() {
    # requires pss
    #   https://github.com/eliben/pss
    local ignore="node_modules dist"

    local cmd=()
    for i in ignore; do cmd+=(--ignore-dir "$i"); done
    python3 ~/tools/pss "${cmd[@]}" "$@"
}
