#!/usr/bin/env bash

#****************
# direnv support
#****************

if [ -x "$(command -v direnv)" ]; then
    eval "$(direnv hook bash)"
fi
