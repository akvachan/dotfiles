# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Disable the theme if setting PROMPT manually
ZSH_THEME="apple"

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
alias zshrc="nvim ~/.zshrc"
alias skhdrc="nvim ~/.skhdrc"
alias yabairc="nvim ~/.yabairc"
alias nvimrc="nvim ~/.config/nvim/init.lua"
alias vimrc="nvim ~/.vimrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias dev="cd ~/Development"
alias dow="cd ~/Downloads"

# Fzf zsh
source <(fzf --zsh)
export FZF_BASE="/opt/homebrew/Cellar/fzf/0.56.3"
export DISABLE_FZF_AUTO_COMPLETION="true"
export DISABLE_FZF_KEY_BINDINGS="false"

# Source external environment variables (ensure this doesn't alter PROMPT)
. "$HOME/.local/bin/env"

# Node
export NODE_OPTIONS='--disable-warning=ExperimentalWarning'

# Vulkan 
export VULKAN_SDK=/Users/arseniikvachan/VulkanSDK/1.3.290.0

# Editor
export VISUAL='nvim'
export EDITOR='nvim'
