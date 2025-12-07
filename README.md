# Software and Hardware

|                     |                                                                                   | Config                                           |
| ------------------- | --------------------------------------------------------------------------------- | ------------------------------------------------ |
| **Editor**          | [Neovim](https://github.com/neovim/neovim)                                        | [`config/nvim`](./.config/nvim)                   |
| **Terminal**        | [Kitty](https://github.com/kovidgoyal/kitty)                                      | [`config/kitty`](./.config/kitty)                 |
| **Window Manager**  | [AeroSpace](https://github.com/nikitabobko/AeroSpace)                             | [`config/aerospace`](./.config/aerospace)         |
| **Package Manager** | [Brew](https://brew.sh/)                                                          | [`config/brew/Brewfile`](./.config/brew/Brewfile) |
| **Shell**           | Zsh                                                                               | [`.zshrc`](./.zshrc)                             |
| **Keyboard**        | [Custom Dactyl Manuform](https://cyboard.digital/products/custom-dactyl-manuform) | —                                                |
| **Layout**          | [Colemak](https://en.wikipedia.org/wiki/Colemak)                                  | —                                                |


<img width="1582" height="743" alt="Screenshot 2025-08-14 at 17 00 04" src="https://github.com/user-attachments/assets/a0952fc9-1b44-4b88-bebd-c7de42cf9c21" />
<img width="1569" height="735" alt="Screenshot 2025-08-14 at 17 00 32" src="https://github.com/user-attachments/assets/d4acef75-3106-4118-b4a1-bbc0b7ffd426" />

---

# Goodies

* **Text manipulation across Cocoa-based apps** [KeyBindings](https://github.com/ttscoff/KeyBindings)
* **Reserved Hyper key** (mapped to `RAlt`) for window manager control and launching apps: [Raycast Hyper Key](https://manual.raycast.com/hyperkey)
* **Menu bar system monitor (RAM / CPU / GPU):** [Stats](https://github.com/exelban/stats)

---

# Setup

1. **Dotfiles management**
   All configs are managed via a Git "alias repository".
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
```
sh .config/scripts/macos-shortcuts.sh 
````
