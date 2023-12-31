#!/usr/bin/env bash
set -euo pipefail

#**************
# common stuff
#**************

. scripts/system.sh
. scripts/common.sh

#***************
# preconditions
#***************

if [ "$(git rev-parse --show-toplevel)" != "$(realpath "$HOME/.biberconf")" ]; then
    exit_error "Cannot uninstall: This repo was moved away from '$HOME/.biberconf'."
fi
cd ~/.biberconf

#******
# HSTR
#******

cd thirdparty/hstr
echo_info "Uninstalling HSTR, sudo required..."
set -x
sudo make uninstall
if [ -f /usr/local/bin/hh ]; then sudo rm /usr/local/bin/hh; fi
set +x
cd ../..

#***********
# biberconf
#***********

sed -i '\#^\. "\$HOME/.biberconf/config/shell/.profile"$#d' ~/.profile

for i in "${!links[@]}"; do
    link="${links[$i]}"
    backup="${backups[$i]}"
    if [ -L "$link" ]; then
        rm "$link"
    fi
    if ! [ -f "$link" ] && [ -f "user-backup/$backup" ]; then
        cp -a "user-backup/$backup" "$link"
    fi
done

current_branch="$(git rev-parse --abbrev-ref HEAD)"
if [ "$current_branch" = "$default_user_branch" ]; then
    read_reply "Should I remove your '$default_user_branch' branch? [y|n]"
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git checkout main
        git branch -D $default_user_branch
    fi
fi

echo_success "Uninstallation successfull." \
             "You should restart your terminal now or at least call 'source ~/.bashrc'."
