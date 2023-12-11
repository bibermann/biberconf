#!/usr/bin/env bash

_this_script_dir() {
    # https://stackoverflow.com/a/246128/704821

    local SOURCE="${BASH_SOURCE[0]}"
    while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
        local DIR; DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
        local SOURCE; SOURCE="$(readlink "$SOURCE")"
        [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    local DIR; DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
    echo "$DIR"
}
