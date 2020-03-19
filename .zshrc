#zmodload zsh/zprof

# ENV
# android
export ANDROID_HOME=~/Work/software/android/sdk
export PATH=${PATH}:~/Work/software/android/sdk/tools
export PATH=${PATH}:~/Work/software/android/sdk/platform-tools
# common
export PATH=~/bin/exec:$PATH
export PATH=~/bin/exec/external:$PATH
export PATH=/usr/local/bin:$PATH
export EDITOR=nano
# node
export NODE_TLS_REJECT_UNAUTHORIZED=0
export NVM_LAZY_LOAD=true
export PATH=~/.yarn/bin:$PATH
### Ansible
export ANSIBLE_NOCOWS=1
### Go
export PATH=~/go/bin:$PATH
### ZHS Stuff
export YSU_IGNORED_ALIASES=("y" "st")

source ~/.antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles
antigen bundle zsh-users/zsh-completions
antigen bundle zdharma/fast-syntax-highlighting
antigen bundle command-not-found
antigen bundle MichaelAquilina/zsh-you-should-use
antigen bundle history
antigen bundle debian
antigen bundle sudo
antigen bundle gitfast
antigen bundle nvm
antigen bundle node
antigen bundle npm
antigen bundle yarn
antigen bundle colored-man-pages
antigen bundle sprunge
antigen bundle sublime

antigen bundle pip
antigen bundle python
antigen bundle gem
antigen bundle gradle
antigen bundle bundler
antigen bundle heroku
antigen bundle github
antigen bundle docker
antigen bundle docker-compose
antigen bundle git-extras
antigen bundle kubectl
antigen bundle ansible

# Load the theme.
antigen theme bira

# Tell antigen that you're done.
antigen apply

### SOURCES
source-file () {
    [[ -f "$1" ]] && source "$1"
}

source-file ~/.bash_profile
source-file ~/.bash_login
source <(kubectl completion zsh)

### ENV INIT
# DIR ENV
eval "$(direnv hook zsh)"

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

function docker-remove-all-containers
{
  docker rm -f $(docker ps -a -q)
}

function docker-remove-all-images
{
  docker rmi -f $(docker images -q)
}

function docker-remove-all-services
{
  docker service rm $(docker service ls -q)
}

function docker-remove-dangling-volumes
{
  docker volume rm $(docker volume ls -q -f dangling=true)
}

function docker-remove-all-secrets
{
  docker secret rm $(docker secret ls -q)
}

function docker-remove-all-configs
{
  docker config rm $(docker config ls -q)
}

function docker-clean-everything
{
  docker-remove-all-services
  docker-remove-all-containers
  docker-remove-all-images
  docker-remove-dangling-volumes
  docker-remove-all-secrets
  docker-remove-all-configs
}

function docker-check-proper-format
{
  FORMAT=${1:-}
  FORMAT_FOR=${2:-container}
  if [[ -z $FORMAT ]]
  then
    if [[ $FORMAT_FOR == "container" ]]
    then
      echo "INFO:"
      echo "Format not provided."
      echo "Some example container formats: {{.ID}}, {{.Image }}, {{.Command }}, {{.CreatedAt }}, {{.RunningFor }}, {{.Ports }}, {{.Status }}, {{.Size }}, {{.Names }}, {{.Labels}}, {{.Label}}, {{.Mounts}}, {{.Networks}}"
    fi
    if [[ $FORMAT_FOR == "image" ]]
    then
      echo "INFO:"
      echo "Format not provided."
      echo "Some example image formats: {{.ID}}, {{.Repository}}, {{.Tag}}, {{.Digest}}, {{.CreatedSince}}, {{.CreatedAt}}, {{.Size}}"
    fi
  fi
  echo $FORMAT
}

function docker-check-proper-filter
{
  FILTER_REF=""
  FILTER=${1:-}
  FORMAT_FOR=${2:-container}
  
  if [[ ! -z $FILTER ]]
  then
    
    if [[ $FORMAT_FOR == "container" ]]
    then
      FILTER_REF="name=$FILTER"
    fi
    if [[ $FORMAT_FOR == "image" ]]
    then
      FILTER_REF="reference=$FILTER"
    fi
  fi

  echo $FILTER_REF
}

function docker-get-container-by
{
  FILTER_REF="$(docker-check-proper-filter $1)"
  FORMAT=$(docker-check-proper-format $2)
  docker ps -a --filter="$FILTER_REF" --format="$FORMAT" | sed -n 1p
}

function docker-get-image-attribute
{
  FILTER_REF=$(docker-check-proper-filter $1 "image")
  FORMAT=$(docker-check-proper-format $2 "image")

  docker images --all --filter="$FILTER_REF" --format="$FORMAT" | sed -n 1p
}

function docker-run
{
  IMAGE_NAME=$1
  COMMAND_TO_RUN=${2:-bash}
  LOCAL_TAG=$(docker-get-image-attribute $IMAGE_NAME "{{.Tag}}")
  RUNNING_CONTAINER_NAME=$(docker-get-container-by $IMAGE_NAME "{{.Names}}")
  RUNNING_CONTAINER_STATUS=$(docker-get-container-by $IMAGE_NAME "{{.Status}}")
  if [[ $RUNNING_CONTAINER_STATUS = *"Exited"* ]]
  then
    echo "Removing dead container..."
    docker rm $RUNNING_CONTAINER_NAME
    RUNNING_CONTAINER_NAME=""
  fi

  if [[ -z $RUNNING_CONTAINER_NAME  ]]
  then
    echo "Creating new container"
    echo "IMAGE NAME: $IMAGE_NAME"
    echo "LOCAL TAG: $LOCAL_TAG"
    echo "COMMAND TO RUN: $COMMAND_TO_RUN"
    docker run --name $IMAGE_NAME -it $IMAGE_NAME:$LOCAL_TAG $COMMAND_TO_RUN
  else
    echo "Container already exists. Attaching..."
    docker exec -it $RUNNING_CONTAINER_NAME
  fi
}

#ALIASES
alias ghee-default="ghee set --email the.code.destroyer@gmail.com"

alias ghee-work="ghee set --email nace.logar@3fs.si"

alias ls='f() { exa $@ };f'

alias scan-code="cloc --exclude-dir=$(tr '\n' ',' < ~/.clocignore) ./"

#zprof
