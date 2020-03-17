#!/usr/bin/env bash

set -euo pipefail

COMMON_SCRIPT=scripts/common.sh

. $COMMON_SCRIPT

if [[ $(git rev-parse --show-toplevel) != $HOME/.biberconf ]]; then
    exit_error "Cannot install: This repo must be cloned to '$HOME/.biberconf'."
fi
cd ~/.biberconf

#*************
# self-update
#*************

if output=$(git status --untracked-files=no --porcelain) && [ -z "$output" ]; then
    :
else
    git status
    exit_error "Cannot install: Your working directory is not clean (see above)."
fi

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
        if [[ $merge_base != $(git rev-parse master) ]]; then
            if ! git rebase -p --onto $merge_base master; then
                git rebase --abort || true
                exit_error "Could not rebase. Please manually remove the commits from (but not including) $merge_base until (including) master, resolve the conflicts and try again."
            fi
        fi
        if ! git rebase origin/master; then
            git rebase --abort || true
            exit_error "Could not rebase. Please manually run 'git rebase origin/master', resolve the conflicts and try again."
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
                exit_error "Cannot install: $(command -v hh) was expected to not exist or to be an installation of HSTR.\nPlease open an issue here https://github.com/bibermann/biberconf/issues or contact fabianvss@gmail.com"
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
        cp "$link" "user-backup/$backup"
        git add "user-backup/$backup"
        git commit -m "Backup ${link/"$HOME/"/"~/"} to ./user-backup/$backup."
    fi
done

for i in "${!links[@]}"; do
    link="${links[$i]}"
    target="${targets[$i]}"
    backup="${backups[$i]}"
    if ! [[ -L $link ]]; then
        if [[ -f $link ]]; then
            if [[ $link == ~/.bashrc ]] && diff "/etc/skel/.bashrc" "$link" >/dev/null 2>&1; then
                read_reply "Note that I have backed up your '~/.bashrc' and will provide you with all the settings you would generally need." \
                           "Nevertheless there may be some stuff you may want to keep. We will now search for this stuff to keep." \
                           "Note that you can always review your original file content in '$(cd user-backup; pwd)/$backup' and add stuff to '$link' (or '$(pwd)/$target', resp.) later." \
                           "I will now open your '~/.bashrc' in comparison with the original file of your distribution. The modified version will be on the right side." \
                           "There you will search for the first (and optionally last) line numbers of the lines you want to keep." \
                           "Press [Enter] to continue."

                old_meld_conf=$(dconf read /org/gnome/meld/show-line-numbers)
                dconf write /org/gnome/meld/show-line-numbers "true"
                meld "/etc/skel/.bashrc" "$link"
                dconf write /org/gnome/meld/show-line-numbers "$old_meld_conf"

                read_reply "Do you want to keep some lines now? [y|n]"
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    read_reply "Enter first line to keep:"
                    start="$REPLY"
                    read_reply "Enter last line to keep (keep empty to select until the end of the file):"
                    end="$REPLY"

                    echo >> "$target"
                    if [[ ! -z "$end" ]]; then
                        sed -n -e $start',$p' -e $end'q' "$link" >> "$target"
                    else
                        sed -n $start',$p' "$link" >> "$target"
                    fi
                fi
            else
                cat "$link" >> "$target"
            fi

            if ! git diff --quiet "$target"; then
                git add "$target"
                git commit -m "Integrate ${link/"$HOME/"/"~/"} into ./$target."
            fi

            rm "$link"
        fi
        ln -s "$(pwd)/$target" "$link"
    fi
done

grep -q '^\. "\$HOME/\.biberconf/config/profile.sh"$' ~/.profile || echo -e '. "$HOME/.biberconf/config/profile.sh"\n' >> ~/.profile

if ! [[ -d ~/.hstr_histories ]]; then
    mkdir ~/.hstr_histories
    if [[ -f ~/.bash_history ]]; then
        cp ~/.bash_history ~/.hstr_histories/$(date -u +%Y-%m-%d_%H-%M-%S)_old-history
    fi
fi

echo_success "Installation successfull." \
             "You should restart your terminal now or at least call 'source ~/.bashrc'." \
             "You can always review and change the files in '$(pwd)' and commit them to your newly created branch 'custom' to keep track of your own changes."
