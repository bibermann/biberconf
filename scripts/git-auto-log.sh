#!/usr/bin/env bash

set -euo pipefail

# requires entr
#   sudo apt install entr

while true; do
    find `git rev-parse --show-toplevel`/.git/{HEAD,refs/} | entr -cd ~/.biberconf/scripts/git-log-reversed-graph.sh "$@"
done
