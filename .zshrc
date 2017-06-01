#zmodload zsh/zprof

source ~/.antigen/antigen.zsh
source ~/.nvm/nvm.sh
source ~/.rvm/scripts/rvm

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


# FUNCTIONS
function mkcdir
{
    mkdir -p -- "$1" && cd -P -- "$1"
}

docker-dangling-volumes ()
{
	dockera volume ls -f dangling=true
}

# Tell antigen that you're done.
antigen apply

#zprof
