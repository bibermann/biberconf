#!/usr/bin/env bash

set -euo pipefail

sed -i '\#^\. "\$HOME/.biberconf/config/profile"$#d' ~/.profile
