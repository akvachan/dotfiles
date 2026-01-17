# vim:fileencoding=utf-8:foldmethod=marker

# {{{ Basic settings

export VISUAL=nvim
export EDITOR=nvim
setopt auto_cd
setopt SHARE_HISTORY
setopt hist_ignore_dups
setopt hist_expire_dups_first

# }}}

# {{{ Plugins 

# z 
source /opt/homebrew/etc/profile.d/z.sh
autoload -U compinit; compinit
zstyle ':completion:*' menu select

# }}}

# {{{ Path

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

# }}}

# {{{ Dotfiles config

alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"

# }}}

# {{{ Secrets

source .env.zsh

# }}}

# {{{ Prompt

PROMPT='%F{blue}%d%f %# '

# }}}
