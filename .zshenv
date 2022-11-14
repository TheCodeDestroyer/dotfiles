setopt BANG_HIST
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt HIST_BEEP

# COMMON
export PATH=~/bin/exec:$PATH
export EDITOR=nano
export LANG="en_US.UTF-8"
# ZSH
export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
export ZSH_CACHE_DIR="${HOME}/.zsh_cache"
### ZHS plugin stuff
export ZSH_PLUGINS_ALIAS_TIPS_EXCLUDES="g st y"
export ZSH_PLUGINS_ALIAS_TIPS_TEXT="You should use: "
# Android
export ANDROID_SDK_ROOT=~/Work/software/android/sdk
export ANDROID_HOME=$ANDROID_SDK_ROOT
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
export PATH=$PATH:$ANDROID_SDK_ROOT/tools
export PATH=$PATH:$ANDROID_SDK_ROOT/tools/bin
# Node
export NVM_LAZY_LOAD=true
export PATH=~/.yarn/bin:$PATH
# Python
export PATH=~/.local/bin:$PATH
# Ansible
export ANSIBLE_NOCOWS=1
# Go
export PATH=~/go/bin:$PATH

# Secrets
export NPM_AUTH_TOKEN="op://private/npm/auth/token"
export NPM_USERNAME="op://private/npm/username"
export NPM_EMAIL="op://private/npm/username"
export DOCKER_USERNAME="op://private/docker/username"
export DOCKER_AUTH_TOKEN="op://private/docker/auth/token"

# Sheldon
local OS_TYPE=$(uname -s)
if [[ "${OS_TYPE}" == "Darwin" ]]; then
  export SHELDON_PROFILE=macos
elif [[ "${OS_TYPE}" == "Linux" ]]; then
  export SHELDON_PROFILE=linux
else
  export SHELDON_PROFILE=unknown
fi
