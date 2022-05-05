trap "" DEBUG

function git_branch {
  git branch --no-color 2> /dev/null | egrep '^\*' | sed -e 's/^* //'
}

function git_dirty {
  # only tracks modifications, not unknown files needing adds
  if [ -z "`git status -s | awk '{print $1}' | grep '[ADMTU]'`" ] ; then
    return 1
  else
    return 0
  fi
}

function dirty_git_prompt {
  branch=`git_branch`
  if [ -z "${branch}" ] ; then
    return
  fi
  git_dirty && echo " (${branch})"
}

function clean_git_prompt {
  branch=`git_branch`
  if [ -z "${branch}" ] ; then
    return
  fi
  git_dirty || echo " (${branch})"
}

export PS1='\n\e[1m\u\e[m@\e[4m\h\e[m:\e[7m\w\e[m\[\033[01;31m\]$(dirty_git_prompt)\[\033[01;32m\]$(clean_git_prompt)\[\033[00m\]\n\# \$> '

function title {
  export EXPLICIT_TITLE=\*$*\*
}

function notitle() {
  unset EXPLICIT_TITLE
}

if [ "$TERM" = "screen" ]; then
  export PROMPT_COMMAND='true'
    set_screen_window() {
      # If we've explicitly set a title, use that until it's unset.
      if [ "$EXPLICIT_TITLE" ]; then
        printf '\ek%s\e\\' "$EXPLICIT_TITLE"
      # If we're entering a container, set the title to the container name
      elif [[ $BASH_COMMAND =~ control\ enter.* ]]; then
        CONTAINER=devbox:`echo $BASH_COMMAND | sed 's/control enter //'`
        printf '\ek%s\e\\' "$CONTAINER"
      # Otherwise, set the title based on the current directory
      else
        HPWD=`basename "$PWD"`
        if [ "$HPWD" = "$USER" ]; then
          HPWD='~';
        fi
        if [ ${#HPWD} -ge 20 ]; then
          HPWD=${HPWD:0:18}'..';
        fi
        printf '\ek%s\e\\' "$HPWD"
      fi
    }
  # Dirty hack to make a command run before commands
  trap set_screen_window DEBUG
fi

export SSH_ENV="$HOME/.ssh/agent-environment"

function start_agent {
    /usr/local/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi


docker-compose-restart(){
  docker-compose stop $@
  docker-compose rm -f -v $@
  docker-compose create --force-recreate $@
  docker-compose start $@
}


flip () {
  echo -en "( º_º）  ┬─┬     \r"
  sleep .2
  echo -en " ( º_º） ┬─┬     \r"
  sleep .2
  echo -en "  ( ºДº）┬─┬     \r"
  sleep .4
  echo -en "  (╯'Д'）╯︵⊏    \r"
  sleep .2
  echo -en "  (╯'□'）╯︵ ⊏   \r"
  sleep .1
  echo "  (╯°□°）╯︵ ┻━┻ "
}

sunglasses () {
  echo -en " ( •_•)     \r"
  sleep .5
  echo -en " ( •_•)>⌐■-■\r"
  sleep 1
  echo " (⌐■_■)     "
}

export PATH=$PATH:$EC2_HOME/bin:/usr/local/sbin

export PYTHONDONTWRITEBYTECODE=1

alias scopedns="dscacheutil -q host -a name"
alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"

export TERM=xterm-256color

export EDITOR=nvim

export GPG_TTY=$(tty)
gpgconf --launch gpg-agent

test -e ~/.iterm2_shell_integration.bash && source ~/.iterm2_shell_integration.bash || true

#eval "$(pyenv init -)
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

infocmp $TERM | sed 's/kbs=^[hH]/kbs=\\177/' > ~/$TERM.ti
tic ~/$TERM.ti
