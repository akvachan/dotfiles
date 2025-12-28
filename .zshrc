# basics
export VISUAL=nvim
export EDITOR=nvim
setopt auto_cd
setopt SHARE_HISTORY
setopt hist_ignore_dups
setopt hist_expire_dups_first

# z 
source /opt/homebrew/etc/profile.d/z.sh
autoload -U compinit; compinit
zstyle ':completion:*' menu select

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

alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
