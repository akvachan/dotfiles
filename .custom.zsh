# Custom additional zsh config 

# Define a widget that opens nvim in the current directory
function nvim_cwd() {
  BUFFER="nvim ."
  zle accept-line
}
zle -N nvim_cwd
bindkey '^O' nvim_cwd

# Function to cd into projects
function fzf-proj() {
  local selected_dir
  selected_dir=$(find ~/Development -maxdepth 4 -type d \( -name ".venv" -o -name ".git" -o -name "node_modules" \) -prune -o -type d -print 2>/dev/null \
    | fzf --prompt="Select directory: " --height=40%)
  if [[ -n "$selected_dir" ]]; then
    BUFFER="cd \"$selected_dir\""
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fzf-proj
bindkey '^G' fzf-proj

# Function to fg into last halted process 
function fancy-ctrl-z() {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# z 
. /opt/homebrew/etc/profile.d/z.sh

# Custom sources 
autoload -Uz compinit
compinit
source <(kubectl completion zsh)

# Custom aliases
alias zshrc="nvim ~/.custom.zsh"
alias asrc="nvim ~/.config/aerospace/aerospace.toml"
alias nvimrc="nvim ~/.config/nvim/init.lua"
alias kittyrc="nvim ~/.config/kitty/kitty.conf"
alias brewrc="nvim ~/.config/brew/Brewfile"
alias qtbrc="nvim ~/.qutebrowser/config.py"
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias icat="kitten icat"
alias ssh="kitten ssh"
alias qwen="llama-cli -m ~/Library/Caches/llama.cpp/unsloth_Qwen2.5-Omni-7B-GGUF_Qwen2.5-Omni-7B-Q4_K_M.gguf"
alias qwen-server="llama-server -m ~/Library/Caches/llama.cpp/unsloth_Qwen2.5-Omni-7B-GGUF_Qwen2.5-Omni-7B-Q4_K_M.gguf --mmproj ~/Library/Caches/llama.cpp/unsloth_Qwen2.5-Omni-7B-GGUF_mmproj-F16.gguf"
alias phi="llama-cli -m ~/Library/Caches/llama.cpp/unsloth_Phi-4-reasoning-plus-GGUF_Phi-4-reasoning-plus-Q4_K_M.gguf"
alias phi-server="llama-server -m ~/Library/Caches/llama.cpp/unsloth_Phi-4-reasoning-plus-GGUF_Phi-4-reasoning-plus-Q4_K_M.gguf"
alias l="ls -la"
alias kubectl="minikube kubectl --"

# Custom exports
export VISUAL='nvim'
export EDITOR='nvim'
export PATH=$HOME/Development/Flutter/SDK/flutter/bin:$PATH
export PATH="/Users/arseniikvachan/.rbenv/shims:${PATH}"
export RBENV_SHELL=zsh
