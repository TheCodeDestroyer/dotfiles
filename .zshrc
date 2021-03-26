# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/.zplug/init.zsh


# PLUGINS

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "zsh-users/zsh-completions"
zplug "zdharma/fast-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
zplug "djui/alias-tips"
zplug "Peltoche/lsd"
zplug "manlao/zsh-auto-nvm", defer:3
zplug "ptavares/zsh-direnv", defer:3

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

# Debian
zplug "plugins/debian", from:oh-my-zsh, if:"[[ $OSTYPE == *linux* ]]"
# OSX
zplug "plugins/osx", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"


# THEME
zplug "romkatv/powerlevel10k", as:theme, depth:1


# INIT
zplug load #--verbose

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if zplug check zsh-users/zsh-history-substring-search; then
    bindkey "$terminfo[kcuu1]" history-substring-search-up
    bindkey "$terminfo[kcud1]" history-substring-search-down
fi

if ! zplug check; then
    zplug install
fi

#ALIASES
alias ghee-default="ghee set --email the.code.destroyer@gmail.com"
alias ghee-work="ghee set --email nace.logar@3fs.si"

alias ls='lsd'

alias scan-code="cloc --exclude-dir=$(tr '\n' ',' < ~/.clocignore) ./"

function users
{
  cut -d: -f1 /etc/passwd
}
