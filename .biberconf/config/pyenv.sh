#!/usr/bin/env bash

#***************
# pyenv support
#***************

if [ -d ~/.pyenv/bin ]; then
    export PATH="$HOME/.pyenv/bin:$PATH"
fi

if [ -x "$(command -v pyenv)" ]; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi