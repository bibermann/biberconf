#!/usr/bin/env bash

# requires stderred
#   https://github.com/sickill/stderred
alias stderred="LD_PRELOAD=$HOME/.biberconf/thirdparty/stderred/build/libstderred.so\${LD_PRELOAD:+:\$LD_PRELOAD}"
