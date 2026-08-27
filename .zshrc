_zcompcache=${ZSH_CACHE_DIR}/completions
[[ -d $_zcompcache ]] || mkdir -p $_zcompcache

# Plugins load before compinit so they can extend $fpath (zsh-completions,
# orbstack) and compinit only has to scan it once. They also call compdef at
# source time, before compinit has defined it, so buffer those calls and replay
# them below. Running compinit twice instead — once here, once deferred from
# sheldon.toml — cost ~700ms of stall right after every prompt.
_pending_compdefs=()
compdef() { _pending_compdefs+=( "${(F)@}" ) }

eval "$(sheldon source)"

typeset -U path fpath   # plugins re-add entries that are already present

# The mise/bun/gh/kubectl plugins regenerate completions into $_zcompcache on
# every startup, but nothing else ever puts it on $fpath — so compinit never
# picked any of them up.
fpath=( $_zcompcache $fpath )

# -C reuses the dump and skips the compaudit scan; rebuild in full at most once
# a day so newly installed completions still get picked up.
autoload -Uz compinit
_zcompdump=${ZDOTDIR:-$HOME}/.zcompdump
_zcompfresh=( ${_zcompdump}(N.mh-24) )   # empty when missing or >24h old
compinit -d $_zcompdump ${_zcompfresh:+-C}
# Without this the dump is reparsed from source (~56KB) by every new shell.
[[ $_zcompdump.zwc -nt $_zcompdump ]] || zcompile -R -- $_zcompdump.zwc $_zcompdump

for _cd in $_pending_compdefs; do compdef "${(@f)_cd}"; done
unset _zcompcache _zcompdump _zcompfresh _pending_compdefs _cd

eval "$(fasd --init auto)"

#PROFILES
source ~/.profile

#FUNCTIONS
source ~/.zshfn

case $OSTYPE in
  darwin*)
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
  ;;
  linux*)
    bindkey "$terminfo[kcuu1]" history-substring-search-up
    bindkey "$terminfo[kcud1]" history-substring-search-down
  ;;
esac

#CURSOR MOVEMENT
# WezTerm sends CSI 1;3 for Alt+Arrow and CSI 1;5 for Ctrl+Arrow; zsh binds
# neither by default. Cmd+Arrow is mapped to Home/End in ~/.wezterm.lua.
bindkey '^[[1;3D' backward-word      # Alt + Left
bindkey '^[[1;3C' forward-word       # Alt + Right
bindkey '^[[1;5D' backward-word      # Ctrl + Left
bindkey '^[[1;5C' forward-word       # Ctrl + Right
bindkey '^[[H'    beginning-of-line  # Home  (sent by Cmd + Left)
bindkey '^[[F'    end-of-line        # End   (sent by Cmd + Right)

#COMPLETION OPTION STACKING
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# agent-browser: auto-close idle browser after 1h to prevent runaway Chrome processes
export AGENT_BROWSER_IDLE_TIMEOUT_MS=3600000

#PROMPT
# starship's init (via the ohmyzsh starship plugin, inside `sheldon source`
# above) always sets RPROMPT to a $(starship prompt --right ...) subshell, even
# when starship.toml defines no right_format -- so it forks a process per
# redraw just to print nothing. Clear it here, afterwards.
#
# It is also load-bearing, not just a micro-optimisation: nothing may sit at
# the right margin, or starship's stale-width fork wraps the line and smears
# debris down the screen. Full mechanism in ~/.config/starship.toml.
#
# This must stay AFTER the plugin runs, so do not `apply = ['defer']` to
# [plugins.ohmyzsh] in sheldon.toml -- the clear would lose the race silently.
#
# Do NOT add a TRAPWINCH calling `zle reset-prompt` here: zsh already redraws
# on WINCH, so a trap doubles every repaint and doubles the debris. Measured.
RPROMPT=''
