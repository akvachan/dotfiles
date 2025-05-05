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
alias asrc="nvim ~/.config/aerospace/aerospace.toml"
alias nvimrc="nvim ~/.config/nvim/init.lua"
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias ff='fzf-cd'
 
# }}}
 
#: Editor {{{
 
set -o vi
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
