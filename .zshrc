#!/bin/sh
 
#: Oh My Zsh Settings {{{
 
#: Color Theme {{{
 
ZSH_THEME="apple"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
 
# }}}
 
#: Plugins {{{
 
plugins=(
  git
  fzf
  zsh-syntax-highlighting
)
 
# }}}
 
#: Installation {{{
 
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
 
# }}}
 
# }}}
 
#: Basic Settings {{{
 
#: Functions {{{
 
fzf-nvim() {
  local dir
  dir=$(find ~/Development -type d | fzf) && nvim --cmd "cd $dir" "$dir"
}

fzf-cd() {
  local dir
  dir=$(find ~/Development -type d | fzf) && cd $dir
}
 
# }}}
 
#: Aliases {{{
 
alias zshrc="nvim ~/.zshrc"
alias skhdrc="nvim ~/.skhdrc"
alias yabairc="nvim ~/.yabairc"
alias nvimrc="nvim ~/.config/nvim/init.lua"
alias vimrc="nvim ~/.vimrc"
alias tmuxrc="nvim ~/.tmux.conf"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias dev="cd ~/Development"
alias dow="cd ~/Downloads"
alias sleep="sudo shutdown -s now"
alias restart="sudo shutdown -r now"
alias out="sudo pkill loginwindow"
alias shutdown="sudo shutdown -h now"
alias f='fzf-nvim'
alias fcd='fzf-cd'
 
# }}}
 
#: Editor {{{
 
export VISUAL='nvim'
export EDITOR='nvim'
 
# }}}
 
# }}}
 
#: Extra {{{
 
#: VulkanSDK {{{
 
export VULKAN_SDK=/Users/arseniikvachan/VulkanSDK/1.3.290.0
 
# }}}
 
#: STM32CubeMX {{{
 
export STM32CubeMX_PATH=/Applications/STMicroelectronics/STM32CubeMX.app/Contents/Resources
export STM32_PRG_PATH=/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin
 
# }}}

# }}} 
