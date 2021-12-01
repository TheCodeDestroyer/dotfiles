autoload -U +X compinit && compinit

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

eval "$(sheldon source)"
eval "$(fasd --init auto)"

#ALIASES
alias ghee-default="ghee set --email the.code.destroyer@gmail.com"
alias ghee-work="ghee set --email nace.logar@iryo.io"

alias ls='lsd'

alias c='z'
alias opn='a -e xdg-open'
alias edt='f -e "$EDITOR"'

alias scan-code="cloc --exclude-dir=$(tr '\n' ',' < ~/.clocignore) ./"

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
