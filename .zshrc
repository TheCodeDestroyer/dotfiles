autoload -U +X compinit && compinit

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

mkdir -p ${ZSH_CACHE_DIR}/completions

eval "$(sheldon source)"
eval "$(fasd --init auto)"

#PROFILES
source ~/.profile

#FUNCTIONS
source ~/.zshfn

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

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
