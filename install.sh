#!/usr/bin/env bash

set -euo pipefail

grep -q '^\. "\$HOME/\.biberconf/config/profile"$' ~/.profile || echo -e '. "$HOME/.biberconf/config/profile.sh"\n' >> ~/.profile
