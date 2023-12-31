#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
cd "$(git rev-parse --show-toplevel)"

#**************
# common stuff
#**************

source .biberconf/scripts/system.sh
source .biberconf/scripts/common.sh

#***************
# preconditions
#***************

if [ "$PWD" != "$(realpath "$HOME")" ]; then
  exit_error "Cannot uninstall: This repo was moved away from '$HOME'."
fi

#******
# HSTR
#******

cd .biberconf/thirdparty/hstr
read_reply "Uninstalling HSTR, sudo required..." \
 "Press [Enter] to continue."
if is_debian; then
  set -x
  sudo make uninstall
  if [ -f /usr/local/bin/hh ]; then sudo rm /usr/local/bin/hh; fi
  set +x
elif is_arch; then
  # set -x
  # sudo pacman -Rs hstr
  # set +x
  # TODO: When we use makepkg in update.sh, we need to do sth. like above.
  set -x
  sudo make uninstall
  if [ -f /usr/local/bin/hh ]; then sudo rm /usr/local/bin/hh; fi
  set +x
fi
cd ../../..

#***********
# dot files
#***********

# .bashrc
for bashrc_file in .bashrc .bashrc-personal; do
  if [ -f "$bashrc_file" ]; then
    sed -i '\#^source "\$HOME/.biberconf/config/shell/.bashrc"$#d' "$bashrc_file"
    if ! [ -s "$bashrc_file" ]; then
      rm "$bashrc_file"
    fi
  fi
done

# .profile
for profile_file in .profile .profile-personal; do
  if [ -f "$profile_file" ]; then
    sed -i '\#^source "\$HOME/.biberconf/config/shell/.profile"$#d' "$profile_file"
    if ! [ -s "$profile_file" ]; then
      rm "$profile_file"
    fi
  fi
done

# .gitconfig
for gitconfig_file in .gitconfig .config/git/config; do
  if [ -f "$gitconfig_file" ]; then
    perl -i -0777 -pe 's#(?<=^|\n)\[include\]\n\s*path\s*=\s*~/\.biberconf/config/git/\.gitconfig(?=$|\n)\n?##gs' "$gitconfig_file"
    if ! [ -s "$gitconfig_file" ]; then
      rm "$gitconfig_file"
    fi
  fi
done

# .vimrc
if [ -f .vimrc ]; then
  sed -i '\#^source ~/.biberconf/config/.vimrc$#d' .vimrc
  if ! [ -s .vimrc ]; then
    rm .vimrc
  fi
fi

#**********
# finalize
#**********

root_git_objects="$(git ls-tree --name-only "origin/$MAIN_BRANCH" | tr '\n' ',' | sed 's/,$//')"
echo_success "Uninstallation successfull." \
  "In a new terminal, you may 'rm -rf $HOME/{.git,$root_git_objects,.hstr_histories}'." \
  "You should restart your terminal now."
