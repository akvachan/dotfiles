#!/bin/zsh
 
set -euo pipefail

# Get all tabs, including their ids and focused status
tab_info=$(kitty @ ls | /opt/homebrew/bin/jq -r '.[].tabs[] | "\(.id)|\(.is_focused)|\(.title)"')
 
# Filter out the focused tab and prepare the list for fzf
# Format: "last_directory (id: tab_id) | full_path | tab_id"
tab_titles=$(echo "$tab_info" | awk -F'|' '$2 == "false" {
    split($3, path, "/")
    last_dir = path[length(path)]
    if (last_dir == "") last_dir = "/"
    print last_dir " (id: " $1 ") | " $3 " | " $1
}')
 
# Use fzf to fuzzy search the tab titles
selected=$(echo "$tab_titles" | /opt/homebrew/bin/fzf --prompt="Select tab: " \
    --layout=reverse \
    --with-nth=1 \
    --delimiter=' | ' \
    --preview-window=up:1 \
  )
 
# If a tab was selected, focus on that tab using its ID
if [ -n "$selected" ]; then
    tab_id=$(echo "$selected" | awk -F' \\| ' '{print $3}')
    kitty @ focus-tab --match id:"$tab_id"
    kitty @ close-window --self
else
    kitty @ close-window 
fi
