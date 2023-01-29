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

# EXPORTS

## Common
export PATH=~/bin/exec:$PATH
export EDITOR=nano
export LANG="en_US.UTF-8"
## ZSH
export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
export ZSH_CACHE_DIR="${HOME}/.zsh_cache"
### ZHS plugin stuff
export ZSH_PLUGINS_ALIAS_TIPS_EXCLUDES="g st y"
export ZSH_PLUGINS_ALIAS_TIPS_TEXT="You should use: "
## Android
export ANDROID_SDK_ROOT=~/Work/software/android/sdk
export ANDROID_HOME=$ANDROID_SDK_ROOT
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
export PATH=$PATH:$ANDROID_SDK_ROOT/tools
export PATH=$PATH:$ANDROID_SDK_ROOT/tools/bin
## Node
export NVM_LAZY_LOAD=true
export PATH=~/.yarn/bin:$PATH
export PNPM_HOME=~/.local/share/pnpm
export PATH=$PNPM_HOME:$PATH
## Python
export PATH=~/.local/bin:$PATH
## Ansible
export ANSIBLE_NOCOWS=1
## Go
export PATH=~/go/bin:$PATH

## Secrets
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

# Aliases

alias ghee-default="ghee set --email the.code.destroyer@gmail.com"
alias ghee-work="ghee set --email nace.logar@3fs.si"

alias ls='lsd'

alias c='z'
alias opn='a -e xdg-open'
alias edt='f -e "$EDITOR"'

alias scan-code="cloc --exclude-dir=$(tr '\n' ',' < ~/.clocignore) ./"

# PNPM
alias pn="pnpm"
alias pni="pnpm install"
alias pna="pnpm add"
alias pnad="pnpm add --save-dev"
alias pnap="pnpm add --save-peer"
alias pnb="pnpm build"
alias pnd="pnpm dev"
alias pnf="pnpm format"
alias pnga="pnpm add --global"
alias pngls="pnpm list --global"
alias pngrm="pnpm remove --global"
alias pngu="pnpm upgrade --interactive --global"
alias pnln="pnpm lint"
alias pnrm="pnpm remove"
alias pnst="pnpm start"
alias pnt="pnpm test"
alias pnui="pnpm upgrade --interactive"
alias pnuil="pnpm update --interactive --latest"
alias pnv="pnpm version"
alias pny="pnpm why"
