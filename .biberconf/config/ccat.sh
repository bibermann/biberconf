#!/usr/bin/env bash

# bluegreen, ekvoli, zmrok, ...
# Run `_ccat_test_selected_themes` or `_ccat_test_all_themes` to see previews.
# Default: zmrok
CCAT_THEME="zmrok"

# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37
# Default: 1;31
CCAT_FILENAME_COLOR="1;31"

__ccat_test_themes() {
    local sample; sample="$1"
    shift
    clear
    local theme
    for theme in "$@"; do
        echo -e "\n\033[1;37m$theme\033[0m"
        highlight -O xterm256 -s "$theme" -- "$sample"
    done
}

_ccat_test_all_themes() {
    local sample="${1-$HOME/.biberconf/samples/fibonacci.py}"
    __ccat_test_themes "$sample" $(for f in $(cd /usr/share/highlight/themes; ls -- *); do echo "${f%.*}"; done)
}

_ccat_test_selected_themes() {
    local sample="${1-$HOME/.biberconf/samples/fibonacci.py}"
    # __ccat_test_themes $sample andes bluegreen dante darkslategray denim edit-godot edit-vim-dark ekvoli leo lucretia moria nightshimmer orion pablo zmrok
    __ccat_test_themes "$sample" andes bluegreen denim ekvoli leo lucretia moria orion pablo zmrok
}

ccat() {
    # requires highlight
    #   sudo apt install highlight
    for f in "$@"; do
        # print filename (if we have to print multiple files)
        if [ $# -ne 1 ]; then echo -e "\033[${CCAT_FILENAME_COLOR}m$f\033[0m"; fi
        # print file contents with syntax highlighting
        highlight -O xterm256 --force -s "$CCAT_THEME" -- "$f"
    done
}
