#!/usr/bin/env bash

force_terminal_colors="$1"

case "$TERM" in
    # The environment hints us that we should have a colored terminal
    xterm-color|*-256color) with_terminal_colors=yes;;
esac

if [ -z "$with_terminal_colors" ] && [ "$force_terminal_colors" = yes ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        with_terminal_colors=yes
    else
        with_terminal_colors=
    fi
fi

if [ "$with_terminal_colors" = yes ]; then
  color_auto_arg=' --color=auto'
else
  color_auto_arg=
fi

unset force_terminal_colors
