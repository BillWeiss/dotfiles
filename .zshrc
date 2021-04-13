## set up oh-my-zsh
export ZSH=$HOME/.oh-my-zsh
export ZSH_THEME="gentoo"
export COMPLETION_WAITING_DOTS="true"
export ZSH_DISABLE_COMPFIX=true
export DISABLE_UPDATE_PROMPT=true
plugins=(
    compleat
    git
    github
    mosh
    nmap
    python
    pyenv
)

## turns out I don't have tmux everywhere!
if command -v tmux > /dev/null
then
    plugins+=(tmux)
fi

# figure out which plugins to use, per-OS and distro
case $(uname) in
  Darwin)
    plugins+=(aws osx)
    ;;
  Linux)
    plugins+=(ssh-agent)
    case $( grep -E '^ID=' /etc/os-release | awk -F= '{print $2}' ) in
      raspbian|debian)
        plugins+=(debian)
        ;;
      ubuntu)
        plugins+=(ubuntu)
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
#    if command -v nvim > /dev/null ; then
#        export EDITOR=nvim
#        alias vim=nvim
#    else
        if command -v mvim > /dev/null ; then
            export EDITOR='mvim -f -c "au VimLeave * !open -a Terminal"'
            alias vim=mvim
        fi
#    fi

    alias ll='ls -FalG'
    alias brewup='brew update && brew upgrade && brew upgrade --cask && brew cleanup'
    function manpdf() {
        man -t $* | open -f -a /System/Applications/Preview.app
    }

    # Homebrew nonsense
    addpath /usr/local/sbin /usr/local/bin

    # make sure touch ID is on for sudo
    # OS upgrades unset this sometimes
    # First, make sure we're on a touch ID machine. bioutil looks up how many
    # enrolled fingerprints there are, make sure it's > 0
    if [[ -x /usr/bin/bioutil ]] ; then
        numPrints=$(/usr/bin/bioutil -c | grep User | awk '{print $3}')
        if [[ "$numPrints" -gt 0 ]] ; then
            egrep -q '^auth *sufficient *pam_tid.so$' /etc/pam.d/sudo || \
                echo "TouchID settings not in PAM for sudo\n" \
                     "Put this line into /etc/pam.d/sudo up top:\n" \
                     "auth       sufficient     pam_tid.so" >&2
        fi
    fi


    # yubikey-agent from Filo
    [[ -S /usr/local/var/run/yubikey-agent.sock ]] && \
        export SSH_AUTH_SOCK="/usr/local/var/run/yubikey-agent.sock"

    ;;
  Linux)
    if command -v nvim > /dev/null ; then
        export EDITOR=nvim
        alias vim=nvim
    fi
    alias ll='ls -Fal --color'
    alias info=pinfo
    addpath /usr/sbin
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

## make rvm work
[[ -s ~/.rvm/scripts/rvm ]] && source ~/.rvm/scripts/rvm

## if there's a go dir, assume it's my GOPATH
[[ -d $HOME/go ]] && export GOPATH=$HOME/go && addpath $HOME/go/bin

## local-only aliases
[[ -s ~/.zshrc-local ]] && source ~/.zshrc-local

## this sucks, but something about the system ssh-agent on my Mac and gpg-agent
#  isn't playing well together.  Workaround so I can do work.
[[ -s ~/.gnupg/gpg-agent.env ]] && source ~/.gnupg/gpg-agent.env
