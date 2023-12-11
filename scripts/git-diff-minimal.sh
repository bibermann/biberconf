#!/usr/bin/env bash
set -euo pipefail

ESC=$(echo -e "\033")
git diff --minimal -U0 --color-words "$@" | { grep -vP "^$ESC\[(1m(?!---)|36m)" || true; } | sed -Ee "s#^$ESC\[1m--- a/#$ESC\[1;37m#g"
