# vim:fileencoding=utf-8:foldmethod=marker

export VISUAL=nvim
export EDITOR=nvim
setopt auto_cd
setopt SHARE_HISTORY
setopt hist_ignore_dups
setopt hist_expire_dups_first

autoload -U compinit
compinit

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh --cmd cd)"
fi

typeset -U path PATH
path=(
  # Ruby (rbenv)
  "$HOME/.rbenv/shims"

  # General binaries
  "$HOME/bin"

  # Rust
  "$HOME/.cargo/bin"

  # Python / pipx
  "$HOME/.local/bin"

  # Go
  "$HOME/go/bin"
  
  # Go (Linux)
  "/usr/local/go/bin"

  # llama.cpp (linux)
  "$HOME/projects/llama.cpp/build/bin/"

  # PGSQL
  "/opt/homebrew/opt/postgresql@18/bin"

  # Qdrant
  "$HOME/Development/Qdrant"

  # Lua language server (Linux)
  "/usr/local/lua-language-server/bin"

  # Neovim (Linux)
  "/opt/nvim-linux-x86_64/bin"

  $path
)
export PATH

alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias ossl="/opt/homebrew/bin/openssl"

if [ -f "$HOME/.env.zsh" ]; then
    source "$HOME/.env.zsh"
fi

PROMPT='%F{cyan}%d%f
%% '
