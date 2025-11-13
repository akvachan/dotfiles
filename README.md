# Software and Hardware


|                     |                                                                                   | Config                                           |
| ------------------- | --------------------------------------------------------------------------------- | ------------------------------------------------ |
| **Editor**          | [Neovim](https://github.com/neovim/neovim)                                        | [`config/nvim`](./.config/nvim)                   |
| **Terminal**        | [Kitty](https://github.com/kovidgoyal/kitty)                                      | [`config/kitty`](./.config/kitty)                 |
| **Window Manager**  | [AeroSpace](https://github.com/nikitabobko/AeroSpace)                             | [`config/aerospace`](./.config/aerospace)         |
| **Package Manager** | [Brew](https://brew.sh/)                                                          | [`config/brew/Brewfile`](./.config/brew/Brewfile) |
| **Shell**           | Zsh via [zsh4humans](https://github.com/romkatv/zsh4humans)                       | [`.zshrc`](./.zshrc)                             |
| **Keyboard**        | [Custom Dactyl Manuform](https://cyboard.digital/products/custom-dactyl-manuform) | —                                                |
| **Layout**          | [Colemak](https://en.wikipedia.org/wiki/Colemak)                                  | —                                                |


<img width="1582" height="743" alt="Screenshot 2025-08-14 at 17 00 04" src="https://github.com/user-attachments/assets/a0952fc9-1b44-4b88-bebd-c7de42cf9c21" />
<img width="1569" height="735" alt="Screenshot 2025-08-14 at 17 00 32" src="https://github.com/user-attachments/assets/d4acef75-3106-4118-b4a1-bbc0b7ffd426" />

---

# Goodies

* **Text manipulation across Cocoa-based apps** [KeyBindings](https://github.com/ttscoff/KeyBindings)
* **Reserved Hyper key** (mapped to `RAlt`) for window manager control: [Raycast Hyper Key](https://manual.raycast.com/hyperkey)
* **Menu bar system monitor (RAM / CPU / GPU):** [Stats](https://github.com/exelban/stats)

---

# Setup

1. **Dotfiles management**
   All configs are managed via a Git “alias repository.”
   Follow this tutorial: [https://www.atlassian.com/git/tutorials/dotfiles](https://www.atlassian.com/git/tutorials/dotfiles)

2. **Apps installed via Homebrew**
   All apps, fonts, and CLI packages are listed in the `Brewfile`:

   ```
   brew bundle install --file .config/brew/Brewfile
   ```

3. **Secrets**
   Stored in `.env.zsh` and loaded dynamically from `.zshrc`.

---

# Optional Tweaks (macOS only)

Run the full script:
`bash .config/scripts/macos-shortcuts.sh`

Or execute individual commands:

### Desktop & UI

* Set macOS wallpaper to Stone Grey:

```sh
osascript -e 'tell application "System Events" to tell every desktop to set picture to POSIX file "/System/Library/Desktop Pictures/Solid Colors/Stone.png"'
```

* Save screenshots directly to clipboard:

```sh
defaults write com.apple.screencapture target clipboard
killall SystemUIServer
```

* Make UI animations instant:

```sh
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
defaults write -g NSWindowResizeTime -float 0.001
defaults write com.apple.dock expose-animation-duration -float 0
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock autohide-delay -float 0
```

* Autohide the Dock:

```sh
defaults write com.apple.dock autohide -bool true
killall Dock
```

* Disable reopening apps after restart:

```sh
defaults write com.apple.loginwindow TALLogoutSavesState -bool false
defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false
```

* Move windows by dragging any part of them:

```sh
defaults write -g NSWindowShouldDragOnGesture -bool true
```

### Input & Trackpad

* Make right-click the primary click:

```sh
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 2
killall SystemUIServer
```

### Power & Privacy

* Set sleep to 30 min for all power modes:

```sh
sudo pmset -a sleep 30
```

* Disable AirDrop:

```sh
defaults write com.apple.sharingd AirDrop -int 0
```

### Keybindings & Simulator

```sh
# Mail: Ctrl-F to Search
defaults write com.apple.mail NSUserKeyEquivalents -dict "Mailbox Search" "^f"

# Simulator: Rotate left/right with Ctrl-H / Ctrl-L
defaults write com.apple.iphonesimulator NSUserKeyEquivalents -dict \
    "Rotate Left" "^h" \
    "Rotate Right" "^l"

# Enable Ctrl + Scroll to Zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 0
```
