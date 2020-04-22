#!/usr/bin/env bash

set -euo pipefail

#**************
# common stuff
#**************

COMMON_SCRIPT=scripts/common.sh

. $COMMON_SCRIPT

#***************
# preconditions
#***************

if [[ $(git rev-parse --show-toplevel) != $(realpath $HOME/.biberconf) ]]; then
    exit_error "Cannot install: This repo must be cloned to '$HOME/.biberconf'."
fi
cd ~/.biberconf

#*****************************
# check whether we have a GUI
#*****************************

if [[ ! -z ${DISPLAY:-} ]]; then
    IS_GUI="true"
else
    IS_GUI="false"
fi

#**************
# requirements
#**************

if [[ -z $(git config user.name) ]] || [[ -z $(git config user.email) ]]; then
    exit_error "Cannot install: You need to set your user name and email address in Git, like so:" \
               'git config --global user.name "John Doe"' \
               'git config --global user.email johndoe@example.com'
fi

required_packages=(
    vim
    entr  # for `git alg`
    highlight  # for `ccat`
    build-essential cmake  # for `stderred`
    automake gcc make pkg-config libncursesw5-dev libreadline-dev  # for `hstr`
)
if [[ $IS_GUI == "true" ]]; then
    required_packages+=(
        meld kdiff3
        dconf-cli  # for installation script
    )
fi

not_installed_packages=()
for package in "${required_packages[@]}"; do
    if ! dpkg-query -W -f='${Status}' $package 2>/dev/null | grep "^install ok installed$" >/dev/null 2>&1; then
        not_installed_packages+=($package)
    fi
done
if [[ ${#not_installed_packages[@]} -gt 0 ]]; then
    echo_info "Installing required packages (${not_installed_packages[*]}), sudo required..."
    set -x
    sudo apt update
    sudo apt install -y ${not_installed_packages[@]}
    set +x
fi

#*************
# self-update
#*************

if output=$(git status --untracked-files=no --porcelain) && [ -z "$output" ]; then
    :
else
    git status
    exit_error "Cannot install: Your working directory is not clean (see above)."
fi

show_log() {
    if [[ -f .MERGE_BASE ]]; then
        read merge_base < .MERGE_BASE
        if [[ ! -z $merge_base ]] && [[ $merge_base != $(git rev-parse origin/master) ]]; then
            echo_info "Changelog:" \
                      "$(git log $merge_base..origin/master --pretty='format:•biberconf• %B' --reverse | sed '/^\s*$/d' | sed -E 's/^([^•])/  \1/' | sed 's/•biberconf•/•/')"
        fi
    fi
}

self_update() {
    current_commit=$(git rev-parse HEAD)
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    if git show-ref --verify --quiet "refs/heads/$default_user_branch"; then
        # at least the default user branch exists
        if [[ $current_branch == master ]]; then
            exit_error "Cannot install: Expecting you are on a user-defined branch like '$default_user_branch'."
        fi

        # we are on a user-defined branch

        # don't mess up .gitconfig when rebasing
        if [[ -L ~/.gitconfig ]] && [[ $(readlink -f ~/.gitconfig) == ~/.biberconf/gitconfig ]]; then
            rm -f ~/.gitconfig.biberconf-backup
            mv ~/.gitconfig ~/.gitconfig.biberconf-backup
            cp ~/.biberconf/gitconfig ~/.gitconfig
        fi

        git fetch origin
        merge_base=$(git merge-base master origin/master)
        if ! [[ -f .MERGE_BASE ]]; then
            echo $merge_base > .MERGE_BASE
        fi
        if [[ $merge_base != $(git rev-parse master) ]]; then
            if ! git rebase -p --onto $merge_base master; then
                git rebase --abort || true
                show_log
                exit_error "Could not rebase." \
                           "Please manually remove the commits from (but not including) $merge_base until (including) master, resolve the conflicts and try again."
            fi
        fi
        if ! git rebase origin/master; then
            git rebase --abort || true
            show_log
            exit_error "Could not rebase." \
                       "Please manually run 'git rebase origin/master', resolve the conflicts (with 'git mergetool --tool=kdiff3' or 'git mergetool --tool=vimdiff') and try again."
        fi
        git branch -f master origin/master
    else
        if [[ $current_branch != master ]]; then
            exit_error "Cannot install: Expecting you are on the 'master' branch."
        fi

        # fresh install

        git pull origin master
        git checkout -b "$default_user_branch"

        for link in $links; do
            if [[ -L $link ]]; then
                exit_error "Cannot install: '$link' was not expected to be a symlink."
            fi
        done

        if command -v hstr >/dev/null 2>&1 || command -v hh >/dev/null 2>&1; then
            if command -v hh >/dev/null 2>&1 && ! hh --version 2>/dev/null | grep \\bhstr\\b >/dev/null 2>&1; then
                exit_error "Cannot install: $(command -v hh) was expected to not exist or to be an installation of HSTR." \
                           "Please open an issue here https://github.com/bibermann/biberconf/issues or contact fabianvss@gmail.com"
            fi
            if command -v hstr >/dev/null 2>&1 && command -v hh >/dev/null 2>&1; then
                exit_error "Cannot install: Please uninstall the currently installed version of HSTR before and remove $(command -v hh)."
            elif command -v hstr >/dev/null 2>&1; then
                exit_error "Cannot install: Please uninstall the currently installed version of HSTR before."
            elif command -v hh >/dev/null 2>&1; then
                exit_error "Cannot install: Please remove $(command -v hh) (artifact of HSTR)."
            fi
        fi
    fi

    this_script_name="$(basename "$0")"
    if [ $(git diff --name-only $current_commit..HEAD | grep -E "$this_script_name|$COMMON_SCRIPT") ]; then
        echo_info "I updated myself, restarting..."
        if ! [[ -f $this_script_name ]]; then
            exit_error "The name of the install script is no longer '$this_script_name'." \
                       "Please manually call the new install script now."
        fi
        exec "./$this_script_name" "$@"
        exit 0
    fi

    # restore git config
    if [[ -f ~/.gitconfig.biberconf-backup ]]; then
        rm -f ~/.gitconfig
        mv ~/.gitconfig.biberconf-backup ~/.gitconfig
    fi
}

self_update

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
echo_info "Installing HSTR, sudo required..."
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

for i in "${!links[@]}"; do
    link="${links[$i]}"
    backup="${backups[$i]}"
    if ! [[ -L $link ]] && [[ -f $link ]]; then
        cp $link user-backup/$backup
        git add user-backup/$backup
        git commit -m "Backup ${link/"$HOME/"/"~/"} to ./user-backup/$backup."
    fi
done

for i in "${!links[@]}"; do
    link="${links[$i]}"
    target="${targets[$i]}"
    backup="${backups[$i]}"
    if ! [[ -L $link ]]; then
        if [[ $target == gitconfig ]] && [[ $IS_GUI == "false" ]]; then
            sed -i 's#/desktop.gitconfig$#/server.gitconfig#' $target
            git add $target
            git commit -m "Switch to server configurations due to missing GUI."
        fi
        if [[ -f $link ]]; then
            if [[ $link == ~/.bashrc ]] && ! diff /etc/skel/.bashrc $link >/dev/null 2>&1; then
                if [[ $IS_GUI == "true" ]]; then
                    # Note: We show the modified version on the right side because this is more intuitive for people whe read from left to right.
                    read_reply "Note that I have backed up your '~/.bashrc' and will provide you with all the settings you would generally need." \
                               "Nevertheless there may be some stuff you may want to keep. We will now search for this stuff to keep." \
                               "Note that you can always review your original file content in '$(cd user-backup; pwd)/$backup' and add stuff to '$link' (or '$(pwd)/$target', resp.) later." \
                               "I will now open your '~/.bashrc' in comparison with the original file of your distribution with the program meld. The modified version will be on the right side." \
                               "There you will search for the first (and optionally last) line numbers of the lines you want to keep." \
                               "Close meld when you have memorized the line numbers." \
                               "Press [Enter] to continue."

                    old_meld_conf=$(dconf read /org/gnome/meld/show-line-numbers)
                    dconf write /org/gnome/meld/show-line-numbers "true"
                    meld /etc/skel/.bashrc $link
                    dconf write /org/gnome/meld/show-line-numbers "$old_meld_conf"
                else
                    # Note: We show the modified version on the left side because `vimdiff` only shows line numbers on the left side.
                    read_reply "Note that I have backed up your '~/.bashrc' and will provide you with all the settings you would generally need." \
                               "Nevertheless there may be some stuff you may want to keep. We will now search for this stuff to keep." \
                               "Note that you can always review your original file content in '$(cd user-backup; pwd)/$backup' and add stuff to '$link' (or '$(pwd)/$target', resp.) later." \
                               "I will now open your '~/.bashrc' in comparison with the original file of your distribution with the programm vim. The modified version will be on the left side." \
                               "There you will search for the first (and optionally last) line numbers of the lines you want to keep." \
                               "Type ':qa' (without the quotes) to exit vim when you have memorized the line numbers." \
                               "Press [Enter] to continue."

                    vimdiff -c 'set number' -c 'syntax on' -c 'set background=dark' -R $link /etc/skel/.bashrc
                fi

                read_reply "Do you want to keep some lines now? [y|n]"
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    read_reply "Enter first line to keep:"
                    start="$REPLY"
                    read_reply "Enter last line to keep (keep empty to select until the end of the file):"
                    end="$REPLY"

                    echo >> $target
                    if [[ ! -z "$end" ]]; then
                        sed -n -e $start',$p' -e $end'q' $link >> $target
                    else
                        sed -n $start',$p' $link >> $target
                    fi
                fi
            else
                cat $link >> $target
            fi

            if ! git diff --quiet $target; then
                git add $target
                git commit -m "Integrate ${link/"$HOME/"/"~/"} into ./$target."
            fi

            rm $link
        fi
        ln -s "$(pwd)/$target" $link
    fi
done

grep -q '^\. "\$HOME/\.biberconf/config/profile.sh"$' ~/.profile && sed -i 's#^\. "\$HOME/\.biberconf/config/profile.sh"$#. "$HOME/.biberconf/defaults/profile.sh"#g' ~/.profile  # update
grep -q '^\. "\$HOME/\.biberconf/defaults/profile.sh"$' ~/.profile || echo -e '. "$HOME/.biberconf/defaults/profile.sh"\n' >> ~/.profile

if ! [[ -d ~/.hstr_histories ]]; then
    mkdir ~/.hstr_histories
    if [[ -f ~/.bash_history ]]; then
        cp ~/.bash_history ~/.hstr_histories/$(date -u +%Y-%m-%d_%H-%M-%S)_old-history
    fi
fi

show_log
rm -f .MERGE_BASE

echo_success "Installation successfull." \
             "You should restart your terminal now or at least call 'source ~/.bashrc'." \
             "You can always review and change the files in '$(pwd)' and commit them to your newly created branch 'custom' to keep track of your own changes."
