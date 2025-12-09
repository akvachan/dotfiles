#!/bin/zsh

set -euo pipefail
setopt extended_glob null_glob

SESSIONS_DIR="${HOME}/.config/kitty/sessions"

# Collect all .kitty-session files 
session_paths=("${SESSIONS_DIR}"/**/*.kitty-session(N))

# Build list for fzf: "name | full_path"
session_list=$(
  for path in "${session_paths[@]}"; do
    rel="${path#$SESSIONS_DIR/}"
    base="${rel:t}"          # basename
    name="${base%.kitty-session}"
    echo "${name} | ${path}"
  done
)

selected=$(echo "$session_list" | /opt/homebrew/bin/fzf \
  --prompt="Select session: " \
  --layout=reverse \
  --with-nth=1 \
  --delimiter=' | ' \
  --preview-window=up:1 \
  || true
)

if [ -n "${selected:-}" ]; then
  session_path=$(echo "$selected" | awk -F' \\| ' '{print $2}')
  kitty @ action goto_session "$session_path"
  kitty @ close-window --self
else
  kitty @ close-window
fi
