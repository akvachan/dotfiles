#!/bin/bash
# @raycast.schemaVersion 1
# @raycast.title Detach Current Safari Tab
# @raycast.mode silent
# @raycast.icon 🌐
# @raycast.packageName Safari

osascript <<'APPLESCRIPT'
tell application "System Events"
  if not (exists process "Safari") then return
end tell

tell application "Safari" to activate

-- Use UI scripting to trigger: Window → Move Tab to New Window
tell application "System Events"
  tell process "Safari"
    -- Ensure a window with a tab is frontmost
    if (count of windows) = 0 then return
    try
      click menu item "Move Tab to New Window" of menu "Window" of menu bar 1
    on error
      -- Fallback for locales where the menu name is slightly different
      -- Try by index: usually the item is near "Merge All Windows" and "Bring All to Front"
      set theMenu to menu "Window" of menu bar 1
      set itemsText to name of menu items of theMenu
      repeat with i from 1 to count of itemsText
        if (item i of itemsText) contains "Move Tab to New Window" then
          click menu item i of theMenu
          exit repeat
        end if
      end repeat
    end try
  end tell
end tell
APPLESCRIPT
