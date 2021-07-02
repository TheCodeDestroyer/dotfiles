# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/.zplug/init.zsh

# COMMANDS
zplug "clvv/fasd", as:command

# PLUGINS

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "zsh-users/zsh-completions"
zplug "zdharma/fast-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
zplug "djui/alias-tips"
zplug "Peltoche/lsd"
zplug "manlao/zsh-auto-nvm", defer:3
zplug "ptavares/zsh-direnv", defer:3
zplug "mattberther/zsh-pyenv", defer:3

zplug "plugins/history", from:oh-my-zsh
zplug "plugins/sudo",  from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh

zplug "plugins/git", from:oh-my-zsh
zplug "plugins/gitfast", from:oh-my-zsh
zplug "plugins/git-extras", from:oh-my-zsh
zplug "plugins/node", from:oh-my-zsh
zplug "plugins/nvm", from:oh-my-zsh
zplug "plugins/yarn", from:oh-my-zsh
zplug "plugins/github", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh
zplug "plugins/ansible", from:oh-my-zsh
zplug "plugins/encode64", from:oh-my-zsh
zplug "plugins/extract", from:oh-my-zsh
zplug "plugins/fasd", from:oh-my-zsh
zplug "plugins/kubectl", from:oh-my-zsh
zplug "plugins/helm", from:oh-my-zsh
zplug "plugins/httpie", from:oh-my-zsh

# Debian
zplug "plugins/debian", from:oh-my-zsh, if:"[[ $OSTYPE == *linux* ]]"
# OSX
zplug "plugins/osx", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"

# COMMANDS
zplug "clvv/fasd", as:command

# THEME
zplug "romkatv/powerlevel10k", as:theme, depth:1


# INIT
if zplug check || zplug install; then
  zplug load #--verbose
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if zplug check zsh-users/zsh-history-substring-search; then
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
fi

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
