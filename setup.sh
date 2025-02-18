#!/bin/bash

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

# Function to check if a directory exists
check_dir_exists() {
    if [ -d "$1" ]; then
        return 0 # true
    else
        return 1 # false
    fi
}

# 1. Install Neovim if not already installed
if ! command -v nvim &> /dev/null; then
    echo "Installing Neovim..."
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin' >> ~/.bashrc
    rm nvim-linux-x86_64.tar.gz
    check_status "Neovim installation"
else
    echo "✅ Neovim is already installed"
fi

# 2. Setup Neovim configuration if not already present
if ! check_dir_exists ~/.config/nvim; then
    echo "Setting up Neovim configuration..."
    git clone https://github.com/skj092/init.lua.git
    cd init.lua
    git checkout my_config
    cd ..
    mv init.lua nvim
    mkdir -p ~/.config
    mv nvim ~/.config/nvim/
    cd ..
    rm -rf init.lua
    check_status "Neovim configuration setup"
else
    echo "✅ Neovim configuration already exists"
fi

# 2.1 Install Packer if not already installed
if ! check_dir_exists ~/.local/share/nvim/site/pack/packer/start/packer.nvim; then
    echo "Installing Packer..."
    git clone --depth 1 https://github.com/wbthomason/packer.nvim\
     ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    check_status "Packer installation"
else
    echo "✅ Packer is already installed"
fi

# 3. Install Zsh if not already installed
if ! command -v zsh &> /dev/null; then
    echo "Installing Zsh..."
    sudo apt-get update
    sudo apt-get install -y zsh
    check_status "Zsh installation"
else
    echo "✅ Zsh is already installed"
fi

# Install Oh My Zsh if not already installed
if ! check_dir_exists ~/.oh-my-zsh; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    check_status "Oh My Zsh installation"
else
    echo "✅ Oh My Zsh is already installed"
fi

# 4. Setup dotfiles if not already present
if ! check_dir_exists ~/.dotfiles; then
    echo "Setting up dotfiles..."
    git clone https://github.com/skj092/.dotfiles.git ~/.dotfiles
    cd ~/.dotfiles/
    git checkout my_config
    cd -
    ln -sf ~/.dotfiles/zsh/.zshrc ~/.zshrc
    ln -sf ~/.dotfiles/zsh/.zsh_profile ~/.zsh_profile
    check_status "Dotfiles setup"
else
    echo "✅ Dotfiles are already set up"
fi

# 5. Install zsh-autosuggestions if not already installed
if ! check_dir_exists ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    check_status "zsh-autosuggestions installation"
else
    echo "✅ zsh-autosuggestions is already installed"
fi

# 6. Install NVM and Node if not already installed
if ! check_dir_exists "$HOME/.nvm"; then
    echo "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    check_status "NVM installation"

    # Load NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

    # Verify NVM installation
    if command -v nvm &> /dev/null; then
        echo "Installing latest Node.js version..."
        nvm install node  # Install latest version
        nvm use node     # Use latest version
        check_status "Node.js installation"

        # Verify Node.js installation
        if command -v node &> /dev/null; then
            node_version=$(node --version)
            echo "✅ Node.js $node_version installed successfully"
        else
            echo "❌ Node.js installation verification failed"
            exit 1
        fi
    else
        echo "❌ NVM installation verification failed"
        exit 1
    fi

    # Add NVM initialization to .zshrc if not already present
    if ! grep -q "export NVM_DIR=\"\$HOME/.nvm\"" ~/.zshrc; then
        echo '# NVM Configuration' >> ~/.zshrc
        echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
        echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.zshrc
        echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> ~/.zshrc
    fi
else
    echo "✅ NVM is already installed"
    # Load NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # Check if Node.js is installed
    if command -v node &> /dev/null; then
        node_version=$(node --version)
        echo "✅ Node.js $node_version is already installed"
    else
        echo "Installing latest Node.js version..."
        nvm install node
        nvm use node
        check_status "Node.js installation"
    fi
fi

echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin' >> ~/.zshrc

echo "🎉 Setup completed successfully!"
echo "Please restart your terminal or run 'source ~/.zshrc' to apply changes."
