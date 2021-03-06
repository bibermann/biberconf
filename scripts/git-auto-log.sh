#!/usr/bin/env bash

set -euo pipefail

# requires entr
#   sudo apt install entr

root=$(git rev-parse --show-toplevel)
while true; do
    find "$root"/.git/{HEAD,refs/} | entr -cd ~/.biberconf/scripts/git-log-reversed-graph.sh "$@" || true
done
