## set up oh-my-zsh
export ZSH=$HOME/.oh-my-zsh
export ZSH_THEME="gentoo"
export COMPLETION_WAITING_DOTS="true"
export DISABLE_UPDATE_PROMPT=true
TZ=America/Portland
plugins=(compleat gem git github go python pyenv ruby rvm ssh-agent svn)

# figure out which plugins to use, per-OS and distro
case $(uname) in
  Darwin)
    plugins+=(brew osx rbenv gpg-agent)
    # this horrific thing removes "ssh-agent" from the list.
    # thanks http://stackoverflow.com/questions/3435355/remove-entry-from-array
    plugins=("${(@)plugins:#ssh-agent}")
    ;;
  Linux)
    case $( grep -E '^ID' /etc/os-release | awk -F= '{print $2}' ) in
      debian)
        plugins+=(debian)
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
    alias brewup='brew update && brew upgrade && brew cleanup'
    [[ -e /opt/boxen/env.sh ]] && source /opt/boxen/env.sh

    # local Perl modules.  Ugh.
    PERL_MB_OPT="--install_base \"/Users/bweiss/perl5\""; export PERL_MB_OPT;
    PERL_MM_OPT="INSTALL_BASE=/Users/bweiss/perl5"; export PERL_MM_OPT;

    # Homebrew nonsense
    addpath /usr/local/sbin /usr/local/bin

    # locally installed pip packages
    addpath ~/Library/Python/2.7/bin
    ;;
  Linux)
    alias ll='ls -Fal --color'
    alias info=pinfo

    # this is to work around the family of oh-my-zsh issues that look like
    # https://github.com/robbyrussell/oh-my-zsh/pull/3866
    unset ag
    unalias ag
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

[[ -d $HOME/go ]] && export GOPATH=$HOME/go && addpath $HOME/go/bin

## local-only aliases

[[ -s ~/.zshrc-local ]] && source ~/.zshrc-local

## this sucks, but something about the system ssh-agent on my Mac and gpg-agent
#  isn't playing well together.  Workaround so I can do work.
[[ -s ~/.gnupg/gpg-agent.env ]] && source ~/.gnupg/gpg-agent.env

# The next line updates PATH for the Google Cloud SDK.
[[ -s ~/google-cloud-sdk/path.zsh.inc ]] && source ~/google-cloud-sdk/path.zsh.inc

# The next line enables shell command completion for gcloud.
[[ -s ~/google-cloud-sdk/completion.zsh.inc ]] && source ~/google-cloud-sdk/completion.zsh.inc
