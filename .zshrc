# basics
export VISUAL=nvim
export EDITOR=nvim

# brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# path
export PATH="$HOME/Development/Flutter/SDK/flutter/bin:$PATH"
export PATH="$HOME/.rbenv/shims:$PATH"
export RBENV_SHELL=zsh

# plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source <(fzf --zsh)

# history
bindkey '^P' up-line-or-history
bindkey '^N' down-line-or-history

# perf optimization / caching
export KEYTIMEOUT=1
autoload -Uz compinit
if [[ ! -d "$HOME/.zcompcache" ]]; then
  mkdir "$HOME/.zcompcache"
fi
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zcompcache"
zstyle ':completion:*' menu select
compinit

# prompt
fpath+=("/opt/homebrew/share/zsh/site-functions")
autoload -U promptinit; promptinit
prompt pure

# open nvim in cwd
function nvim_cwd() {
  BUFFER="nvim ."
  zle accept-line
}
zle -N nvim_cwd
bindkey '^O' nvim_cwd

# project selector
function fzf-proj() {
  local selected_dir
  selected_dir=$(find ~/Development -maxdepth 4 \
    -type d \( -name ".venv" -o -name ".git" -o -name "node_modules" \) -prune \
    -o -type d -print 2>/dev/null \
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

# fancy Ctrl-Z
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

# z scheisse
if [[ "$(uname -s)" == "Darwin" ]]; then
  source /opt/homebrew/etc/profile.d/z.sh
elif [[ "$(uname -s)" == "Linux" ]]; then
  source ~/.config/zsh/zsh-z.plugin.zsh
fi

# aliases
alias zshrc="nvim ~/.zshrc"
alias swayrc="nvim ~/.config/sway/config"
alias asrc="nvim ~/.config/aerospace/aerospace.toml"
alias nvimrc="nvim ~/.config/nvim/init.lua"
alias kittyrc="nvim ~/.config/kitty/kitty.conf"
alias brewrc="nvim ~/.config/brew/Brewfile"
alias qtbrc="nvim ~/.qutebrowser/config.py"
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias icat="kitten icat"
alias ssh="kitten ssh"
alias diff="kitten diff"
alias cf="kitten choose-files"
alias gdiff="git difftool --no-symlinks --dir-diff"
alias qwen="llama-cli -m ~/Library/Caches/llama.cpp/unsloth_Qwen2.5-Omni-7B-GGUF_Qwen2.5-Omni-7B-Q4_K_M.gguf"
alias qwen-server="llama-server -m ~/Library/Caches/llama.cpp/unsloth_Qwen2.5-Omni-7B-GGUF_Qwen2.5-Omni-7B-Q4_K_M.gguf --mmproj ~/Library/Caches/llama.cpp/unsloth_Qwen2.5-Omni-7B-GGUF_mmproj-F16.gguf"
alias phi="llama-cli -m ~/Library/Caches/llama.cpp/unsloth_Phi-4-reasoning-plus-GGUF_Phi-4-reasoning-plus-Q4_K_M.gguf"
alias phi-server="llama-server -m ~/Library/Caches/llama.cpp/unsloth_Phi-4-reasoning-plus-GGUF_Phi-4-reasoning-plus-Q4_K_M.gguf"
alias l="ls -la"
alias lg="lazygit"
alias kubectl="minikube kubectl --"

# linux scheisse
[ "$(tty)" = "/dev/tty1" ] && exec sway
