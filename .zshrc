sourceif () {
  for sourcefile in "$@" ; do
    [[ -s "${sourcefile}" ]] && source "${sourcefile}"
  done
}

addpath () {
  for pathentry in "$@" ; do
    [[ -s "${pathentry}" ]] && export PATH="${pathentry}:${PATH}"
  done
}

touchidcheck () {
    if [ -f "$1" ] ; then
        egrep -q '^auth *sufficient *pam_tid.so$' "$1" || \
            echo "TouchID settings not in PAM for sudo\n" \
                 "Put this line into $1 up top:\n" \
                 "auth       sufficient     pam_tid.so" >&2
    fi
}

addpath ~/bin ~/.local/sbin ~/.local/bin

autoload -Uz compinit && compinit

## sane defaults in case per-OS settings don't match
EDITOR=vim

## per-OS settings
case $(uname) in
  Darwin)
    if command -v mvim > /dev/null ; then
        export EDITOR='mvim -f -c "au VimLeave * !open -a Terminal"'
        alias vim=mvim
    fi

    alias ll='ls -FalG'
    alias brewup='brew update && brew upgrade && brew upgrade --cask && brew cleanup'

    # Homebrew might be in a couple of paths
    addpath /usr/local/sbin /usr/local/bin /opt/homebrew/bin /opt/homebrew/sbin

    # make sure touch ID is on for sudo
    # OS upgrades unset this sometimes
    # First, make sure we're on a touch ID machine. bioutil -c looks up how many
    # enrolled fingerprints there are, make sure it's > 0
    # Then bioutil -r says if touchID is set up to unlock the machine
    if [[ -x /usr/bin/bioutil ]] ; then
        numPrints=$(/usr/bin/bioutil -c | grep User | awk '{print $3}')
        if [[ "$numPrints" -gt 0 ]] ; then
            touchUnlock=$(/usr/bin/bioutil -r | grep unlock | tail -n 1 | awk '{print $NF}')
            if [[ "$touchUnlock" -gt 0 ]] ; then
                if [ -f /etc/pam.d/sudo_local ] ; then
                    touchidcheck /etc/pam.d/sudo_local
                else
                    touchidcheck /etc/pam.d/sudo
                fi
            fi
        fi
    fi

    # support a Secure Enclave-backed SSH key
    [ -S ~/.sekey/ssh-agent.ssh ] && export SSH_AUTH_SOCK=~/.sekey/ssh-agent.ssh 
    ;;
  Linux|FreeBSD)
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

# This has to come after all the OS-specific PATH wrangling so it can be found
if command -v starship &> /dev/null ; then
    eval "$(starship init zsh)"
else
    echo "No starship found in path :(" >&2
fi

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
sourceif ~/.rvm/scripts/rvm

## if there's a go dir, assume it's my GOPATH
[[ -d $HOME/go ]] && export GOPATH=$HOME/go && addpath $HOME/go/bin

# fzf in ZSH things
sourceif /opt/homebrew/opt/fzf/shell/completion.zsh /usr/share/doc/fzf/examples/completion.zsh
sourceif /opt/homebrew/opt/fzf/shell/key-bindings.zsh /usr/share/doc/fzf/examples/key-bindings.zsh

## local-only aliases
sourceif ~/.zshrc-local

# 1password integration
if command -v op &> /dev/null ; then
    eval "$(op completion zsh)"
    compdef _op op
fi
