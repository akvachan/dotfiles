# vim:fileencoding=utf-8:foldmethod=marker

export VISUAL=nvim
export EDITOR=nvim
setopt auto_cd
setopt SHARE_HISTORY
setopt hist_ignore_dups
setopt hist_expire_dups_first

autoload -U compinit
compinit
eval "$(zoxide init zsh --cmd cd)"

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
alias ossl="/opt/homebrew/bin/openssl"
source $HOME/.env.zsh

PROMPT='%F{cyan}%d%f
%# '
