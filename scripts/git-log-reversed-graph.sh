#!/usr/bin/env bash

set -euo pipefail

dummy_sep="!sep!"
dummy_forward_slash="!fs!"

log=$( \
    git log --graph --abbrev-commit --decorate \
        --format=format:"%C(yellow)%h%C(reset)$dummy_sep %C(white)%s%C(reset) %C(dim white)%an%C(reset) %C(yellow)%ar%C(reset)%C(auto)%d%C(reset)" \
        --color=always -n $(tput lines) "$@" \
    )
# `tac` seems to need a newline at the end to not mix the last lines, that's why we echo the git log output (which completes with a newline).
log=$( \
    echo -e "$log" | tac \
    )
echo -en "$log" \
    | sed -Ee ":a s#^([^!]*)/#\\1$dummy_forward_slash#; t a" \
    | sed -Ee ":a s#^([^!]*)\\\\#\\1/#; t a" \
    | sed -Ee "s#$dummy_forward_slash#\\\\#g" \
    | sed -Ee "s#$dummy_sep##g"
