#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
cd "$(git rev-parse --show-toplevel)"

#**************
# common stuff
#**************

source .biberconf/scripts/system.sh
source .biberconf/scripts/common.sh
MERGE_BASE_FILE=.biberconf/.MERGE_BASE

#***************
# preconditions
#***************

if [ "$PWD" != "$(realpath "$HOME")" ]; then
  exit_error "Cannot install: This repo must be pulled into '$HOME'."
fi

#************
# git config
#************

user_name="$(git config --default '' user.name)"
user_email="$(git config --default '' user.email)"

if [ -z "$user_name" ] || [ -z "$user_email" ]; then
  echo_info "You need to identify yourself for Git commits."
fi
if [ -z "$user_name" ]; then
  read -rp 'Full name:     '
  git config --global user.name "$REPLY"
fi
if [ -z "$user_email" ]; then
  read -rp 'Email address: '
  git config --global user.email "$REPLY"
fi

#************
# git status
#************

if output="$(git status --untracked-files=no --porcelain)" && [ -z "$output" ]; then
  :
else
  git status
  exit_error "Cannot install: Your working directory is not clean (see above)."
fi

#*************
# self-update
#*************

show_log() {
  if [ -f "$MERGE_BASE_FILE" ]; then
    read -r merge_base <"$MERGE_BASE_FILE"
    if [ -n "$merge_base" ] && [ "$merge_base" != "$(git rev-parse "origin/$MAIN_BRANCH")" ]; then
      echo_info "Changelog:" \
        "$(git log "$merge_base..origin/$MAIN_BRANCH" --pretty='format:•biberconf• %B' --reverse | sed '/^\s*$/d' | sed -E 's/^([^•])/  \1/' | sed 's/•biberconf•/•/')"
    fi
  fi
}

self_update() {
  local current_commit
  current_commit="$(git rev-parse HEAD)"
  local current_branch
  current_branch="$(git rev-parse --abbrev-ref HEAD)"
  if git show-ref --verify --quiet "refs/heads/$DEFAULT_USER_BRANCH"; then
    # at least the default user branch exists
    if [ "$current_branch" = "$MAIN_BRANCH" ]; then
      exit_error "Cannot install: Expecting you are on a user-defined branch like '$DEFAULT_USER_BRANCH'."
    fi

    # we are on a user-defined branch

    git fetch origin
    merge_base="$(git merge-base "$MAIN_BRANCH" "origin/$MAIN_BRANCH")"
    if ! [ -f "$MERGE_BASE_FILE" ]; then
      echo "$merge_base" >"$MERGE_BASE_FILE"
    fi
    if [ "$merge_base" != "$(git rev-parse "$MAIN_BRANCH")" ]; then
      if ! git rebase -r --onto "$merge_base" "$MAIN_BRANCH"; then
        git rebase --abort || true
        show_log
        exit_error "Could not rebase." \
          "Please manually remove the commits from (but not including) $merge_base until (including) $MAIN_BRANCH, resolve the conflicts and try again."
      fi
    fi
    if ! git rebase "origin/$MAIN_BRANCH"; then
      git rebase --abort || true
      show_log
      exit_error "Could not rebase." \
        "Please manually run 'git rebase origin/$MAIN_BRANCH', resolve the conflicts (with 'git mergetool --tool=kdiff3' or 'git mergetool --tool=vimdiff') and try again."
    fi
    git branch -f "$MAIN_BRANCH" "origin/$MAIN_BRANCH"
  else
    if [ "$current_branch" != "$MAIN_BRANCH" ]; then
      exit_error "Cannot install: Expecting you are on the '$MAIN_BRANCH' branch."
    fi

    # fresh install

    git pull origin "$MAIN_BRANCH"
    git switch -c "$DEFAULT_USER_BRANCH"

    if command -v hstr &>/dev/null || command -v hh &>/dev/null; then
      if command -v hh &>/dev/null && ! hh --version 2>/dev/null | grep \\bhstr\\b &>/dev/null; then
        exit_error "Cannot install: $(command -v hh) was expected to not exist or to be an installation of HSTR." \
          "Please open an issue here https://github.com/bibermann/biberconf/issues or contact fabianvss@gmail.com"
      fi
      if command -v hstr &>/dev/null && command -v hh &>/dev/null; then
        exit_error "Cannot install: Please uninstall the currently installed version of HSTR before and remove $(command -v hh)."
      elif command -v hstr &>/dev/null; then
        exit_error "Cannot install: Please uninstall the currently installed version of HSTR before."
      elif command -v hh &>/dev/null; then
        exit_error "Cannot install: Please remove $(command -v hh) (artifact of HSTR)."
      fi
    fi
  fi

  local this_script_name
  this_script_name="$(basename "$0")"
  if git diff --name-only "$current_commit..HEAD" | grep -q -E "$this_script_name|scripts/(common|system)"; then
    echo_info "I updated myself, restarting..."
    if ! [ -f ".biberconf/$this_script_name" ]; then
      exit_error "The name of the installation script is no longer '$this_script_name'." \
        "Please manually call the new installation script now."
    fi
    exec ".biberconf/$this_script_name" "$@"
    exit 0
  fi
}

self_update "$@"

git submodule sync --recursive
git submodule update --init --recursive

#************
# AUR helper
#************

if is_arch; then
  if [ -z "${BIBERCONF_AUR_HELPER:-}" ] || ! command -v "$BIBERCONF_AUR_HELPER" &>/dev/null; then
    possible_aur_helpers=(yay paru aura pikaur trizen aurman pakku)
    installed_aur_helpers=()
    for aur_helper in "${possible_aur_helpers[@]}"; do
      if command -v "$aur_helper" &>/dev/null; then
        installed_aur_helpers+=("$aur_helper")
      fi
    done
    echo_info "Choose an AUR helper or enter a custom one:"
    select BIBERCONF_AUR_HELPER in "${installed_aur_helpers[@]}" custom; do
      if [ "$BIBERCONF_AUR_HELPER" == custom ]; then
        read -rp "Enter AUR helper name (e.g. paru): " BIBERCONF_AUR_HELPER
      fi
      if [ -n "$BIBERCONF_AUR_HELPER" ]; then
        break
      fi
      echo "Invalid option, please try again."
    done
    if ! command -v "$BIBERCONF_AUR_HELPER" &>/dev/null; then
      exit_error "$BIBERCONF_AUR_HELPER not installed. Please install an AUR helper and try again."
    fi
  fi
fi

#**************
# requirements
#**************

if is_debian; then
  required_packages=(
    vim
    entr                                                        # for `git a` and `git as`
    git-delta                                                   # for git pager
    highlight                                                   # for `ccat`
    build-essential cmake                                       # for `stderred`
    automake gcc make pkg-config libncurses-dev libreadline-dev # for `hstr`
    perl                                                        # for uninstallation script
  )
  if is_gui; then
    required_packages+=(
      meld kdiff3
    )
  fi

  not_installed_packages=()
  for package in "${required_packages[@]}"; do
    if ! dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep "^install ok installed$" &>/dev/null; then
      not_installed_packages+=("$package")
    fi
  done
  if [ ${#not_installed_packages[@]} -gt 0 ]; then
    read_reply "Installing required packages (${not_installed_packages[*]}), sudo required..." \
      "Press [Enter] to continue."
    set -x
    sudo apt update
    sudo apt install -y "${not_installed_packages[@]}"
    set +x
  fi
elif is_arch; then
  required_packages=(
    extra/vim
    extra/entr       # for `git a` and `git as`
    extra/git-delta  # for git pager
    extra/highlight  # for `ccat`
    aur/stderred-git # for `stderred`
    core/inetutils   # for `hostname`
    core/perl        # for uninstallation script
  )
  if is_gui; then
    required_packages+=(
      extra/meld extra/kdiff3
    )
  fi

  not_installed_packages=()
  for package in "${required_packages[@]}"; do
    if ! "$BIBERCONF_AUR_HELPER" -Qi "${package##*/}" &>/dev/null; then
      not_installed_packages+=("$package")
    fi
  done
  if [ ${#not_installed_packages[@]} -gt 0 ]; then
    read_reply "Installing required packages (${not_installed_packages[*]}), sudo required..." \
      "Press [Enter] to continue."
    set -x
    "$BIBERCONF_AUR_HELPER" --color auto -S "${not_installed_packages[@]}"
    set +x
  fi
else
  exit_error "Unsupported distribution or cannot identify distribution." \
    "Only Debian based and Arch based distributions are supported."
fi

#******
# HSTR
#******

cd .biberconf/thirdparty/hstr

read_reply "Installing HSTR, sudo required..." \
  "Press [Enter] to continue."
if is_debian; then
  cd build/tarball
  ./tarball-automake.sh
  cd ../..
  ./configure
  make
  set -x
  if [ -f /usr/local/bin/hh ]; then sudo rm /usr/local/bin/hh; fi
  sudo make install
  set +x
elif is_arch; then
  # set -x
  # updpkgsums
  # makepkg --syncdeps --install --clean
  # git status  # for debugging
  # set +x
  # TODO: for some reason, the above downloads hstr-3.1.tar.gz,
  #       instead of creating the package from source.
  #       That's why, for now, we do not use the package manager to install.
  # The following two lines you find in .biberconf/thirdparty/hstr/PKGBUILD
  sed -i -e "s#<ncursesw/curses.h>#<curses.h>#g" src/include/hstr_curses.h
  sed -i -e "s#<ncursesw/curses.h>#<curses.h>#g" src/include/hstr.h
  cd build/tarball
  ./tarball-automake.sh
  cd ../..
  ./configure
  make
  set -x
  if [ -f /usr/local/bin/hh ]; then sudo rm /usr/local/bin/hh; fi
  sudo make install
  git checkout -- . # because we changed some files with sed
  set +x
fi

cd ../../..

if ! [ -d .hstr_histories ]; then
  mkdir .hstr_histories
  if [ -f .bash_history ]; then
    cp -a .bash_history .hstr_histories/"$(date -u +%Y-%m-%d_%H-%M-%S)_old-history"
  fi
fi

#**********
# stderred
#**********

if is_debian; then
  cd .biberconf/thirdparty/stderred
  make
  cd ../../..
fi

#***********
# dot files
#***********

if [ -f .bashrc-personal ]; then
  bashrc_file=.bashrc-personal
else
  bashrc_file=.bashrc
fi

if [ -f .profile-personal ]; then
  profile_file=.profile-personal
else
  profile_file=.profile
fi

if [ -f .config/git/config ] && ! [ -f .gitconfig ]; then
  gitconfig_file=.config/git/config
else
  gitconfig_file=.gitconfig
fi

# Commit existing dot files that we modify and are not versioned yet
for file in "$bashrc_file" "$profile_file" "$gitconfig_file" .vimrc; do
  sed -i -E 's/^#(!\/'"$(quote_re "$file")"')$/\1/g' .gitignore
done
git add .gitignore
for file in "$bashrc_file" "$profile_file" "$gitconfig_file" .vimrc; do
  if [ -f "$file" ] && ! git ls-files --error-unmatch "$file" &>/dev/null; then
    git add -- "$file"
  fi
done
if ! git diff --cached --quiet; then
  git commit -m "Add personal dot files"
fi

# For some configs we need to prepend text (instead of appending).
# To do this with sed using `1s/`,
# the file needs to exist and contain at least one line (may be empty though).
files_to_prepend_to="$gitconfig_file .vimrc"
for file in $files_to_prepend_to; do
  if ! [ -s "$file" ]; then
    echo '' >>"$file"
  fi
done

# .bashrc
if ! grep -q '^export BIBERCONF_AUR_HELPER=' "$bashrc_file"; then
  echo "export BIBERCONF_AUR_HELPER=$BIBERCONF_AUR_HELPER" >>"$bashrc_file"
  git add -- "$bashrc_file"
fi
if ! grep -q '^source "\$HOME/\.biberconf/config/shell/.bashrc"$' "$bashrc_file"; then
  echo 'source "$HOME/.biberconf/config/shell/.bashrc"' >>"$bashrc_file"
  git add -- "$bashrc_file"
fi

# .profile
if ! grep -q '^source "\$HOME/\.biberconf/config/shell/.profile"$' "$profile_file"; then
echo 'source "$HOME/.biberconf/config/shell/.profile"' >>"$profile_file"
  git add -- "$profile_file"
fi

# .gitconfig
if ! grep -q '^\s*path = ~/.biberconf/config/git/[^/]*.gitconfig$' "$gitconfig_file"; then
  if is_gui; then
    sed -i '1s#^#[include]\n    path = ~/.biberconf/config/git/.gitconfig\n#' "$gitconfig_file"
  else
    sed -i '1s#^#[include]\n    path = ~/.biberconf/config/git/server.gitconfig\n#' "$gitconfig_file"
  fi
  git add -- "$gitconfig_file"
fi

# .vimrc
if ! grep -q '^source ~/.biberconf/config/.vimrc$' .vimrc; then
  sed -i '1s#^#source ~/.biberconf/config/.vimrc\n#' .vimrc
  git add -- .vimrc
fi

if ! git diff --cached --quiet; then
  git commit -m "Import Biberconf in dot files"
fi

#**********
# finalize
#**********

show_log
rm -f "$MERGE_BASE_FILE"

echo_success "Installation successfull." \
  "You should restart your terminal now or at least call 'source ~/.bashrc'." \
  "You can always review and change the files in ~/.biberconf and commit them" \
  "to your newly created branch '$DEFAULT_USER_BRANCH' to keep track of your own changes." \
  "The changes will get rebased automatically when updating Biberconf." \
  "And of course you may commit any other file in your home directory as well."
