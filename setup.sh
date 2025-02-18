#!/bin/bash

# setup.sh
echo "Starting development environment setup..."

# Function to check if command was successful
check_status() {
    if [ $? -eq 0 ]; then
        echo "✅ $1 successful"
    else
        echo "❌ $1 failed"
        exit 1
    fi
}

# 1. Install Neovim
echo "Installing Neovim..."
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz
check_status "Neovim installation"

# Add Neovim to PATH if not already present
if ! grep -q "export PATH=\"\$PATH:/opt/nvim-linux-x86_64/bin\"" ~/.zshrc; then
    echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.zshrc
fi

# 2. Setup Neovim configuration
echo "Setting up Neovim configuration..."
git clone https://github.com/skj092/init.lua.git
cd init.lua
git checkout my_config
mv init.lua nvim
mkdir -p ~/.config
mv nvim ~/.config/nvim/
cd ..
rm -rf init.lua
check_status "Neovim configuration setup"

# 2.1 Install Packer
echo "Installing Packer..."
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
check_status "Packer installation"

# 3. Install Zsh if not already installed
if ! command -v zsh &> /dev/null; then
    echo "Installing Zsh..."
    sudo apt-get update
    sudo apt-get install -y zsh
    check_status "Zsh installation"
fi

# Install Oh My Zsh if not already installed
if [ ! -d ~/.oh-my-zsh ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    check_status "Oh My Zsh installation"
fi

# 4. Setup dotfiles
echo "Setting up dotfiles..."
git clone https://github.com/skj092/.dotfiles.git
ln -sf ~/.dotfiles/zsh/.zshrc ~/.zshrc
check_status "Dotfiles setup"

# 5. Install zsh-autosuggestions
echo "Installing zsh-autosuggestions..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
check_status "zsh-autosuggestions installation"

echo "🎉 Setup completed successfully!"
echo "Please restart your terminal or run 'source ~/.zshrc' to apply changes."
