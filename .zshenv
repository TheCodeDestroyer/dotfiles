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

# common
export PATH=~/bin/exec:$PATH
export EDITOR=nano
export LANG="en_US.UTF-8"
# zsh
export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
### ZHS plugin stuff
export ZSH_PLUGINS_ALIAS_TIPS_EXCLUDES="g st y"
export ZSH_PLUGINS_ALIAS_TIPS_TEXT="You should use: "
# android
export ANDROID_HOME=~/Work/software/android/sdk
export PATH=${PATH}:~/Work/software/android/sdk/tools
export PATH=${PATH}:~/Work/software/android/sdk/tools/bin
export PATH=${PATH}:~/Work/software/android/sdk/platform-tools
# node
export NVM_LAZY_LOAD=true
export PATH=~/.yarn/bin:$PATH
# python
export PATH=~/.local/bin:$PATH
### Ansible
export ANSIBLE_NOCOWS=1
### Go
export PATH=~/go/bin:$PATH

