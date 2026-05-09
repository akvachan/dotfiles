#!/usr/bin/env bash
set -Eeuo pipefail

_echo() {
  echo "\033[36m$*\033[0m"
}

# APT
_echo "Updating apt"
sudo apt update -y

_echo "Installing apt packages"
sudo apt install -y git gcc g++ zsh zoxide fd-find bpytop clangd npm nodejs libclang-19-dev fastfetch

# files & directories
_echo "Creating base directories"
mkdir -p "$HOME/downloads" "$HOME/projects" "$HOME/.config"
touch "$HOME/.env.zsh"

# dotfiles
DOTFILES_DIR="$HOME/projects/dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
  _echo "Cloning dotfiles"
  git clone https://github.com/akvachan/dotfiles "$DOTFILES_DIR"
else
  _echo "Dotfiles already present"
fi

# symlinks
_echo "Setting up symlinks"
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sfn "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"

# Default shell
if [ "$(basename "$SHELL")" != "zsh" ]; then
  _echo "Setting zsh as default shell"
  chsh -s "$(which zsh)"
else
  _echo "zsh already default"
fi

# uv
if ! command -v uv >/dev/null 2>&1; then
  _echo "Installing uv"
  wget -qO- https://astral.sh/uv/install.sh | sh
else
  _echo "uv already installed, skipping"
fi

. "$HOME/.local/bin/env"

# Python tools via uv
_echo "Configuring Python toolchain"
uv python pin --global 3.14.4
uv tool list | grep -q "^ruff" || uv tool install ruff@latest
uv tool list | grep -q "^ty"   || uv tool install ty@latest

# Go
GO_VERSION="1.26.3"
GO_TARBALL="go${GO_VERSION}.linux-amd64.tar.gz"

if [ ! -x "$(command -v go)" ] || ! go version | grep -q "$GO_VERSION"; then
  _echo "Installing Go $GO_VERSION"
  wget -c "https://go.dev/dl/$GO_TARBALL"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "$GO_TARBALL"
else
  _echo "Go already installed, skipping"
fi

# Rust
if ! command -v cargo >/dev/null 2>&1; then
  _echo "Installing Rust"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  . "$HOME/.cargo/env"
else
  _echo "Rust already installed"
fi

# tree-sitter-cli
if ! command -v tree-sitter >/dev/null 2>&1; then
  _echo "Installing tree-sitter-cli"
  cargo install --locked tree-sitter-cli
else
  _echo "tree-sitter already installed"
fi

# Lua language server
LUA_DIR="/usr/local/lua-language-server"
if [ ! -d "$LUA_DIR" ]; then
  _echo "Installing lua-language-server"
  LUA_TAR="lua-language-server.tar.gz"
  wget -O "$LUA_TAR" \
    https://github.com/LuaLS/lua-language-server/releases/latest/download/lua-language-server-3.18.2-linux-arm64.tar.gz

  sudo mkdir -p "$LUA_DIR"
  sudo tar -C "$LUA_DIR" -xzf "$LUA_TAR"
else
  _echo "lua-language-server already installed"
fi

# npm global tools
_echo "Installing TypeScript language server"
npm list -g typescript-language-server >/dev/null 2>&1 || npm install -g typescript-language-server typescript

# Neovim
if ! command -v nvim >/dev/null 2>&1; then
  _echo "Installing Neovim"
  NVIM_TAR="nvim-linux-x86_64.tar.gz"
  wget -O "$NVIM_TAR" https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  sudo rm -rf /opt/nvim-linux-x86_64
  sudo tar -C /opt -xzf "$NVIM_TAR"
else
  _echo "Neovim already installed"
fi

# finish
_echo "Setup complete. Rebooting in 5 seconds..."
sleep 5

sudo reboot
