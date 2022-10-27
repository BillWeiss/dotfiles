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

if [ ! -d ~/".vim/bundle/Vundle.vim" ] ; then
    mkdir -p ~/".vim/bundle/"
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
elif [ -e ~/".vim/bundle/Vundle.vim" ] ; then
    echo ~/".vim/bundle/Vundle.vim exists and is not a directory??" >&2
fi
