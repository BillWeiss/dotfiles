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

for f in .screenrc .tmux.conf .vimrc .vim .zshrc ; do
    installIfNotPresent "$f"
done

mkdir -p ~/.config
installIfNotPresent starship.toml .config/starship.toml
