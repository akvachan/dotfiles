# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Disable the theme if setting PROMPT manually
ZSH_THEME="apple"

# Selection colors or general UI colors
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export LS_COLORS="di=1;34:ln=1;36:so=1;32:pi=1;33:ex=1;31:bd=1;36:cd=1;36:su=1;37:sg=1;30:tw=1;34:ow=1;34"

# Ensure directory highlighting matches your selection background
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Plugins
plugins=(
  git
  fzf
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Aliases
alias zshconfig="vi ~/.zshrc"
alias ohmyzsh="vi ~/.oh-my-zsh"
alias vi="nvim"
alias vim="nvim"
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"

# Fzf zsh
source <(fzf --zsh)
export FZF_BASE="/opt/homebrew/Cellar/fzf/0.56.3"
export DISABLE_FZF_AUTO_COMPLETION="true"
export DISABLE_FZF_KEY_BINDINGS="false"

# Clear downloads DB
alias cleardw="sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"
alias clearch="sudo killall -HUP mDNSResponder; sudo killall mDNSResponder; sudo dscacheutil -flushcache"

# Source external environment variables (ensure this doesn't alter PROMPT)
. "$HOME/.local/bin/env"

# Node
export NODE_OPTIONS='--disable-warning=ExperimentalWarning'

# Vulkan 
export VULKAN_SDK=/Users/arseniikvachan/VulkanSDK/1.3.290.0
