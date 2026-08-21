autoload -U +X compinit && compinit

mkdir -p ${ZSH_CACHE_DIR}/completions

eval "$(sheldon source)"
eval "$(fasd --init auto)"

#PROFILES
source ~/.profile

#FUNCTIONS
source ~/.zshfn

case `uname` in
  Darwin)
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
  ;;
  Linux)
    bindkey "$terminfo[kcuu1]" history-substring-search-up
    bindkey "$terminfo[kcud1]" history-substring-search-down
  ;;
esac

#COMPLETION OPTION STACKING
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# agent-browser: auto-close idle browser after 1h to prevent runaway Chrome processes
export AGENT_BROWSER_IDLE_TIMEOUT_MS=3600000
