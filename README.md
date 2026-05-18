# dotfiles

## Debian

```sh
         _,met$$$$$gg.         user@server
     ,g$$$$$$$$$$$$$$$P.       ---------------
   ,g$$P""       """Y$$.".     OS: Debian GNU/Linux 13 (trixie) x86_64
  ,$$P'              `$$$.     Host: KVM/QEMU Standard PC (i440FX + PIIX, 1996) (pc-i440fx-9.0)
',$$P       ,ggs.     `$$b:    Kernel: Linux 6.12.88+deb13-cloud-amd64
`d$$'     ,$P"'   .    $$$     Uptime: 43 mins
 $$P      d$'     ,    $$P     Packages: 960 (dpkg)
 $$:      $$.   -    ,d$$'     Shell: zsh 5.9
 $$;      Y$b._   _,d$P'       Terminal: /dev/pts/0
 Y$$.    `.`"Y$$$$P"'          CPU: AMD EPYC (with IBPB) (12) @ 2.50 GHz
 `$$b      "-.__               GPU: Unknown Device 1111 (VGA compatible)
  `Y$$b                        Memory: 47.05 GiB
   `Y$$.                       Swap: Disabled
     `$$b.                     Disk (/): 245.87 GiB - ext4
       `Y$$b.                  Local IP (eth0): leaked
         `"Y$b._               Locale: C.UTF-8
             `""""
```
   

1. (Optional) Run ssh through kitten:
```sh
kitten ssh user@server
```

2. Create a new file:
```
vim setup.sh
```

3. Copy and paste setup script [.config/vm/setup.sh](.config/vm/setup.sh).

4. Run the setup script:
```sh
sh setup.sh
```

## macOS
  
```sh
                     ..'          user@personal
                 ,xNMM.           -----------------
               .OMMMMo            OS: macOS Tahoe 26.5 (25F71) arm64
               lMM"               Host: MacBook Pro (16-inch, 2021)
     .;loddo:.  .olloddol;.       Kernel: Darwin 25.5.0
   cKMMMMMMMMMMNWMMMMMMMMMM0:     Uptime: 2 hours, 13 mins
 .KMMMMMMMMMMMMMMMMMMMMMMMWd.     Packages: 145 (brew), 20 (brew-cask)
 XMMMMMMMMMMMMMMMMMMMMMMMX.       Shell: zsh 5.9
;MMMMMMMMMMMMMMMMMMMMMMMM:        Display (32M2N6800M): 3840x2160 @ 2x in 32", 60 Hz [External] *
:MMMMMMMMMMMMMMMMMMMMMMMM:        Display (Color LCD): 3840x2160 @ 2x, 120 Hz [Built-in]
.MMMMMMMMMMMMMMMMMMMMMMMMX.       WM: Quartz Compositor 1.600.0 (with AeroSpace 0.20.3-Beta)
 kMMMMMMMMMMMMMMMMMMMMMMMMWd.     WM Theme: Multicolor (Dark)
 'XMMMMMMMMMMMMMMMMMMMMMMMMMMk    Theme: Liquid Glass
  'XMMMMMMMMMMMMMMMMMMMMMMMMK.    Font: .AppleSystemUIFont [System], Helvetica [User]
    kMMMMMMMMMMMMMMMMMMMMMMd      Cursor: Fill - Black, Outline - White (32px)
     ;KMMMMMMMWXXWMMMMMMMk.       Terminal: kitty 0.46.2
       "cooc*"    "*coo'"         Terminal Font: HackNFM-Regular (22pt)
                                  CPU: Apple M1 Pro (10) @ 3.23 GHz
                                  GPU: Apple M1 Pro (16) @ 1.30 GHz [Integrated]
                                  Memory: 16.00 GiB
                                  Swap: Unused
                                  Disk (/): 460.43 GiB - apfs [Read-only]
                                  Local IP (en0): leaked
                                  Locale: en_US.UTF-8
```

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


## Goodies

Dump all currently installed packages with description into a Brewfile:
```
brew bundle dump --describe --file .config/brew/Brewfile --force
```

Install only packages that are in Brewfile, and remove everything else:
```
brew bundle --cleanup --file .config/brew/Brewfile --force
```
