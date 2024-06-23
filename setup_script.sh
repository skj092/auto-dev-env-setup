#!/bin/bash
set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install a package if it's not already installed
install_package() {
    if ! command_exists "$1"; then
        echo "Installing $1..."
        sudo apt-get install -y "$1"
    else
        echo "$1 is already installed."
    fi
}

# Update package lists
sudo apt-get update

# Install essential packages
install_package build-essential
install_package sudo
install_package ninja-build
install_package gettext
install_package cmake
install_package unzip
install_package curl
install_package git
install_package fzf

# Clone dotfiles repository
# Clone dotfiles repository
if [ ! -d "$HOME/.dotfiles" ]; then
    echo "Cloning dotfiles repository (custom branch)..."
    git clone -b custom https://github.com/skj092/.dotfiles.git "$HOME/.dotfiles"
else
    echo "Dotfiles repository already exists. Updating..."
    cd "$HOME/.dotfiles"
    git fetch origin custom
    git checkout custom
    git pull origin custom
    cd "$HOME"
fi

# Install and configure Neovim
if ! command_exists nvim; then
    echo "Installing Neovim..."
    git clone https://github.com/neovim/neovim.git
    cd neovim
    git checkout stable
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
    cd ..
    rm -rf neovim
else
    echo "Neovim is already installed."
fi

# Setup Neovim configuration
if [ ! -L "$HOME/.config/nvim" ]; then
    echo "Setting up Neovim configuration..."
    mkdir -p "$HOME/.config"
    ln -s "$HOME/.dotfiles/nvim/.config/nvim" "$HOME/.config/nvim"
else
    echo "Neovim configuration symlink already exists."
fi

# Install Packer for Neovim
if [ ! -d "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
    echo "Installing Packer for Neovim..."
    git clone --depth 1 https://github.com/wbthomason/packer.nvim \
        "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
else
    echo "Packer is already installed."
fi

# Install and configure Tmux
install_package tmux
if [ ! -f "$HOME/.tmux.conf" ]; then
    echo "Setting up Tmux configuration..."
    ln -s "$HOME/.dotfiles/tmux/.tmux.conf" "$HOME/.tmux.conf"
else
    echo "Tmux configuration already exists."
fi

# Install Tmux Plugin Manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
    echo "Tmux Plugin Manager is already installed."
fi

# Install Zsh and Oh My Zsh
install_package zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh is already installed."
fi

# Install Stow for managing dotfiles
install_package stow

# Stow dotfiles
echo "Symlinking dotfiles..."

# Add ~/.local/bin to PATH if not already there
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

echo "Development environment setup completed."
