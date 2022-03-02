#!/bin/bash

function installIfNotPresent() {
    src="$1"
    dst="$2"
    if [ ! "$dst" ] ; then
        dst="$src"
    fi

    if [ ! -e ~/"$dst" ] ; then
        ln -s "$(pwd)/$src" ~/"$dst"
    else
        echo ~/"$dst found, not overwriting" >&2
    fi
}

for f in .screenrc .tmux.conf .vimrc .vim ; do
    installIfNotPresent "$f"
done

# clean this nonsense up later since I seem to be sticking with starship
installIfNotPresent .zshrc-starship .zshrc
installIfNotPresent .zshrc .zshrc-dotfiles

mkdir -p ~/.config
installIfNotPresent starship.toml .config/starship.toml
