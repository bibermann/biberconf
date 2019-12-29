#!/usr/bin/env bash

set -euo pipefail

#*************
# self-update
#*************

git pull
git submodule sync
git submodule update --init

#******
# HSTR
#******

cd thirdparty/hstr
cd build/tarball
./tarball-automake.sh
cd ../..
./configure
make
set -x
if [ -f /usr/local/bin/hh ]; then sudo rm /usr/local/bin/hh; fi
sudo make install
set +x
cd ../..

#**********
# stderred
#**********

cd thirdparty/stderred
make
cd ../..

#***********
# biberconf
#***********

grep -q '^\. "\$HOME/\.biberconf/config/profile"$' ~/.profile || echo -e '. "$HOME/.biberconf/config/profile.sh"\n' >> ~/.profile
