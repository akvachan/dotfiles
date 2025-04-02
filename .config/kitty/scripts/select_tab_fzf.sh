#!/bin/bash

# Get all tabs and their titles
tab_info=$(kitty @ ls | /opt/homebrew/bin/jq -r '.[].tabs[] | .title')

# Use fzf to fuzzy search the tab titles
selected=$(echo "$tab_info" | /opt/homebrew/bin/fzf --prompt="Select tab: ")

# If a tab was selected, focus on that tab
if [ -n "$selected" ]; then
    # Get the tab ID of the selected tab
    tab_id=$(kitty @ ls | /opt/homebrew/bin/jq -r --arg title "$selected" \
        '.[].tabs[] | select(.title == $title) | .id')

    # Focus the selected tab by its ID
    kitty @ focus-tab --match id:"$tab_id"
else
    echo "No tab selected or operation cancelled."
fi
