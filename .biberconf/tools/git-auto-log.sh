#!/usr/bin/env bash
set -euo pipefail

# requires entr
#   sudo apt install entr

export GIT_OPTIONAL_LOCKS=0

root=$(git rev-parse --show-toplevel)
while true; do
    find "$root"/.git/{HEAD,refs/} | entr -cd ~/.biberconf/tools/git-log-reversed-graph.sh "$@" || true
done
