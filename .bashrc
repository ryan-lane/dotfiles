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

# Set the screen title to the current directory
if [ "$TERM" = "screen" ]; then
  export PROMPT_COMMAND='true'
  set_screen_window() {
    HPWD=`basename "$PWD"`
    if [ "$HPWD" = "$USER" ]; then
      HPWD='~';
    fi
    if [ ${#HPWD} -ge 20 ]; then
      HPWD=${HPWD:0:18}'..';
    fi
    printf '\ek%s\e\\' "$HPWD"
  }
  # Dirty hack to make a command run before commands
  trap set_screen_window DEBUG
fi

export WORKON_HOME=~/Envs
source /usr/local/bin/virtualenvwrapper.sh

export PATH=$PATH:$EC2_HOME/bin:/usr/local/sbin:/Users/ryanlane/.gem/ruby/2.0.0/bin

export PYFLAKES_BUILTINS="__salt__,__opts__,__grains__,__pillar__,__context__,__utils__,__states__,_get_conn"
export PYTHONDONTWRITEBYTECODE=1

alias scopedns="dscacheutil -q host -a name"

# added by travis gem
[ -f /Users/ryanlane/.travis/travis.sh ] && source /Users/ryanlane/.travis/travis.sh

# Set nodejs to use node@6 from brew
export PATH="/usr/local/opt/node@6/bin:$PATH

eval "$(pyenv init -)
