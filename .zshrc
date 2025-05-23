#!/bin/sh
 
#: {{{ oh-my-zsh

ZSH_THEME="apple"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
plugins=(
  git
  fzf
  zsh-syntax-highlighting
  fancy-ctrl-z
)
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

#: }}} 

#: {{{ Custom Functions

# Function to fuzzy search projects 
function fzf-cd() {
  local dir
  dir=$(
    find ~/Development \
      -maxdepth 5 \
      \( -name '.*' -prune \) \
      -o -type d -print \
    | fzf
  ) && cd "$dir"
}

#: }}}

#: {{{ Keybinds

bindkey -s '^F' 'fzf-cd\n'

#: }}}
 
#: {{{ Aliases

alias zshrc="nvim ~/.zshrc"
alias asrc="nvim ~/.config/aerospace/aerospace.toml"
alias nvimrc="nvim ~/.config/nvim/init.lua"
alias kittyrc="nvim ~/.config/kitty/kitty.conf"
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias icat="kitten icat"
alias ssh="kitten ssh"

#: }}}
 
#: {{{ Exports

export VISUAL='nvim'
export EDITOR='nvim'
export VULKAN_SDK=/Users/arseniikvachan/VulkanSDK/1.3.290.0
export STM32CubeMX_PATH=/Applications/STMicroelectronics/STM32CubeMX.app/Contents/Resources
export STM32_PRG_PATH=/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin

#: }}}
