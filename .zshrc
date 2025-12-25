# basics
export VISUAL=nvim
export EDITOR=nvim
setopt auto_cd
setopt SHARE_HISTORY
setopt hist_ignore_dups
setopt hist_expire_dups_first

# plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source <(fzf --zsh)

# brew
eval "$(brew shellenv)"
autoload -Uz compinit
compinit

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
alias asrc="nvim ~/.config/aerospace/aerospace.toml"
alias nvimrc="nvim ~/.config/nvim/init.lua"
alias kittyrc="nvim ~/.config/kitty/kitty.conf"
alias brewrc="nvim ~/.config/brew/Brewfile"
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias icat="kitten icat"
alias ssh="kitten ssh"
alias diff="kitten diff"
alias gdiff="git difftool --no-symlinks --dir-diff"
alias l="ls -la"
alias kubectl="minikube kubectl --"

# linux scheisse
[ "$(tty)" = "/dev/tty1" ] && exec sway

typeset -U path PATH
path=(
  # Ruby (rbenv)
  "$HOME/.rbenv/shims"

  # Rust
  "$HOME/.cargo/bin"

  # Python / pipx
  "$HOME/.local/bin"

  # Go
  "$(go env GOPATH)/bin"

  # PGSQL
  "/opt/homebrew/opt/postgresql@18/bin"

  $path
)
export PATH

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
