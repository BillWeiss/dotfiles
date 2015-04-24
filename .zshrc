## set up oh-my-zsh
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="gentoo"
COMPLETION_WAITING_DOTS="true"
DISABLE_UPDATE_PROMPT=true
EDITOR=vim
VISUAL=$EDITOR
GIT_EDITOR=$EDITOR
TZ=America/Chicago
plugins=(compleat gem git github python rvm ruby ssh-agent svn)

# do some per-OS stuff
case $(uname) in
  Darwin)
    plugins+=(brew osx)
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

## more per-OS stuff
case $(uname) in
  Darwin)
    export EDITOR='mvim -f -c "au VimLeave * !open -a iTerm"'
    export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home/

    alias vim=mvim
    alias ll='ls -FalG'
    [[ -e /opt/boxen/env.sh ]] && source /opt/boxen/env.sh
    ;;
  Linux)
    alias ll='ls -Fal --color'
    if [[ "$TERM" = "screen" ]] ; then
      export TERM=xterm-256color
    fi
    ;;
  *)
    # don't do anything, we've already complained above about an unsupported OS
    ;;
esac

addpath /usr/local/bin ~/bin ~/.local/bin/

export HISTFILE=~/.zsh_history
export HISTSIZE=1000
export SAVEHIST=2000
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt NOPROMPTCR

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias vi="vim"
alias today="date +%Y%m%d"
alias screen='screen -U'
alias info=pinfo

set -o vi

export LANG=en_US.utf-8


