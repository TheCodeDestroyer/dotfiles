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

## Secrets
export NPM_AUTH_TOKEN="op://private/npm/auth/token"
export NPM_USERNAME="op://private/npm/username"
export NPM_EMAIL="op://private/npm/username"
export DOCKER_USERNAME="op://private/docker/username"
export DOCKER_AUTH_TOKEN="op://private/docker/auth/token"
export CONVEX_AUTH_TOKEN="op://private/convex/auth/token"
export CONVEX_WOKR_AUTH_TOKEN="op://optiweb/convex - ow/auth/token"

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
alias ghee-work="ghee set --email nace.logar@optiweb.com"

alias ls='lsd'

alias c='z'
alias opn='a -e xdg-open'
alias edt='f -e "$EDITOR"'

alias scan-code="cloc --vcs=git"

# PM
alias pmi="pm install"
alias pma="pm add"
alias pmad="pm add --save-dev"
alias pmap="pm add --save-peer"
alias pmb="pm build"
alias pmd="pm dev"
alias pmf="pm format"
alias pmga="pm add --global"
alias pmgls="pm list --global"
alias pmgrm="pm remove --global"
alias pmgu="pm upgrade --interactive --global"
alias pmln="pm lint"
alias pmrm="pm remove"
alias pmst="pm start"
alias pmt="pm test"
alias pmtw="pm test:watch"
alias pmui="pm upgrade --interactive"
alias pmuil="pm update --interactive --latest"
alias pmv="pm version"
alias pmy="pm why"


# GIT
alias gcmi="git commit"
alias gcstg="git checkout staging"
