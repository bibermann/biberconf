#!/usr/bin/env bash
set -euo pipefail

# This is a minimal script to clone Biberconf into your home directory.

#***************
# preconditions
#***************

if [ -d "$HOME/.biberconf" ]; then
  echo 1>&2 "Cannot install: '$HOME/.biberconf' already exists."
  exit 1
fi

if [ -d "$HOME/.git" ]; then
  echo 1>&2 "Cannot install: '$HOME' already is on version control."
  exit 1
fi

root_files=".github .gitignore .gitmodules"
for root_file in $root_files; do
  if [ -e "$HOME/$root_file" ]; then
    echo 1>&2 "Cannot install: '$HOME/$root_file' already exists."
    exit 1
  fi
done

cd "$HOME"

#***********************
# identify destribution
#***********************

is_debian() {
  [ -f "/etc/debian_version" ] ||
    grep -q -Ei 'debian|buntu|mint' /etc/issue ||
    grep -q -Ei '^ID(_LIKE)=.*(debian|buntu|mint)' /etc/*release ||
    grep -q -Ei '^ID(_LIKE)=.*(debian|buntu|mint)' /usr/lib/*release
}

is_arch() {
  [ -f /etc/arch-release ] ||
    grep -q -Ei 'arch' /etc/issue ||
    grep -q -Ei '^ID(_LIKE)=.*arch' /etc/*release ||
    grep -q -Ei '^ID(_LIKE)=.*arch' /usr/lib/*release
}

#**************
# requirements
#**************

if is_debian; then
  required_packages=(
    git
    git-lfs
  )

  not_installed_packages=()
  for package in "${required_packages[@]}"; do
    if ! dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep "^install ok installed$" &>/dev/null; then
      not_installed_packages+=("$package")
    fi
  done
  if [ ${#not_installed_packages[@]} -gt 0 ]; then
    echo "Installing required packages (${not_installed_packages[*]}), sudo required..."
    echo -n "Press [Enter] to continue. "
    read -r
    set -x
    sudo apt update
    sudo apt install -y "${not_installed_packages[@]}"
    set +x
  fi
elif is_arch; then
  required_packages=(
    extra/git
    extra/git-lfs
  )

  not_installed_packages=()
  for package in "${required_packages[@]}"; do
    if ! pacman -Qi "${package##*/}" &>/dev/null; then
      not_installed_packages+=("$package")
    fi
  done
  if [ ${#not_installed_packages[@]} -gt 0 ]; then
    echo "Installing required packages (${not_installed_packages[*]}), sudo required..."
    echo -n "Press [Enter] to continue. "
    read -r
    set -x
    sudo pacman --color auto -S "${not_installed_packages[@]}"
    set +x
  fi
else
  echo 1>&2 "Unsupported distribution or cannot identify distribution." \
    "Only Debian based and Arch based distributions are supported."
  exit 1
fi

#*******
# clone
#*******

MAIN_BRANCH="new-version"
git init -b "$MAIN_BRANCH"
git lfs install --local
git remote add origin https://github.com/bibermann/biberconf.git
git pull --set-upstream origin "$MAIN_BRANCH"

#*********
# install
#*********

source .biberconf/scripts/common.sh

echo_info "Biberconf cloned successfully."
echo "Running ~/.biberconf/install-or-update.sh to install..."
echo -n "Press [Enter] to continue. "
read -r

.biberconf/install-or-update.sh
