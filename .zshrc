#zmodload zsh/zprof

source ~/.antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles
antigen bundle git
antigen bundle github
antigen bundle debian
antigen bundle pip
antigen bundle python
antigen bundle rsync
antigen bundle node
antigen bundle npm
antigen bundle rake
antigen bundle gem
antigen bundle gradle
antigen bundle sublime
antigen bundle sudo
antigen bundle rvm
antigen bundle bundler
antigen bundle yonchu/grunt-zsh-completion
antigen bundle zsh-users/zsh-completions src
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle kennethreitz/autoenv
antigen bundle command-not-found
antigen bundle history
antigen bundle sprunge
antigen bundle fabric
antigen bundle heroku
antigen bundle docker
antigen bundle docker-compose

# Load the theme.
antigen theme bira

# ENV
# android
export ANDROID_HOME=~/Work/software/android/sdk
export PATH=${PATH}:~/Work/software/android/sdk/tools
export PATH=${PATH}:~/Work/software/android/sdk/platform-tools
# home bin
export PATH=~/bin/exec:$PATH
# user bin
export PATH=/usr/local/bin:$PATH
# node
export NODE_TLS_REJECT_UNAUTHORIZED=0
### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
### RVM
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting


### SOURCES
source ~/.bash_profile
source ~/.bash_login
source ~/.nvm/nvm.sh
source ~/.rvm/scripts/rvm
source <(npm completion)


### ENV INIT
# NVM INIT
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# SSH INIT
find ~/.ssh/ -type f -exec grep -l "PRIVATE" {} \; | xargs ssh-add &> /dev/null

# FUNCTIONS
function mkcdir
{
    mkdir -p -- "$1" && cd -P -- "$1"
}

function user-list
{
  cut -d: -f1 /etc/passwd
}

function docker-dangling-volumes
{
  docker volume ls -f dangling=true
}

#ALIASES
alias ghee-default="ghee set --email the.code.destroyer@gmail.com"

alias ghee-work="ghee set --email nace.logar@3fs.si"


# Tell antigen that you're done.
antigen apply

#zprof
