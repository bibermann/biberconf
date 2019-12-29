#!/usr/bin/env bash

set -euo pipefail

#***********
# biberconf
#***********

sed -i '\#^\. "\$HOME/.biberconf/config/profile"$#d' ~/.profile

#******
# HSTR
#******

cd thirdparty/hstr
set -x
sudo make uninstall
if [ -f /usr/local/bin/hh ]; then sudo rm /usr/local/bin/hh; fi
set +x
cd ../..
