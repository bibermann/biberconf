#!/usr/bin/env bash

# requires stderred
#   https://github.com/ku1ik/stderred
if is_debian; then
  alias stderred="LD_PRELOAD=$HOME/.biberconf/thirdparty/stderred/build/libstderred.so\${LD_PRELOAD:+:\$LD_PRELOAD}"
elif is_arch; then
  alias stderred="LD_PRELOAD=/usr/lib/libstderred.so\${LD_PRELOAD:+:\$LD_PRELOAD}"
fi
