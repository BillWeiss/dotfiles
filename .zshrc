## set up oh-my-zsh
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="gentoo"
COMPLETION_WAITING_DOTS="true"
DISABLE_UPDATE_PROMPT=true
TZ=America/Portland
plugins=(compleat gem git github python ruby rvm ssh-agent svn)

# figure out which plugins to use, per-OS and distro
case $(uname) in
  Darwin)
    plugins+=(brew osx rbenv)
    ;;
  Linux)
    case $(cat /etc/os-release | egrep '^ID' | awk -F= '{print $2}') in
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

source $ZSH/oh-my-zsh.sh

addpath () {
  for pathentry in "$@" ; do
    [[ -e "${pathentry}" ]] && export PATH="${pathentry}:${PATH}"
  done
}

## sane defaults in case per-OS settings don't match
EDITOR=vim

## per-OS settings
case $(uname) in
  Darwin)
    export EDITOR='mvim -f -c "au VimLeave * !open -a iTerm"'
    export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home/

    alias vim=mvim
    alias ll='ls -FalG'
    [[ -e /opt/boxen/env.sh ]] && source /opt/boxen/env.sh

    # local Perl modules.  Ugh.
    PERL_MB_OPT="--install_base \"/Users/bweiss/perl5\""; export PERL_MB_OPT;
    PERL_MM_OPT="INSTALL_BASE=/Users/bweiss/perl5"; export PERL_MM_OPT;

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

addpath /usr/local/bin ~/bin ~/.local/bin/

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

## local-only aliases

[[ -s ~/.zshrc-local ]] && source ~/.zshrc-local
