# dotfiles

## macOS

|                     |                                                                                   | Config                                           |
| ------------------- | --------------------------------------------------------------------------------- | ------------------------------------------------ |
| **Editor**          | [Neovim](https://github.com/neovim/neovim)                                        | [`config/nvim`](./.config/nvim)                   |
| **Terminal**        | [Kitty](https://github.com/kovidgoyal/kitty)                                      | [`config/kitty`](./.config/kitty)                 |
| **Window Manager**  | [AeroSpace](https://github.com/nikitabobko/AeroSpace)                             | [`config/aerospace`](./.config/aerospace)         |
| **Package Manager** | [Brew](https://brew.sh/)                                                          | [`config/brew/Brewfile`](./.config/brew/Brewfile) |
| **Shell**           | Zsh                                                                               | [`.zshrc`](./.zshrc)                             |
| **Keyboard**        | [Custom Dactyl Manuform](https://cyboard.digital/products/custom-dactyl-manuform) | —                                                |
| **Layout**          | [Colemak](https://en.wikipedia.org/wiki/Colemak)                                  | —                                                |

1. Setup config files ([Original tutorial](https://www.atlassian.com/git/tutorials/dotfiles)):

- Clone this repo:
```
git clone --bare https://github.com/akvachan/dotfiles $HOME/.cfg
```

- Create alias:
```
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

- Create `.gitignore`:
```
echo ".cfg" >> .gitignore
```

- Checkout everything:
```
config checkout
```

- Do not track anything besides what is already in the repo:
```
config config --local status.showUntrackedFiles no
```

- Check status and you are done:
```
config status
```

2. Disable animations, Dock, AirDrop, SystemUIServer, set standard wallpaper:
```
sh .config/scripts/macos-setup.sh 
````

3. Install homebrew:
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

4. Install all packages:
```
brew bundle install --file .config/brew/Brewfile
```

5. Create local secrets file:
Stored in `.env.zsh` and loaded dynamically from `.zshrc`, so:
```
touch ~/.env.zsh
```

6. Reboot:
```
sudo reboot
```
