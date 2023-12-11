#!/usr/bin/env bash
set -euo pipefail

if [ $# -gt 0 ]; then
    seconds=$1
    shift
else
    seconds=5
fi

while true; do
    clear
    git --no-optional-locks status "$@"
    sleep "$seconds"
done
