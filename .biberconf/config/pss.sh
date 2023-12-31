#!/usr/bin/env bash

pss() {
    # requires pss
    #   https://github.com/eliben/pss
    local cmd; cmd=()
    local i
    for i in $PSS_IGNORE; do cmd+=(--ignore-dir "$i"); done
    python3 ~/.biberconf/thirdparty/pss "${cmd[@]}" "$@"
}

PSS_IGNORE="node_modules dist"