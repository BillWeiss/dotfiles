## set up oh-my-zsh
export ZSH=$HOME/.oh-my-zsh
export ZSH_THEME="gentoo"
export COMPLETION_WAITING_DOTS="true"
export DISABLE_UPDATE_PROMPT=true
plugins=(
    compleat
    git
    github
    mosh
    nmap
    python
    pyenv
    tmux
)

# figure out which plugins to use, per-OS and distro
case $(uname) in
  Darwin)
    plugins+=(aws osx gpg-agent)
    ;;
  Linux)
    plugins+=(ssh-agent)
    case $( grep -E '^ID=' /etc/os-release | awk -F= '{print $2}' ) in
      debian)
        plugins+=(debian)
        ;;
      ubuntu)
        plugins+=(ubuntu)
        ;;
      arch)
        plugins+=(archlinux)
        ;;
      *)
        echo "I seem to be on an unexpected distro!"
        ;;
    esac
    ;;
  *)
    echo "I seem to be on an unexpected OS!"
    ;;
esac

addpath () {
  for pathentry in "$@" ; do
    [[ -s "${pathentry}" ]] && export PATH="${pathentry}:${PATH}"
  done
}

# do this before starting oh-my-zsh so it can find local binaries (like the
# ones that virtualenvwrapper installs
addpath ~/bin ~/.local/sbin ~/.local/bin

source $ZSH/oh-my-zsh.sh

## sane defaults in case per-OS settings don't match
EDITOR=vim

## per-OS settings
case $(uname) in
  Darwin)
    export EDITOR='mvim -f -c "au VimLeave * !open -a Terminal"'
    export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home/

    alias vim=mvim
    alias ll='ls -FalG'
    alias brewup='brew update && brew upgrade && brew cask upgrade && brew cleanup'
    alias manpdf() {
        man -t $* | open -f -a /System/Applications/Preview.app
    }

    # Homebrew nonsense
    addpath /usr/local/sbin /usr/local/bin

    # Python local bins
    addpath ~/Library/Python/*/bin

    ;;
  Linux)
    alias ll='ls -Fal --color'
    alias info=pinfo
    ;;
  *)
    # don't do anything, we've already complained above about an unsupported OS
    ;;
esac

export HISTFILE=~/.zsh_history
export HISTSIZE=1000
export SAVEHIST=2000
export VISUAL=$EDITOR
export GIT_EDITOR=$EDITOR
export LANG=en_US.utf-8
setopt APPEND_HISTORY
setopt nopromptcr

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias vi="vim"
alias today="date +%Y%m%d"
alias screen='screen -U'

command -v bat > /dev/null 2>&1 && export PAGER=bat

## make rvm work
[[ -s ~/.rvm/scripts/rvm ]] && source ~/.rvm/scripts/rvm

## if there's a go dir, assume it's my GOPATH
[[ -d $HOME/go ]] && export GOPATH=$HOME/go && addpath $HOME/go/bin

## local-only aliases
[[ -s ~/.zshrc-local ]] && source ~/.zshrc-local

## this sucks, but something about the system ssh-agent on my Mac and gpg-agent
#  isn't playing well together.  Workaround so I can do work.
[[ -s ~/.gnupg/gpg-agent.env ]] && source ~/.gnupg/gpg-agent.env
