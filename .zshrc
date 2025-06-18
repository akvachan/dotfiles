#!/bin/sh

#: {{{ Powerlevel10k

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
 source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#: }}}

#: {{{ Functions

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

#: {{{ Sources

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

#: }}}
